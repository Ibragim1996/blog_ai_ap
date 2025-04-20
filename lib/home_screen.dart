import 'package:flutter/material.dart';
import 'camera_overlay_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  final List<String> tabTitles = ['Drop', 'My Progress', 'Saved'];

  void showSeekoPopup(String type) {
    String title = '';
    switch (type) {
      case 'Daily':
        title = 'SEEKO даёт тебе задание';
        break;
      case 'Question':
        title = 'SEEKO спрашивает тебя';
        break;
      case 'Challenge':
        title = 'SEEKO бросает тебе вызов';
        break;
      case 'Goal':
        title = 'SEEKO напоминает твою цель';
        break;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'S',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraOverlayScreen(taskText: title),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Принять"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('❌ Пропущено: $type');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Пропустить"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('💾 Сохранено: $type');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Сохранить"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(int index) {
    if (index == 0) {
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          FeatureButton(label: 'Daily', onTap: () => showSeekoPopup('Daily')),
          FeatureButton(label: 'Question', onTap: () => showSeekoPopup('Question')),
          FeatureButton(label: 'Challenge', onTap: () => showSeekoPopup('Challenge')),
          FeatureButton(label: 'Goal', onTap: () => showSeekoPopup('Goal')),
        ],
      );
    } else if (index == 1) {
      return const Center(
        child: Text("Выполненные задания появятся здесь", style: TextStyle(color: Colors.white)),
      );
    } else {
      return const Center(
        child: Text("Сохранённые задания появятся здесь", style: TextStyle(color: Colors.white)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.05),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'SEEKO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              const CircleAvatar(radius: 38, backgroundColor: Colors.grey),
              const SizedBox(height: 8),
              const Text('Username', style: TextStyle(color: Colors.white, fontSize: 17)),
              const SizedBox(height: 4),
              const Text('Edit Profile', style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
              const SizedBox(height: 16),

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(tabTitles.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTabIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        tabTitles[index],
                        style: TextStyle(
                          color: currentTabIndex == index ? Colors.white : Colors.grey,
                          fontSize: 16,
                          fontWeight: currentTabIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Tab content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildTabContent(currentTabIndex),
                ),
              ),

              // AI Button
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      print('AI button tapped');
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8f94fb), Color(0xFF4e54c8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FeatureButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 150,
        height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2c2c54), Color(0xFF474787)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
