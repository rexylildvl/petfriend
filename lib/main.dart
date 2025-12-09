import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splash_page.dart';

import 'package:flutter/foundation.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  runApp(const PetFriendApp());
}

Future<void> _loadEnv() async {
  // 1. LOGIKA KHUSUS WEB
  // Di web, kita tidak bisa mencari path file secara manual.
  // Flutter akan otomatis mengambil file .env dari folder assets (sesuai pubspec.yaml).
  if (kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
      print("Web Env Loaded");
    } catch (e) {
      print("Warning: Gagal load .env di Web (pastikan file ada di assets): $e");
    }
    return; // Stop eksekusi agar kode di bawah (yang menyebabkan error) tidak dijalankan
  }

  // 2. LOGIKA KHUSUS NATIVE (Windows/Android/iOS)
  // Kode asli Anda dipindahkan ke sini agar aman
  try {
    final exeDir = File(Platform.resolvedExecutable).parent;
    final rootFromExe = exeDir.parent.parent.parent.parent.parent;

    final candidates = <String>[
      '.env', 
      '../.env', 
      '${rootFromExe.path}${Platform.pathSeparator}.env', 
      'build/windows/x64/runner/Debug/.env', 
    ];

    for (final path in candidates) {
      if (File(path).existsSync()) {
        await dotenv.load(fileName: path, isOptional: true);
        print("Env loaded from: $path");
      }
      if ((dotenv.env['GROQ_API_KEY'] ?? '').isNotEmpty) break;
    }
  } catch (e) {
    print("Native Env Error: $e");
  }
}

class PetFriendApp extends StatelessWidget {
  const PetFriendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetFriend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const SplashPage(),
    );
  }
}
