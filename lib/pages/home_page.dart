import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'pet_care_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  double _energyLevel = 0.7;
  double _happinessLevel = 0.8;
  double _healthLevel = 0.9;
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

  void _feedPet() {
    setState(() {
      _energyLevel = (_energyLevel + 0.15).clamp(0.0, 1.0);
      _happinessLevel = (_happinessLevel + 0.1).clamp(0.0, 1.0);
    });

    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Yummy! Your bear is happy! 🍯"),
        backgroundColor: Colors.amber[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _playWithPet() {
    setState(() {
      _happinessLevel = (_happinessLevel + 0.2).clamp(0.0, 1.0);
      _energyLevel = (_energyLevel - 0.1).clamp(0.0, 1.0);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Fun time! Your bear loves playing! 🎈"),
        backgroundColor: Colors.blue[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _healPet() {
    setState(() {
      _healthLevel = 1.0;
      _energyLevel = (_energyLevel + 0.05).clamp(0.0, 1.0);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Your bear feels much better now! 💖"),
        backgroundColor: Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0E3),
      appBar: AppBar(
        title: const Text(
          "PetFriend 🐻",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[700],
        elevation: 10,
        shadowColor: Colors.brown.withOpacity(0.4),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade100,
                      Colors.orange.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, Pet Friend! 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Your virtual bear is waiting for you!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Pet Display with Animation
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown.shade100,
                      Colors.orange.shade100,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
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
                              "Bobo the Bear",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.brown[800],
                              ),
                            ),
                            Text(
                              "Level 5 • Best Friend",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.brown[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Stats Section
              Text(
                "Pet Stats 📊",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(height: 15),

              _buildStatBar("Energy", _energyLevel, Colors.amber),
              const SizedBox(height: 12),
              _buildStatBar("Happiness", _happinessLevel, Colors.pink),
              const SizedBox(height: 12),
              _buildStatBar("Health", _healthLevel, Colors.green),

              const SizedBox(height: 30),

              // Quick Actions
              Text(
                "Quick Actions ⚡",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.restaurant,
                    label: "Feed",
                    color: Colors.amber,
                    onTap: _feedPet,
                  ),
                  _buildActionButton(
                    icon: Icons.sports_baseball,
                    label: "Play",
                    color: Colors.blue,
                    onTap: _playWithPet,
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    label: "Heal",
                    color: Colors.red,
                    onTap: _healPet,
                  ),
                  _buildActionButton(
                    icon: Icons.auto_awesome,
                    label: "More",
                    color: Colors.purple,
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
                  label: const Text(
                    "Chat with Your Bear",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: Colors.brown.withOpacity(0.4),
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

              const SizedBox(height: 15),

              // Last Activity
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.brown[600]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Last chat: 2 hours ago",
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Chip(
                      label: const Text("Active"),
                      backgroundColor: Colors.green.shade100,
                      labelStyle: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.brown[700],
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.2),
          color: color,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
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
            color: Colors.brown[700],
          ),
        ),
      ],
    );
  }
}

// Placeholder pages untuk sekarang
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text("Profile Page - Coming Soon"),
      ),
    );
  }
}

class PetCarePage extends StatelessWidget {
  const PetCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Care"),
      ),
      body: const Center(
        child: Text("Pet Care Page - Coming Soon"),
      ),
    );
  }
}