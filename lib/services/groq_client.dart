import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqClient {
  GroqClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
  static const _model = 'llama-3.3-70b-versatile';

  Future<String> send(
    List<Map<String, String>> messages, {
    int maxTokens = 512,
    double temperature = 0.6,
  }) async {
    String? apiKey = dotenv.env['GROQ_API_KEY'];
    apiKey ??= const String.fromEnvironment('GROQ_API_KEY');
    apiKey ??= Platform.environment['GROQ_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GROQ_API_KEY is missing');
    }

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(<String, dynamic>{
        'model': _model,
        'messages': messages,
        'temperature': temperature,
        'max_tokens': maxTokens,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('Groq response empty');
    }

    final content = choices.first['message']['content'] as String?;
    if (content == null || content.isEmpty) {
      throw Exception('Groq response content missing');
    }
    return content;
  }

  void close() {
    _client.close();
  }
}
