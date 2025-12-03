import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "Pet Lover";
  String _userEmail = "petlover@example.com";
  int _daysWithBear = 15;
  int _totalChats = 128;
  int _mealsGiven = 42;
  int _playSessions = 28;

  final List<Achievement> _achievements = [
    Achievement(
      title: "First Friend",
      description: "Chatted for the first time",
      icon: Icons.chat,
      unlocked: true,
      date: "Day 1",
    ),
    Achievement(
      title: "Feeder",
      description: "Fed bear 10 times",
      icon: Icons.restaurant,
      unlocked: true,
      date: "Day 3",
    ),
    Achievement(
      title: "Best Friend",
      description: "Chatted for 7 days straight",
      icon: Icons.favorite,
      unlocked: true,
      date: "Day 7",
    ),
    Achievement(
      title: "Explorer",
      description: "Played 20 times",
      icon: Icons.explore,
      unlocked: false,
      date: "Locked",
    ),
    Achievement(
      title: "Master Carer",
      description: "Complete all care tasks",
      icon: Icons.star,
      unlocked: false,
      date: "Locked",
    ),
  ];

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _userName,
                decoration: const InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _userEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _userEmail = value;
                  });
                },
              ),
            ],
          ),
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
                const SnackBar(
                  content: Text("Profile updated successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0E3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown.shade700,
                      Colors.amber.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 70),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: "Edit Profile",
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      children: [
                        Text(
                          "📈 Your Stats",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.brown[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          children: [
                            _buildStatItem(
                              Icons.calendar_today,
                              "$_daysWithBear Days",
                              "With Bear",
                              Colors.amber,
                            ),
                            _buildStatItem(
                              Icons.chat_bubble,
                              "$_totalChats Chats",
                              "Total",
                              Colors.blue,
                            ),
                            _buildStatItem(
                              Icons.restaurant,
                              "$_mealsGiven Meals",
                              "Given",
                              Colors.green,
                            ),
                            _buildStatItem(
                              Icons.sports_baseball,
                              "$_playSessions Plays",
                              "Sessions",
                              Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bear Info
                  Text(
                    "🐻 Your Bear Info",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.brown.shade300),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.brown,
                            size: 50,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bobo the Bear",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.brown[800],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Virtual Companion • Level 5",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: 0.65,
                                backgroundColor: Colors.brown.shade200,
                                color: Colors.amber.shade600,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "65% to next level",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Achievements
                  Text(
                    "🏆 Achievements",
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
                    itemCount: _achievements.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final achievement = _achievements[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: achievement.unlocked
                              ? Colors.white
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: achievement.unlocked
                                ? Colors.amber.shade200
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: achievement.unlocked
                                    ? Colors.amber.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                achievement.icon,
                                color: achievement.unlocked
                                    ? Colors.amber.shade800
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    achievement.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: achievement.unlocked
                                          ? Colors.brown[800]
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    achievement.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: achievement.unlocked
                                          ? Colors.brown[600]
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: achievement.unlocked
                                    ? Colors.amber.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                achievement.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: achievement.unlocked
                                      ? Colors.amber.shade800
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Settings
                  Text(
                    "⚙️ Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          Icons.notifications,
                          "Notifications",
                          true,
                        ),
                        const Divider(height: 1, indent: 16),
                        _buildSettingItem(
                          Icons.music_note,
                          "Sound Effects",
                          true,
                        ),
                        const Divider(height: 1, indent: 16),
                        _buildSettingItem(
                          Icons.brightness_6,
                          "Dark Mode",
                          false,
                        ),
                        const Divider(height: 1, indent: 16),
                        _buildSettingItem(
                          Icons.help,
                          "Help & Support",
                          false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Logout logic here
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool value) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.brown[800],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // Handle switch change
        },
        activeColor: Colors.amber,
      ),
      onTap: () {},
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final String date;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.date,
  });
}