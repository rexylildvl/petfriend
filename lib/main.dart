import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  runApp(const PetFriendApp());
}

Future<void> _loadEnv() async {
  final exeDir = File(Platform.resolvedExecutable).parent;
  final rootFromExe = exeDir.parent.parent.parent.parent.parent;

  final candidates = <String>[
    '.env', // root saat run via `flutter run`
    '../.env', // jika working dir satu level di bawah root
    '${rootFromExe.path}${Platform.pathSeparator}.env', // naik dari exe ke root proyek
    'build/windows/x64/runner/Debug/.env', // jika sudah disalin ke folder build
  ];

  for (final path in candidates) {
    if (File(path).existsSync()) {
      await dotenv.load(fileName: path, isOptional: true);
    }
    if ((dotenv.env['GROQ_API_KEY'] ?? '').isNotEmpty) break;
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
