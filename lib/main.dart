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
  final rootFromExe =
      exeDir.parent.parent.parent.parent.parent;

  final candidates = <String>[
    '.env',
    '../.env',
    '${rootFromExe.path}${Platform.pathSeparator}.env',
    'build/windows/x64/runner/Debug/.env',
  ];

  bool loaded = false;

  for (final path in candidates) {
    if (File(path).existsSync()) {
      await dotenv.load(fileName: path);
      loaded = true;
      break;
    }
  }

  if (!loaded) {
    throw Exception('File .env tidak ditemukan di semua path!');
  }

  if ((dotenv.env['GROQ_API_KEY'] ?? '').isEmpty) {
    throw Exception('GROQ_API_KEY tidak ada di file .env!');
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
