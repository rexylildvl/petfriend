import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../theme/app_theme.dart';

class PetCarePage extends StatelessWidget {
  const PetCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text("Pet Care Center 🐻"),
          centerTitle: true,
          backgroundColor: AppTheme.primaryDark,
          bottom: const TabBar(
            indicatorColor: AppTheme.accent,
            labelColor: AppTheme.accent,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Status"),
              Tab(text: "Food Shop"),
              Tab(text: "Activities"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StatusTab(),
            _FoodShopTab(),
            _ActivitiesTab(),
          ],
        ),
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetProvider>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(pet),
          const SizedBox(height: 20),
          Text("Needs", style: AppTheme.heading2),
          const SizedBox(height: 10),
          _buildStatBar("Hunger", pet.hunger, AppTheme.hungerColor, Icons.restaurant),
          _buildStatBar("Energy", pet.energy, AppTheme.energyColor, Icons.bolt),
          _buildStatBar("Happiness", pet.happiness, AppTheme.happinessColor, Icons.sentiment_satisfied),
          _buildStatBar("Hygiene", pet.hygiene, AppTheme.hygieneColor, Icons.cleaning_services),
          _buildStatBar("Bladder", pet.bladder, AppTheme.bladderColor, Icons.water_drop),
          
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(context, "Sleep", Icons.bed, Colors.indigo, () => pet.sleep()),
              _buildQuickAction(context, "Clean", Icons.wash, AppTheme.hygieneColor, () => pet.clean()),
              _buildQuickAction(context, "Toilet", Icons.wc, Colors.brown, () => pet.useToilet()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(PetProvider pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryLight, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.petName,
                  style: AppTheme.heading1.copyWith(color: Colors.white, fontSize: 24),
                ),
                Text(
                  "Level ${pet.level} • ${pet.growthStageLabel}",
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: pet.xp / pet.xpToNextLevel,
                    backgroundColor: Colors.black26,
                    color: AppTheme.accent,
                    minHeight: 6,
                  ),
                ),
                Text(
                  "XP: ${pet.xp.toInt()} / ${pet.xpToNextLevel.toInt()}",
                  style: const TextStyle(fontSize: 10, color: Colors.white60),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.monetization_on, color: AppTheme.accent, size: 24),
              Text(
                "${pet.coins}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTheme.heading3.copyWith(fontSize: 14),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${value.toInt()}%",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTap();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Action: $label performed!"), duration: const Duration(milliseconds: 500)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _FoodShopTab extends StatelessWidget {
  final List<Map<String, dynamic>> foods = [
    {'name': 'Honey', 'icon': '🍯', 'price': 10, 'energy': 20},
    {'name': 'Berries', 'icon': '🍓', 'price': 5, 'energy': 10},
    {'name': 'Fish', 'icon': '🐟', 'price': 15, 'energy': 30},
    {'name': 'Cake', 'icon': '🍰', 'price': 20, 'energy': 40},
  ];

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetProvider>();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(food['icon'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(
                food['name'],
                style: AppTheme.heading3,
              ),
              Text(
                "+${food['energy']} Energy",
                style: TextStyle(color: AppTheme.energyColor, fontSize: 12),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (pet.coins >= food['price']) {
                    pet.feed((food['energy'] as int).toDouble());
                    // Note: Coin deduction should be implemented in provider
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fed ${food['name']}!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Not enough coins!")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                ),
                child: Text("${food['price']} 🪙"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pet = context.read<PetProvider>();
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildActivityTile(context, pet, "Ball Play", "🏐", 10, "Fun time!"),
        _buildActivityTile(context, pet, "Hide & Seek", "👀", 15, "Where are you?"),
        _buildActivityTile(context, pet, "Swimming", "🏊", 20, "Splash!"),
        _buildActivityTile(context, pet, "Dancing", "💃", 25, "Groovy!"),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, PetProvider pet, String title, String icon, int xp, String msg) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Text(icon, style: const TextStyle(fontSize: 30)),
        title: Text(title, style: AppTheme.heading3),
        subtitle: Text("Earn $xp XP"),
        trailing: ElevatedButton(
          onPressed: () {
            pet.play();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.energyColor),
          child: const Text("Play"),
        ),
      ),
    );
  }
}