import 'package:flutter/material.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const PetFriendApp());
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
