import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../theme/app_theme.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'pet_care_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("PetFriend 🐻"),
        backgroundColor: AppTheme.primaryDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person),
            tooltip: "Profile",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildWelcomeCard(pet),

              const SizedBox(height: 25),

              // Pet Display with Animation
              _buildPetDisplay(pet),

              const SizedBox(height: 25),

              // Stats Section
              Text("Pet Stats 📊", style: AppTheme.heading2),
              const SizedBox(height: 15),

              _buildStatBar("Hunger", pet.hunger, AppTheme.hungerColor, Icons.restaurant),
              const SizedBox(height: 12),
              _buildStatBar("Energy", pet.energy, AppTheme.energyColor, Icons.bolt),
              const SizedBox(height: 12),
              _buildStatBar("Happiness", pet.happiness, AppTheme.happinessColor, Icons.sentiment_satisfied),

              const SizedBox(height: 30),

              // Quick Actions
              Text("Quick Actions ⚡", style: AppTheme.heading2),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.restaurant,
                    label: "Feed",
                    color: AppTheme.hungerColor,
                    onTap: () {
                       pet.feed(10); // Simple feed action
                       _showSnackBar("Fed ${pet.petName}! Yummy!", AppTheme.hungerColor);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.sports_baseball,
                    label: "Play",
                    color: AppTheme.energyColor,
                    onTap: () {
                      pet.play();
                      _showSnackBar("Played with ${pet.petName}! Fun!", AppTheme.energyColor);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.cleaning_services,
                    label: "Clean",
                    color: AppTheme.hygieneColor,
                    onTap: () {
                      pet.clean();
                      _showSnackBar("${pet.petName} is sparkling clean!", AppTheme.hygieneColor);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.grid_view_rounded,
                    label: "Care",
                    color: AppTheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PetCarePage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Main Chat Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chat_bubble, size: 24),
                  label: Text(
                    "Chat with ${pet.petName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ChatPage(),
                        transitionDuration: const Duration(milliseconds: 400),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(PetProvider pet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.accentLight, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Friend! 👋",
            style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
          ),
          const SizedBox(height: 5),
          Text(
            "${pet.petName} is ${pet.currentMood.toLowerCase()} and waiting for you!",
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildPetDisplay(PetProvider pet) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryLight.withOpacity(0.3), AppTheme.accentLight.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/bear.png",
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pet.petName,
                    style: AppTheme.heading2,
                  ),
                  Text(
                    "Level ${pet.level} • ${pet.growthStageLabel}",
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(label, style: AppTheme.heading3.copyWith(fontSize: 16)),
              ],
            ),
            Text(
              "${value.toInt()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withOpacity(0.2),
            color: color,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
