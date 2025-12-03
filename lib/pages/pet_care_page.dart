import 'package:flutter/material.dart';

class PetCarePage extends StatefulWidget {
  const PetCarePage({super.key});

  @override
  State<PetCarePage> createState() => _PetCarePageState();
}

class _PetCarePageState extends State<PetCarePage> {
  final List<CareItem> _careItems = [
    CareItem(
      id: 1,
      title: "Morning Meal",
      description: "Breakfast for your bear",
      icon: Icons.breakfast_dining,
      color: Colors.orange,
      energy: 15,
      happiness: 10,
      completed: false,
      time: "8:00 AM",
    ),
    CareItem(
      id: 2,
      title: "Play Time",
      description: "Exercise and fun activities",
      icon: Icons.sports_baseball,
      color: Colors.blue,
      energy: -10,
      happiness: 20,
      completed: true,
      time: "10:00 AM",
    ),
    CareItem(
      id: 3,
      title: "Afternoon Snack",
      description: "Healthy berries and honey",
      icon: Icons.local_dining,
      color: Colors.purple,
      energy: 10,
      happiness: 15,
      completed: false,
      time: "2:00 PM",
    ),
    CareItem(
      id: 4,
      title: "Training",
      description: "Learn new tricks",
      icon: Icons.school,
      color: Colors.green,
      energy: -5,
      happiness: 5,
      completed: false,
      time: "4:00 PM",
    ),
    CareItem(
      id: 5,
      title: "Evening Walk",
      description: "Explore the forest",
      icon: Icons.directions_walk,
      color: Colors.brown,
      energy: -15,
      happiness: 25,
      completed: false,
      time: "6:00 PM",
    ),
    CareItem(
      id: 6,
      title: "Bedtime Story",
      description: "Read a story before sleep",
      icon: Icons.menu_book,
      color: Colors.indigo,
      energy: 5,
      happiness: 20,
      completed: false,
      time: "8:00 PM",
    ),
  ];

  final List<FoodItem> _foodItems = [
    FoodItem(
      name: "Honey Jar",
      icon: "🍯",
      energy: 20,
      price: 5,
      unlocked: true,
    ),
    FoodItem(
      name: "Berries",
      icon: "🍓",
      energy: 15,
      price: 3,
      unlocked: true,
    ),
    FoodItem(
      name: "Fish",
      icon: "🐟",
      energy: 25,
      price: 8,
      unlocked: false,
    ),
    FoodItem(
      name: "Cake",
      icon: "🍰",
      energy: 30,
      price: 12,
      unlocked: false,
    ),
  ];

  final List<Activity> _activities = [
    Activity(
      name: "Ball Play",
      icon: "🏐",
      happiness: 15,
      duration: "10 min",
    ),
    Activity(
      name: "Hide & Seek",
      icon: "👀",
      happiness: 20,
      duration: "15 min",
    ),
    Activity(
      name: "Swimming",
      icon: "🏊",
      happiness: 25,
      duration: "20 min",
    ),
    Activity(
      name: "Dancing",
      icon: "💃",
      happiness: 30,
      duration: "25 min",
    ),
  ];

  int _coins = 100;

  void _completeTask(int id) {
    setState(() {
      final task = _careItems.firstWhere((item) => item.id == id);
      task.completed = true;

      // Simulate earning coins
      _coins += 10;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task completed! +10 coins 🪙"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _feedBear(FoodItem food) {
    if (!food.unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unlock ${food.name} first!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_coins >= food.price) {
      setState(() {
        _coins -= food.price;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fed ${food.name}! +${food.energy} energy"),
          backgroundColor: Colors.amber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not enough coins!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _playActivity(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Play ${activity.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activity.icon,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 16),
            Text(
              "This will make your bear happy!\nDuration: ${activity.duration}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Playing ${activity.name}! +${activity.happiness} happiness",
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text("Play Now"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF3E7),
        appBar: AppBar(
          title: const Text("Pet Care Center 🐻"),
          centerTitle: true,
          backgroundColor: Colors.brown[700],
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: "Daily Tasks"),
              Tab(text: "Food Shop"),
              Tab(text: "Activities"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Daily Tasks
            _buildTasksTab(),

            // Tab 2: Food Shop
            _buildFoodShopTab(),

            // Tab 3: Activities
            _buildActivitiesTab(),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 70),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.shade700,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                "$_coins Coins",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _coins += 50;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "+50",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksTab() {
    final completedCount = _careItems.where((item) => item.completed).length;
    final totalCount = _careItems.length;
    final progress = completedCount / totalCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card
          Container(
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
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Progress",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.brown[800],
                      ),
                    ),
                    Text(
                      "$completedCount/$totalCount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.orange.shade200,
                  color: Colors.orange,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 10),
                Text(
                  progress == 1
                      ? "All tasks completed! Great job! 🎉"
                      : "Complete all tasks for bonus rewards!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Task List
          Text(
            "Today's Tasks",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(height: 15),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _careItems.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _careItems[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: item.completed
                      ? Colors.green.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: item.completed
                        ? Colors.green.shade200
                        : Colors.orange.shade100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: item.color),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown[800],
                              decoration: item.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: Colors.brown[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown[500],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.bolt,
                                size: 14,
                                color: item.energy > 0
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${item.energy > 0 ? '+' : ''}${item.energy} energy",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.energy > 0
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!item.completed)
                      ElevatedButton(
                        onPressed: () => _completeTask(item.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Complete"),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Rewards Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎁 Daily Reward",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Complete all daily tasks to get:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple.shade600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildRewardItem(Icons.monetization_on, "100 Coins"),
                    _buildRewardItem(Icons.star, "Special Item"),
                    _buildRewardItem(Icons.card_giftcard, "Bear Hat"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildFoodShopTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🍯 Food Shop",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Buy food to feed your bear and increase its energy",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Food Items Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: _foodItems.length,
            itemBuilder: (context, index) {
              final food = _foodItems[index];
              return Container(
                decoration: BoxDecoration(
                  color: food.unlocked ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: food.unlocked
                        ? Colors.amber.shade200
                        : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      food.icon,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: food.unlocked
                            ? Colors.brown[800]
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bolt,
                          size: 16,
                          color: Colors.orange.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+${food.energy} energy",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (food.unlocked)
                      ElevatedButton(
                        onPressed: () => _feedBear(food),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${food.price}"),
                            const SizedBox(width: 4),
                            const Icon(Icons.monetization_on, size: 14),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Locked 🔒",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Storage Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📦 Food Storage",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStorageItem("Honey Jar", "🍯", "5"),
                    _buildStorageItem("Berries", "🍓", "12"),
                    _buildStorageItem("Fish", "🐟", "0"),
                    _buildStorageItem("Cake", "🍰", "0"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activities Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade100,
                  Colors.cyan.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎮 Fun Activities",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Play games with your bear to increase happiness",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Activities Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemCount: _activities.length,
            itemBuilder: (context, index) {
              final activity = _activities[index];
              return InkWell(
                onTap: () => _playActivity(activity),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        activity.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.pink.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "+${activity.happiness} happiness",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.pink.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        activity.duration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Activity History
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📝 Recent Activities",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.pink.shade800,
                  ),
                ),
                const SizedBox(height: 15),
                _buildActivityHistory("Hide & Seek", "Today, 10:30 AM", "+20"),
                _buildActivityHistory("Ball Play", "Yesterday, 4:15 PM", "+15"),
                _buildActivityHistory("Dancing", "2 days ago, 6:45 PM", "+30"),
              ],
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildRewardItem(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.purple, size: 30),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.purple,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String name, String icon, String count) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade800,
          ),
        ),
        Text(
          "x$count",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.green.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityHistory(String name, String time, String happiness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: const Icon(
              Icons.play_circle_fill,
              color: Colors.pink,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink.shade800,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.pink.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 14,
                  color: Colors.pink.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  happiness,
                  style: TextStyle(
                    color: Colors.pink.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CareItem {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int energy;
  final int happiness;
  bool completed;
  final String time;

  CareItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.energy,
    required this.happiness,
    required this.completed,
    required this.time,
  });
}

class FoodItem {
  final String name;
  final String icon;
  final int energy;
  final int price;
  final bool unlocked;

  FoodItem({
    required this.name,
    required this.icon,
    required this.energy,
    required this.price,
    required this.unlocked,
  });
}

class Activity {
  final String name;
  final String icon;
  final int happiness;
  final String duration;

  Activity({
    required this.name,
    required this.icon,
    required this.happiness,
    required this.duration,
  });
}