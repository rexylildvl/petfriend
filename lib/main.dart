import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'theme/app_theme.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  await _initSupabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const PetFriendApp(),
    ),
  );
}

Future<void> _loadEnv() async {
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
    }
  }

  final groqKey = _readGroqKey();

  if (groqKey == null || groqKey.isEmpty) {
    throw Exception('GROQ_API_KEY tidak ada. Set di .env, dart-define, atau env OS.');
  }
}

Future<void> _initSupabase() async {
  final supabaseUrl = _readSupabaseUrl();
  // prefer service_role if provided, else anon
  String? supabaseKey = _readSupabaseServiceKey();
  if (supabaseKey == null || supabaseKey.isEmpty) {
    supabaseKey = _readSupabaseAnonKey();
  }

  if (supabaseUrl == null ||
      supabaseUrl.isEmpty ||
      supabaseKey == null ||
      supabaseKey.isEmpty) {
    throw Exception(
        'Supabase URL/Key kosong. Set SUPABASE_URL dan SUPABASE_ANON_KEY (atau SUPABASE_SERVICE_ROLE_KEY).');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
}

String? _readGroqKey() {
  final v1 = dotenv.env['GROQ_API_KEY'];
  if (v1 != null && v1.isNotEmpty) return v1;
  const v2 = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  if (v2.isNotEmpty) return v2;
  final v3 = Platform.environment['GROQ_API_KEY'];
  if (v3 != null && v3.isNotEmpty) return v3;
  return null;
}

String? _readSupabaseUrl() {
  final v1 = dotenv.env['SUPABASE_URL'];
  if (v1 != null && v1.isNotEmpty) return v1;
  const v2 = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  if (v2.isNotEmpty) return v2;
  final v3 = Platform.environment['SUPABASE_URL'];
  if (v3 != null && v3.isNotEmpty) return v3;
  return null;
}

String? _readSupabaseAnonKey() {
  final v1 = dotenv.env['SUPABASE_ANON_KEY'];
  if (v1 != null && v1.isNotEmpty) return v1;
  const v2 = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  if (v2.isNotEmpty) return v2;
  final v3 = Platform.environment['SUPABASE_ANON_KEY'];
  if (v3 != null && v3.isNotEmpty) return v3;
  return null;
}

String? _readSupabaseServiceKey() {
  final v1 = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];
  if (v1 != null && v1.isNotEmpty) return v1;
  const v2 = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY', defaultValue: '');
  if (v2.isNotEmpty) return v2;
  final v3 = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (v3 != null && v3.isNotEmpty) return v3;
  return null;
}

class PetFriendApp extends StatelessWidget {
  const PetFriendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetFriend',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null) {
            return const LoginPage();
          }
          return const SplashPage();
        },
      ),
    );
  }
}
