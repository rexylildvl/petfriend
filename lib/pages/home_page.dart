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

  // Local state for sleep mode UI toggle
  bool _isSleeping = false;

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

  void _showFeedOptions(PetProvider pet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Choose Food",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFoodOption(pet, "Honey", "Sweet and energizing", Icons.water_drop, Colors.amber, 25, 15),
                    const SizedBox(height: 12),
                    _buildFoodOption(pet, "Fish", "Protein-rich meal", Icons.set_meal, Colors.blue, 20, 10),
                    const SizedBox(height: 12),
                    _buildFoodOption(pet, "Berries", "Fresh and healthy", Icons.spa, Colors.purple, 15, 20),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSleepMode(PetProvider pet) {
    setState(() {
      _isSleeping = !_isSleeping;
      if (_isSleeping) {
        pet.sleep(); // Use provider method
        _animationController.stop();
      } else {
        _animationController.repeat(reverse: true);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSleeping ? "Goodnight! Your bear is sleeping 😴" : "Good morning! Your bear is awake!",
        ),
        backgroundColor: _isSleeping ? Colors.indigo[600] : Colors.amber[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFoodOption(PetProvider pet, String name, String description, IconData icon, Color color, double energyGain, double happinessGain) {
    bool isHungry = pet.hunger < 40;
    return InkWell(
      onTap: () {
        pet.feed(energyGain);
        Navigator.pop(context);

        String message = "Yummy! Your bear enjoyed the $name";
        if (isHungry) {
          message += " and is no longer hungry!";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.brown[600],
                    ),
                  ),
                  if (isHungry && (name == "Honey" || name == "Fish"))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Great for hungry bears!",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _healPet(PetProvider pet) {
    pet.clean();
    String message = "Your bear feels much better now";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetProvider>();
    
    bool isHungry = pet.hunger < 40;
    bool isSick = pet.hygiene < 40;

    String bearStatus = pet.currentMood;
    Color statusColor = Colors.green;

    if (_isSleeping) {
      bearStatus = "Sleeping peacefully";
      statusColor = Colors.blue;
    } else if (isSick) {
      bearStatus = "Feeling sick";
      statusColor = Colors.orange;
    } else if (isHungry) {
      bearStatus = "Hungry";
      statusColor = Colors.orange;
    } else if (pet.energy < 30) {
      bearStatus = "Tired";
      statusColor = Colors.orange;
    } else if (pet.happiness < 50) {
      bearStatus = "Sad";
      statusColor = Colors.red;
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: _isSleeping ? Colors.grey[900] : const Color(0xFFF8F0E3),
          appBar: AppBar(
            title: const Text(
              "PetFriend",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            backgroundColor: _isSleeping ? Colors.grey[800] : Colors.brown[700],
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                icon: const Icon(Icons.person_outline),
                tooltip: "Profile",
              ),
            ],
          ),
          body: Column(
            children: [
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isSleeping
                                ? [Colors.grey[800]!, Colors.grey[700]!]
                                : [
                                    Colors.brown.shade700,
                                    Colors.brown.shade500,
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _isSleeping
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.brown.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isSleeping
                                      ? Icons.nightlight_round
                                      : isSick
                                          ? Icons.medical_services
                                          : isHungry
                                              ? Icons.restaurant
                                              : Icons.waving_hand,
                                  color: _isSleeping
                                      ? Colors.blue[200]
                                      : isSick
                                          ? Colors.orange[300]
                                          : isHungry
                                              ? Colors.amber[300]
                                              : Colors.amber[300],
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _isSleeping
                                        ? "Shhh... ${pet.petName} is sleeping"
                                        : "Hello, Friend!",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _isSleeping
                                        ? "Let's keep it quiet until morning"
                                        : "Your virtual bear is $bearStatus",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: statusColor.withOpacity(0.5)),
                                  ),
                                  child: Text(
                                    bearStatus,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
                            colors: _isSleeping
                                ? [Colors.grey[800]!, Colors.grey[600]!]
                                : isSick
                                    ? [
                                        Colors.orange.shade100,
                                        Colors.red.shade100
                                      ]
                                    : isHungry
                                        ? [
                                            Colors.amber.shade100,
                                            Colors.orange.shade100
                                          ]
                                        : [
                                            Colors.brown.shade100,
                                            Colors.orange.shade100,
                                          ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: _isSleeping
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.brown.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isSleeping
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/bear.png',
                                          fit: BoxFit.cover,
                                          color: Colors.grey[400],
                                          colorBlendMode: BlendMode.saturation,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Zzz...",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[200],
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${pet.petName} is sleeping",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                )
                              : AnimatedBuilder(
                                  animation: _bounceAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _bounceAnimation.value),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.brown
                                                      .withOpacity(0.2),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/bear.png',
                                                fit: BoxFit.cover,
                                                color: isSick
                                                    ? Colors.orange[300]
                                                    : isHungry
                                                        ? Colors.amber[600]
                                                        : null,
                                                colorBlendMode:
                                                    isSick || isHungry
                                                        ? BlendMode.color
                                                        : null,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            pet.petName,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: isSick
                                                  ? Colors.orange[800]
                                                  : isHungry
                                                      ? Colors.amber[800]
                                                      : Colors.brown[800],
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Level ${pet.level} • ${pet.growthStageLabel}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isSick
                                                  ? Colors.orange[600]
                                                  : isHungry
                                                      ? Colors.amber[600]
                                                      : Colors.brown[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Stats Section
                      Row(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: _isSleeping
                                ? Colors.grey[300]
                                : Colors.brown[800],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Pet Statistics",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isSleeping
                                  ? Colors.grey[300]
                                  : Colors.brown[800],
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isSleeping ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _isSleeping
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.brown.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildStatBar(
                              "Energy",
                              pet.energy / 100, 
                              isHungry
                                  ? Colors.orange[600]!
                                  : Colors.amber[600]!,
                              isHungry
                                  ? Icons.battery_alert
                                  : Icons.battery_charging_full,
                              isCritical: pet.energy < 30,
                            ),
                            const SizedBox(height: 16),
                            _buildStatBar(
                              "Happiness",
                              pet.happiness / 100,
                              pet.happiness < 50
                                  ? Colors.red[400]!
                                  : Colors.pink[400]!,
                              pet.happiness < 50
                                  ? Icons.sentiment_dissatisfied
                                  : Icons.sentiment_satisfied_alt,
                              isCritical: pet.happiness < 40,
                            ),
                            const SizedBox(height: 16),
                            _buildStatBar(
                              "Hygiene",
                              pet.hygiene / 100,
                              isSick ? Colors.orange[600]! : Colors.green[500]!,
                              isSick ? Icons.medical_services : Icons.cleaning_services,
                              isCritical: pet.hygiene < 50,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Quick Actions
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            color: _isSleeping
                                ? Colors.grey[300]
                                : Colors.brown[800],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Quick Actions",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isSleeping
                                  ? Colors.grey[300]
                                  : Colors.brown[800],
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (isHungry && !_isSleeping)
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 14, color: Colors.orange[800]),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Feed me!",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.restaurant_outlined,
                              label: "Feed",
                              color: Colors.amber[600]!,
                              onTap: _isSleeping ? null : () => _showFeedOptions(pet),
                              isHighlighted: isHungry && !_isSleeping,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              icon: _isSleeping
                                  ? Icons.wb_sunny_outlined
                                  : Icons.nights_stay_outlined,
                              label: _isSleeping ? "Wake Up" : "Sleep",
                              color: _isSleeping
                                  ? Colors.blue[200]!
                                  : Colors.indigo[600]!,
                              onTap: () => _toggleSleepMode(pet),
                              isHighlighted: pet.energy < 30 && !_isSleeping,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.cleaning_services_outlined,
                              label: "Clean",
                              color: Colors.green[500]!,
                              onTap: _isSleeping ? null : () => _healPet(pet),
                              isHighlighted: isSick && !_isSleeping,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30), // Extra space
                    ],
                  ),
                ),
              ),

              // Fixed Chat Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isSleeping ? Colors.grey[900] : const Color(0xFFF8F0E3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSleeping ? Colors.grey[700] : Colors.brown[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      shadowColor: _isSleeping
                          ? Colors.black.withOpacity(0.3)
                          : Colors.brown.withOpacity(0.3),
                    ),
                    onPressed: _isSleeping
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const ChatPage(),
                                transitionDuration:
                                    const Duration(milliseconds: 400),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 24,
                          color: _isSleeping ? Colors.grey[400] : Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isSleeping
                              ? "Bear is sleeping..."
                              : "Chat with Your Bear",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            color:
                                _isSleeping ? Colors.grey[300] : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sleep Overlay
        if (_isSleeping)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/bear.png',
                        fit: BoxFit.cover,
                        color: Colors.grey[400],
                        colorBlendMode: BlendMode.saturation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Sleep Mode",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[200],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${pet.petName} is sleeping peacefully",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => _toggleSleepMode(pet),
                    icon: const Icon(Icons.wb_sunny_outlined),
                    label: const Text("Wake Up"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatBar(String label, double value, Color color, IconData icon,
      {bool isCritical = false}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isSleeping ? Colors.grey[700] : color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              icon,
              color: _isSleeping ? color.withOpacity(0.7) : color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _isSleeping
                              ? Colors.grey[300]
                              : Colors.brown[800],
                        ),
                      ),
                      if (isCritical && !_isSleeping)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: const Text(
                              "LOW",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    "${(value * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _isSleeping ? color.withOpacity(0.8) : color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: _isSleeping
                      ? Colors.grey[700]
                      : color.withOpacity(0.15),
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

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: _isSleeping ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHighlighted
                  ? color.withOpacity(0.8)
                  : _isSleeping
                      ? color.withOpacity(0.5)
                      : color.withOpacity(0.3),
              width: isHighlighted ? 3 : 2,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: _isSleeping
                          ? Colors.black.withOpacity(0.3)
                          : color.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isSleeping
                          ? Colors.grey[700]
                          : color.withOpacity(isHighlighted ? 0.25 : 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _isSleeping
                          ? Colors.grey[300]
                          : Colors.brown[800],
                    ),
                  ),
                ],
              ),
              if (isHighlighted && !_isSleeping)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.priority_high,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
