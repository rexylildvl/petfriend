# Integrasi Groq API (Llama-3.3-70b-versatile) ke Fitur Chat

Panduan singkat menambahkan Groq API sebagai backend chat menggantikan respons rule-based di `lib/pages/chat_page.dart`.

## 1) Tambahkan dependency
- Di `pubspec.yaml` pada `dependencies`:
  ```yaml
  http: ^1.2.2
  flutter_dotenv: ^5.1.0 # opsional; bisa ganti dengan --dart-define
  ```
- Jalankan `flutter pub get`.

## 2) Simpan kunci API
- Disarankan gunakan `--dart-define` saat build/run:
  ```
  flutter run --dart-define=GROQ_API_KEY=sk-xxx
  ```
- Alternatif `.env` (jika memakai `flutter_dotenv`):
  1. Buat file `.env` (jangan commit) berisi `GROQ_API_KEY=sk-xxx`.
  2. Import `flutter_dotenv` di `main.dart` dan panggil `await dotenv.load();` sebelum `runApp`.

## 3) Buat klien Groq
- Tambahkan file baru `lib/services/groq_client.dart`:
  ```dart
  import 'dart:convert';
  import 'package:http/http.dart' as http;
  // Jika pakai flutter_dotenv, import dotenv. Jika pakai dart-define, gunakan const String.fromEnvironment.
  // import 'package:flutter_dotenv/flutter_dotenv.dart';

  class GroqClient {
    GroqClient({http.Client? client}) : _client = client ?? http.Client();

    final http.Client _client;
    static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
    static const _model = 'llama-3.3-70b-versatile';

    Future<String> send(List<Map<String, String>> messages) async {
      final apiKey =
          const String.fromEnvironment('GROQ_API_KEY'); // ganti ke dotenv.env['GROQ_API_KEY'] jika pakai .env
      if (apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY tidak ditemukan');
      }

      final response = await _client.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.6,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Groq error ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw Exception('Tidak ada respons dari model');
      }
      return choices.first['message']['content'] as String? ?? '';
    }

    void close() {
      _client.close();
    }
  }
  ```

## 4) Pakai di `chat_page.dart`
- Di `_getBearResponse`, ubah untuk memanggil Groq:
  ```dart
  final client = GroqClient();
  // Simpan riwayat pesan jika ingin konteks, mis. dari `_messages`.
  final response = await client.send([
    {'role': 'system', 'content': 'You are Bobo the friendly virtual bear.'},
    {'role': 'user', 'content': userMessage},
  ]);
  setState(() {
    _messages.add(ChatMessage(text: response, isUser: false, time: DateTime.now()));
  });
  client.close();
  ```
- Tambahkan error handling (try/catch) dan tampilkan SnackBar bila gagal.
- Pertimbangkan untuk memetakan seluruh riwayat chat ke format OpenAI/Groq: setiap pesan user => `role: user`, pesan beruang => `role: assistant`.

## 5) Catatan & batasan
- Streaming belum diaktifkan; jika perlu, gunakan endpoint `stream: true` dan konsumsi stream.
- Tanpa persistensi, riwayat chat hilang setelah app ditutup.
- Perhatikan biaya/kuota Groq; implementasikan rate-limit dan batasi panjang riwayat.
- Jangan commit kunci API; gunakan dart-define atau dotenv yang di-ignore git.
