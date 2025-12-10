import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';
import 'pet_setup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _initData();
  }

  Future<void> _initData() async {
    try {
      final hasPet = await SupabaseService.instance.userHasPet();
      if (!mounted) return;

      if (!hasPet) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PetSetupPage()),
        );
        return;
      }

      final setup = await SupabaseService.instance.ensureSetup();

      if (!mounted) return;
      context.read<PetProvider>().init(setup.userId, setup.petName);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      debugPrint("Error initializing data: $e");
      // Handle error (maybe show logout button)
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Image.asset(
                    "assets/bear.png",
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      Text(
                        "PetFriend",
                        style: AppTheme.heading1.copyWith(
                          fontSize: 36,
                          letterSpacing: 1.2,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Loading your pet...",
                        style: AppTheme.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const CircularProgressIndicator(color: AppTheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
