import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  String _bearName = "Bobo";
  String _userName = "Friend";

  @override
  void initState() {
    super.initState();
    // Pesan pembuka dari beruang - FIXED: menggunakan _bearName
    _messages.add(
      ChatMessage(
        text: "Hi there! I'm $_bearName! What should I call you?", // Changed from $bearName to $_bearName
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Tambah pesan user
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          time: DateTime.now(),
        ),
      );
    });

    // Simpan nama user jika pesan pertama
    if (_messages.length == 2) {
      _userName = text;
    }

    _messageController.clear();

    // Scroll ke bawah
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Respon dari beruang (simulasi AI)
    _getBearResponse(text);
  }

  void _getBearResponse(String userMessage) {
    String response = "";

    // Simple response logic
    if (userMessage.toLowerCase().contains("hello") ||
        userMessage.toLowerCase().contains("hi")) {
      response = "Hello $_userName! How are you today? 🐻";
    } else if (userMessage.toLowerCase().contains("how are you")) {
      response = "I'm doing great! Thanks for asking! I could use some honey though... 🍯";
    } else if (userMessage.toLowerCase().contains("hungry")) {
      response = "I'm always hungry! Can you feed me some berries? 🍓";
    } else if (userMessage.toLowerCase().contains("play")) {
      response = "Yay! I love playing! Let's go find some adventure! 🌲";
    } else if (userMessage.toLowerCase().contains("love")) {
      response = "Aww, I love you too $_userName! You're my best friend! 💖";
    } else if (userMessage.toLowerCase().contains("sleep")) {
      response = "I'm getting sleepy too... *yawns* Time for a nap! 😴";
    } else if (userMessage.toLowerCase().contains("name")) {
      response = "My name is $_bearName! I'm your virtual bear friend!"; // Fixed here too
    } else {
      List<String> randomResponses = [
        "That's interesting! Tell me more!",
        "I'm listening, $_userName! 👂",
        "Wow! Really? 🐻",
        "I love chatting with you!",
        "Let's go on an adventure together!",
        "Do you have any honey? I'm craving some!",
        "I'm here for you always!",
        "What should we do today?"
      ];
      response = randomResponses[DateTime.now().millisecond % randomResponses.length];
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              time: DateTime.now(),
            ),
          );
        });

        // Scroll ke bawah lagi
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: const Icon(
                Icons.pets,
                color: Colors.brown,
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
                color: message.isUser
                    ? Colors.brown.shade600
                    : Colors.amber.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                          ? Colors.amber.shade200
                          : Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: message.isUser
                          ? Colors.white
                          : Colors.brown.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Colors.amber.shade200
                          : Colors.brown.shade500,
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
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.brown,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: const Icon(
                Icons.pets,
                color: Colors.brown,
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
                  "Online • Tap for status",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.brown.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.brown[700],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Chat Info"),
                  content: const Text(
                      "This is your virtual bear friend! "
                          "Chat naturally and build your friendship. "
                          "The bear will remember your name and respond to your messages."
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
          // Status Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.amber.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green.shade500,
                  size: 12,
                ),
                const SizedBox(width: 6),
                Text(
                  "$_bearName is typing...", // Fixed here too
                  style: TextStyle(
                    color: Colors.brown.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.brown.shade200,
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
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.amber.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Add emoji/sticker
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              height: 200,
                              padding: const EdgeInsets.all(16),
                              child: GridView.count(
                                crossAxisCount: 6,
                                children: const [
                                  Text("🐻", style: TextStyle(fontSize: 24)),
                                  Text("🍯", style: TextStyle(fontSize: 24)),
                                  Text("🌲", style: TextStyle(fontSize: 24)),
                                  Text("🍓", style: TextStyle(fontSize: 24)),
                                  Text("💖", style: TextStyle(fontSize: 24)),
                                  Text("🌟", style: TextStyle(fontSize: 24)),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.brown.shade600,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade600,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}