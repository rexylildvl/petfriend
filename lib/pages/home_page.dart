import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'profile_page.dart';

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

  // State untuk sleep mode
  bool _isSleeping = false;
  bool _isHungry = true; // Bear lapar secara default
  bool _isSick = false; // Bear sehat secara default

  // User name (temporary, will be dynamic later)
  String userName = "John Anderson";

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

    // Update kondisi bear secara berkala
    _startConditionUpdates();
  }

  void _startConditionUpdates() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          // Energy menurun seiring waktu
          _energyLevel = (_energyLevel - 0.05).clamp(0.0, 1.0);

          // Happiness menurun jika energy rendah
          if (_energyLevel < 0.3) {
            _happinessLevel = (_happinessLevel - 0.1).clamp(0.0, 1.0);
          }

          // Health menurun jika energy sangat rendah
          if (_energyLevel < 0.2) {
            _healthLevel = (_healthLevel - 0.05).clamp(0.0, 1.0);
          }

          // Update status kondisi
          _isHungry = _energyLevel < 0.4;
          _isSick = _healthLevel < 0.5;
        });
        _startConditionUpdates();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showFeedOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
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
                    _buildFoodOption(
                      "Honey",
                      "Sweet and energizing",
                      Icons.water_drop,
                      Colors.amber,
                      0.25, // Energy gain tinggi
                      0.15, // Happiness gain sedang
                    ),
                    const SizedBox(height: 12),
                    _buildFoodOption(
                      "Fish",
                      "Protein-rich meal",
                      Icons.set_meal,
                      Colors.blue,
                      0.20, // Energy gain sedang
                      0.10, // Happiness gain rendah
                    ),
                    const SizedBox(height: 12),
                    _buildFoodOption(
                      "Berries",
                      "Fresh and healthy",
                      Icons.spa,
                      Colors.purple,
                      0.15, // Energy gain rendah
                      0.20, // Happiness gain tinggi
                    ),
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

  void _toggleSleepMode() {
    setState(() {
      _isSleeping = !_isSleeping;
      if (_isSleeping) {
        // Saat tidur, energy bertambah banyak, happiness sedikit
        _energyLevel = (_energyLevel + 0.4).clamp(0.0, 1.0);
        _happinessLevel = (_happinessLevel + 0.05).clamp(0.0, 1.0);

        // Health bisa membaik jika tidur cukup
        if (_energyLevel > 0.7) {
          _healthLevel = (_healthLevel + 0.1).clamp(0.0, 1.0);
        }

        _animationController.stop();
      } else {
        // Saat bangun, sedikit kehilangan energy
        _energyLevel = (_energyLevel - 0.05).clamp(0.0, 1.0);
        _animationController.repeat(reverse: true);
      }

      // Update kondisi setelah perubahan
      _updateConditions();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSleeping
              ? "Goodnight! Your bear is sleeping 😴"
              : "Good morning! Your bear is awake!",
        ),
        backgroundColor: _isSleeping ? Colors.indigo[600] : Colors.amber[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFoodOption(String name, String description, IconData icon, Color color, double energyGain, double happinessGain) {
    return InkWell(
      onTap: () {
        setState(() {
          // Bonus jika bear sangat lapar
          if (_isHungry) {
            energyGain *= 1.5;
            happinessGain *= 1.3;
          }

          _energyLevel = (_energyLevel + energyGain).clamp(0.0, 1.0);
          _happinessLevel = (_happinessLevel + happinessGain).clamp(0.0, 1.0);

          // Health bisa membaik jika makan makanan sehat
          if (name == "Berries" || name == "Fish") {
            _healthLevel = (_healthLevel + 0.05).clamp(0.0, 1.0);
          }

          _updateConditions();
        });
        Navigator.pop(context);

        String message = "Yummy! Your bear enjoyed the $name";
        if (_isHungry) {
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
                  if (_isHungry && (name == "Honey" || name == "Fish"))
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

  void _healPet() {
    setState(() {
      _healthLevel = 1.0;
      // Energy sedikit bertambah karena perawatan
      _energyLevel = (_energyLevel + 0.1).clamp(0.0, 1.0);
      // Happiness bertambah karena perawatan
      _happinessLevel = (_happinessLevel + 0.15).clamp(0.0, 1.0);

      _updateConditions();
    });

    String message = "Your bear feels much better now";
    if (_isSick) {
      message = "Your bear is healed and feeling great!";
    }

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

  void _updateConditions() {
    setState(() {
      _isHungry = _energyLevel < 0.4;
      _isSick = _healthLevel < 0.6;
    });
  }

  @override
  Widget build(BuildContext context) {
    String bearStatus = "Happy and playful";
    Color statusColor = Colors.green;

    if (_isSleeping) {
      bearStatus = "Sleeping peacefully";
      statusColor = Colors.blue;
    } else if (_isSick) {
      bearStatus = "Feeling sick";
      statusColor = Colors.orange;
    } else if (_isHungry) {
      bearStatus = "Hungry";
      statusColor = Colors.orange;
    } else if (_energyLevel < 0.3) {
      bearStatus = "Tired";
      statusColor = Colors.orange;
    } else if (_happinessLevel < 0.5) {
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card dengan status bear
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
                              _isSleeping ? Icons.nightlight_round :
                              _isSick ? Icons.medical_services :
                              _isHungry ? Icons.restaurant :
                              Icons.waving_hand,
                              color: _isSleeping ? Colors.blue[200] :
                              _isSick ? Colors.orange[300] :
                              _isHungry ? Colors.amber[300] :
                              Colors.amber[300],
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isSleeping
                                    ? "Shhh... Your bear is sleeping"
                                    : "Hello, $userName",
                                style: TextStyle(
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: statusColor.withOpacity(0.5)),
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
                            : _isSick
                            ? [Colors.orange.shade100, Colors.red.shade100]
                            : _isHungry
                            ? [Colors.amber.shade100, Colors.orange.shade100]
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
                                  color: Colors.black.withOpacity(0.3),
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
                            "Bruno is sleeping",
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.brown.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/bear.png',
                                      fit: BoxFit.cover,
                                      color: _isSick
                                          ? Colors.orange[300]
                                          : _isHungry
                                          ? Colors.amber[600]
                                          : null,
                                      colorBlendMode: _isSick || _isHungry
                                          ? BlendMode.color
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Bruno",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _isSick
                                        ? Colors.orange[800]
                                        : _isHungry
                                        ? Colors.amber[800]
                                        : Colors.brown[800],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  bearStatus,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isSick
                                        ? Colors.orange[600]
                                        : _isHungry
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
                        color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Pet Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
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
                          _energyLevel,
                          _isHungry ? Colors.orange[600]! : Colors.amber[600]!,
                          _isHungry ? Icons.battery_alert : Icons.battery_charging_full,
                          isCritical: _energyLevel < 0.3,
                        ),
                        const SizedBox(height: 16),
                        _buildStatBar(
                          "Happiness",
                          _happinessLevel,
                          _happinessLevel < 0.5 ? Colors.red[400]! : Colors.pink[400]!,
                          _happinessLevel < 0.5 ? Icons.sentiment_dissatisfied : Icons.sentiment_satisfied_alt,
                          isCritical: _happinessLevel < 0.4,
                        ),
                        const SizedBox(height: 16),
                        _buildStatBar(
                          "Health",
                          _healthLevel,
                          _isSick ? Colors.orange[600]! : Colors.green[500]!,
                          _isSick ? Icons.medical_services : Icons.favorite,
                          isCritical: _healthLevel < 0.5,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Quick Actions dengan saran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Quick Actions",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      if (_isHungry && !_isSleeping)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 14, color: Colors.orange[800]),
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
                          onTap: _isSleeping ? null : _showFeedOptions,
                          isHighlighted: _isHungry && !_isSleeping,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionCard(
                          icon: _isSleeping ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                          label: _isSleeping ? "Wake Up" : "Sleep",
                          color: _isSleeping ? Colors.blue[200]! : Colors.indigo[600]!,
                          onTap: _toggleSleepMode,
                          isHighlighted: _energyLevel < 0.3 && !_isSleeping,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.medical_services_outlined,
                          label: "Heal",
                          color: Colors.green[500]!,
                          onTap: _isSleeping ? null : _healPet,
                          isHighlighted: _isSick && !_isSleeping,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Main Chat Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSleeping ? Colors.grey[700] : Colors.brown[700],
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
                      onPressed: _isSleeping ? null : () {
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
                            _isSleeping ? "Bear is sleeping..." : "Chat with Your Bear",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              color: _isSleeping ? Colors.grey[300] : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Overlay gelap saat sleep mode
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
                    "Your bear is sleeping peacefully",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _toggleSleepMode,
                    icon: const Icon(Icons.wb_sunny_outlined),
                    label: const Text("Wake Up"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatBar(String label, double value, Color color, IconData icon, {bool isCritical = false}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isSleeping ? Colors.grey[700] : color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center( // PASTIKAN MENGGUNAKAN CENTER
            child: Icon(
              icon,
              color: _isSleeping ? color.withOpacity(0.7) : color,
              size: 24, // Perbesar sedikit ukurannya
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
                          color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
                        ),
                      ),
                      if (isCritical && !_isSleeping)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: Text(
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
                      color: _isSleeping ? Colors.grey[300] : Colors.brown[800],
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