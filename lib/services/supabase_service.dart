import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();
  final SupabaseClient _client = Supabase.instance.client;

  Future<SetupResult> ensureSetup() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in');
    }
    await _upsertProfile(userId);
    final pet = await _getOrCreatePet(userId);
    final session = await _getOrCreateSession(userId, pet.id);
    return SetupResult(
      userId: userId,
      petId: pet.id,
      petName: pet.name,
      sessionId: session.id,
    );
  }

  Future<List<MessageRow>> fetchMessages(String sessionId) async {
    final data = await _client
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at')
        .limit(200);

    return (data as List)
        .map((e) => MessageRow.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addMessage({
    required String sessionId,
    required String userId,
    required String role,
    required String content,
    int? tokens,
  }) async {
    await _client.from('chat_messages').insert({
      'session_id': sessionId,
      'user_id': userId,
      'role': role,
      'content': content,
      'tokens': tokens,
    });

    await _client
        .from('chat_sessions')
        .update({'last_message_at': DateTime.now().toIso8601String()})
        .eq('id', sessionId);
  }

  // Internal helpers

  Future<void> _upsertProfile(String userId) async {
    final email = _client.auth.currentUser?.email ?? 'user-$userId@local.app';
    await _client.from('profiles').upsert({
      'id': userId,
      'email': email,
    });
  }

  Future<PetRow> _getOrCreatePet(String userId) async {
    final data = await _client
        .from('pets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (data != null) {
      return PetRow.fromMap(data);
    }

    final insert = await _client.from('pets').insert({
      'user_id': userId,
      'name': 'Bobo',
      'energy': 70,
      'happiness': 80,
      'health': 90,
      'identity_prompt': 'You are Bobo, a friendly virtual bear.',
    }).select().single();

    return PetRow.fromMap(insert);
  }

  Future<SessionRow> _getOrCreateSession(String userId, String petId) async {
    final data = await _client
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (data != null) {
      return SessionRow.fromMap(data);
    }

    final insert = await _client.from('chat_sessions').insert({
      'user_id': userId,
      'pet_id': petId,
      'title': 'Chat with Bobo',
      'status': 'active',
      'summary': null,
      'meta': {},
      'last_message_at': DateTime.now().toIso8601String(),
    }).select().single();

    return SessionRow.fromMap(insert);
  }
}

class SetupResult {
  final String userId;
  final String petId;
  final String petName;
  final String sessionId;

  SetupResult({
    required this.userId,
    required this.petId,
    required this.petName,
    required this.sessionId,
  });
}

class MessageRow {
  final String role;
  final String content;
  final DateTime createdAt;

  MessageRow({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageRow.fromMap(Map<String, dynamic> map) {
    return MessageRow(
      role: map['role'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }
}

class PetRow {
  final String id;
  final String name;

  PetRow({required this.id, required this.name});

  factory PetRow.fromMap(Map<String, dynamic> map) {
    return PetRow(
      id: map['id'] as String,
      name: (map['name'] as String?) ?? 'Bobo',
    );
  }
}

class SessionRow {
  final String id;

  SessionRow({required this.id});

  factory SessionRow.fromMap(Map<String, dynamic> map) {
    return SessionRow(
      id: map['id'] as String,
    );
  }
}
