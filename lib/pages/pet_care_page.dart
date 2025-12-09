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
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppTheme.accent,
            indicatorWeight: 3,
            labelColor: AppTheme.accent,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Status", icon: Icon(Icons.dashboard_outlined)),
              Tab(text: "Food Shop", icon: Icon(Icons.storefront_outlined)),
              Tab(text: "Activities", icon: Icon(Icons.sports_esports_outlined)),
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
          const SizedBox(height: 25),
          
          Text("Needs & Vitals", style: AppTheme.heading2),
          const SizedBox(height: 15),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStatBar("Hunger", pet.hunger, AppTheme.hungerColor, Icons.restaurant),
                const SizedBox(height: 15),
                _buildStatBar("Energy", pet.energy, AppTheme.energyColor, Icons.bolt),
                const SizedBox(height: 15),
                _buildStatBar("Happiness", pet.happiness, AppTheme.happinessColor, Icons.sentiment_satisfied),
                const SizedBox(height: 15),
                _buildStatBar("Hygiene", pet.hygiene, AppTheme.hygieneColor, Icons.cleaning_services),
                const SizedBox(height: 15),
                _buildStatBar("Bladder", pet.bladder, AppTheme.bladderColor, Icons.water_drop, isInverse: true),
              ],
            ),
          ),
          
          const SizedBox(height: 25),
          Text("Quick Care", style: AppTheme.heading2),
          const SizedBox(height: 15),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(context, "Sleep", Icons.bed, Colors.indigo, () {
                pet.sleep();
                _showSnackBar(context, "${pet.petName} is sleeping!", Colors.indigo);
              }),
              _buildQuickAction(context, "Clean", Icons.wash, AppTheme.hygieneColor, () {
                pet.clean();
                _showSnackBar(context, "${pet.petName} is clean!", AppTheme.hygieneColor);
              }),
              _buildQuickAction(context, "Toilet", Icons.wc, Colors.deepPurple, () {
                pet.useToilet();
                _showSnackBar(context, "${pet.petName} feels relieved!", Colors.deepPurple);
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildInfoCard(PetProvider pet) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryLight, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.petName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Level ${pet.level} • ${pet.growthStageLabel}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: pet.xp / pet.xpToNextLevel,
                    backgroundColor: Colors.black12,
                    color: AppTheme.accent,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "XP: ${pet.xp.toInt()} / ${pet.xpToNextLevel.toInt()}",
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Icon(Icons.monetization_on, color: AppTheme.accent, size: 24),
                const SizedBox(height: 4),
                Text(
                  "${pet.coins}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color, IconData icon, {bool isInverse = false}) {
    // For bladder: 0 is good (empty), 100 is bad (full). 
    // For others: 100 is good, 0 is bad.
    // We want the visual bar to always represent "fullness" of the attribute, 
    // but maybe color code it differently?
    // Actually, usually progress bars show the value. 
    // If isInverse (Bladder), high value is bad.
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    "${value.toInt()}%",
                    style: TextStyle(
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
                  backgroundColor: color.withOpacity(0.1),
                  color: color,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: color.withOpacity(0.1)),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodShopTab extends StatelessWidget {
  final List<Map<String, dynamic>> foods = [
    {'name': 'Honey', 'icon': '🍯', 'price': 10, 'energy': 20, 'desc': 'Sweet treat'},
    {'name': 'Berries', 'icon': '🍓', 'price': 5, 'energy': 10, 'desc': 'Fresh snack'},
    {'name': 'Fish', 'icon': '🐟', 'price': 15, 'energy': 30, 'desc': 'Protein boost'},
    {'name': 'Cake', 'icon': '🍰', 'price': 20, 'energy': 40, 'desc': 'Party time!'},
    {'name': 'Apple', 'icon': '🍎', 'price': 8, 'energy': 15, 'desc': 'Crunchy'},
    {'name': 'Milk', 'icon': '🥛', 'price': 12, 'energy': 25, 'desc': 'Calcium rich'},
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
        childAspectRatio: 0.85,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        final bool canAfford = pet.coins >= food['price'];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(food['icon'], style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                food['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                food['desc'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "+${food['energy']} Energy",
                style: const TextStyle(color: AppTheme.energyColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: canAfford ? () {
                  pet.feed((food['energy'] as int).toDouble());
                  // TODO: Deduct coins in provider
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Fed ${food['name']} to ${pet.petName}!"),
                      backgroundColor: AppTheme.hungerColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        _buildActivityTile(context, pet, "Ball Play", "🏐", 10, "Fun time!", Colors.orange),
        _buildActivityTile(context, pet, "Hide & Seek", "👀", 15, "Where are you?", Colors.blue),
        _buildActivityTile(context, pet, "Swimming", "🏊", 20, "Splash!", Colors.cyan),
        _buildActivityTile(context, pet, "Dancing", "💃", 25, "Groovy!", Colors.purple),
        _buildActivityTile(context, pet, "Reading", "📖", 5, "Smart bear!", Colors.brown),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, PetProvider pet, String title, String icon, int xp, String msg, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          "Earn $xp XP • Uses Energy",
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            pet.play();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: color,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Play"),
        ),
      ),
    );
  }
}