import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/groq_client.dart';
import '../services/supabase_service.dart';
import '../providers/pet_provider.dart';
import '../theme/app_theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GroqClient _groqClient = GroqClient();
  final List<ChatMessage> _messages = [];

  String _bearName = 'Bobo';
  String _userName = 'Friend';
  bool _isSending = false;
  bool _isLoading = true;
  String? _sessionId;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    try {
      final setup = await SupabaseService.instance.ensureSetup();
      _sessionId = setup.sessionId;
      _userId = setup.userId;
      _bearName = setup.petName;

      final history = await SupabaseService.instance.fetchMessages(setup.sessionId);

      _messages.clear();
      if (history.isNotEmpty) {
        _messages.addAll(history.map(
          (m) => ChatMessage(
            text: m.content,
            isUser: m.role == 'user',
            time: m.createdAt,
          ),
        ));
      } else {
        _messages.add(
          ChatMessage(
            text: "Hi there! I'm $_bearName! What should I call you?",
            isUser: false,
            time: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load chat data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_isSending || _isLoading || _sessionId == null || _userId == null) {
      return;
    }
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          time: DateTime.now(),
        ),
      );
      _isSending = true;
    });

    if (_messages.length == 2) {
      _userName = text;
    }

    await SupabaseService.instance.addMessage(
      sessionId: _sessionId!,
      userId: _userId!,
      role: 'user',
      content: text,
    );

    _messageController.clear();
    _scrollToBottom();
    await _getBearResponse(text);
    if (mounted) {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _getBearResponse(String userMessage) async {
    try {
      final history = _buildLimitedHistory();
      final pet = context.read<PetProvider>();

      final systemPrompt = '''
You are ${pet.petName}, a virtual bear.
Current Stats:
- Hunger: ${pet.hunger.toInt()}/100
- Energy: ${pet.energy.toInt()}/100
- Happiness: ${pet.happiness.toInt()}/100
- Hygiene: ${pet.hygiene.toInt()}/100
- Bladder: ${pet.bladder.toInt()}/100 (High is bad)
- Level: ${pet.level} (${pet.growthStageLabel})
- Mood: ${pet.currentMood}

Instructions:
- Roleplay as ${pet.petName}.
- Your mood is ${pet.currentMood}. Reflect this in your tone.
- If you are hungry (Hunger < 30), complain about food.
- If you are tired (Energy < 30), say you want to sleep.
- If you need the toilet (Bladder > 80), say you need to go to the bathroom!
- If you are dirty (Hygiene < 30), ask for a bath.
- As a ${pet.growthStageLabel}, speak appropriately for your age.
- Keep responses short and fun (under 2 sentences usually).
''';

      final response = await _groqClient.send(<Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': systemPrompt,
        },
        ...history,
      ], maxTokens: 512, temperature: 0.7);

      if (!mounted) return;
      final botMessage = ChatMessage(
        text: response.trim(),
        isUser: false,
        time: DateTime.now(),
      );
      setState(() {
        _messages.add(botMessage);
      });
      if (_sessionId != null && _userId != null) {
        await SupabaseService.instance.addMessage(
          sessionId: _sessionId!,
          userId: _userId!,
          role: 'assistant',
          content: botMessage.text,
        );
      }
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load response: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0.0, // Scroll to bottom (start of reversed list)
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  List<Map<String, String>> _buildLimitedHistory() {
    const maxMessages = 12;
    const maxCharsPerMessage = 500;
    final start = _messages.length > maxMessages ? _messages.length - maxMessages : 0;
    return _messages
        .sublist(start)
        .map(
          (m) => <String, String>{
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.text.length > maxCharsPerMessage
                ? m.text.substring(0, maxCharsPerMessage)
                : m.text,
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accent),
              ),
              child: const Icon(
                Icons.pets,
                color: AppTheme.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bearName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Online - Tap for status",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Chat Info"),
                  content: const Text(
                    "This is your virtual bear friend! Chat naturally and build your friendship. The bear will remember your name and respond to your messages.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: AppTheme.primaryLight.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: _isSending ? Colors.green.shade500 : Colors.grey,
                  size: 12,
                ),
                const SizedBox(width: 6),
                Text(
                  _isSending
                      ? "$_bearName is typing..."
                      : "Say hi to $_bearName",
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true, // Chat starts from bottom
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        // Reverse index to show newest at bottom
                        final reversedIndex = _messages.length - 1 - index;
                        return _buildMessageBubble(_messages[reversedIndex]);
                      },
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_isSending && !_isLoading,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _isSending || _isLoading
                        ? Colors.grey
                        : AppTheme.primary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _isSending || _isLoading ? null : _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.pets,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isUser ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      message.isUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight:
                      message.isUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.isUser ? "You" : _bearName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: message.isUser
                          ? Colors.white70
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          message.isUser ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Colors.white60
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _groqClient.close();
    super.dispose();
  }
}
