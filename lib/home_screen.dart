import 'dart:io';
import 'camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera_overlay_screen.dart';
import 'edit_profile_screen.dart';
import 'package:my_app/services/openai_service.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  String? _avatarPath;
  List<String> _savedTasks = [];
  int currentTabIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> tabTitles = ['Drop', 'My Progress', 'Saved'];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadSavedTasks();
  }

  // Загружаем профиль (имя и аватар)
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _avatarPath = prefs.getString('avatarPath');
    });
  }

  // Загружаем сохранённые задачи
  Future<void> _loadSavedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedTasks = prefs.getStringList('savedTasks') ?? [];
    });
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    } else if (index == 2) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        currentTabIndex = index;
      });
    }
  }

  Future<void> saveTaskToSavedList(String task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedTasks = prefs.getStringList('savedTasks') ?? [];
    savedTasks.add(task);
    await prefs.setStringList('savedTasks', savedTasks);
    _loadSavedTasks();
  }

  void showSeekoPopup(String type) {
    String title = '$type Task';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Popup',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2c2c54), Color(0xFF474787)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SEEKO',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                              builder:
                                  (_) => CameraOverlayScreen(taskText: title),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            26,
                            26,
                            26,
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Accept",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 196, 194, 194),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await saveTaskToSavedList(title);
                          Navigator.pop(context);
                          print('✅ Saved: $title');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            60,
                            60,
                            60,
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 195, 195, 195),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            27,
                            27,
                            27,
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 196, 196, 196),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'Seeko Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.black),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/privacy');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.black),
              title: const Text('About Seeko'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.black),
              title: Text('Premium'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/premium');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Terms of Use'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/terms');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'TASFACE',
                style: TextStyle(
                  color: Color.fromARGB(255, 160, 161, 162),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              CircleAvatar(
                radius: 38,
                backgroundImage:
                    _avatarPath != null && File(_avatarPath!).existsSync()
                        ? FileImage(File(_avatarPath!))
                        : null,
                child:
                    _avatarPath == null
                        ? const Icon(Icons.person, size: 38)
                        : null,
              ),
              const SizedBox(height: 8),
              Text(
                _username.isNotEmpty ? _username : 'Username',
                style: const TextStyle(
                  color: Color.fromARGB(255, 221, 220, 220),
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
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
                          color:
                              currentTabIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                          fontSize: 16,
                          fontWeight:
                              currentTabIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    currentTabIndex == 0
                        ? Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            FeatureButton(
                              icon: Icons.calendar_today,
                              onTap: () => showSeekoPopup('Daily'),
                            ),
                            FeatureButton(
                              icon: Icons.help_outline,
                              onTap: () => showSeekoPopup('Question'),
                            ),
                            FeatureButton(
                              icon: Icons.flag,
                              onTap: () => showSeekoPopup('Challenge'),
                            ),
                            FeatureButton(
                              icon: Icons.bolt,
                              onTap: () => showSeekoPopup('Goal'),
                            ),
                          ],
                        )
                        : currentTabIndex == 1
                        ? _savedTasks.isEmpty
                            ? const Center(
                              child: Text(
                                'No completed tasks yet.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _savedTasks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _savedTasks[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            )
                        : const Center(
                          child: Text(
                            'Saved tasks will appear here.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentTabIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const FeatureButton({super.key, required this.icon, required this.onTap});

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
            colors: [Color(0xFF2c2c54), Color.fromARGB(255, 47, 47, 92)],
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
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 222, 219, 219),
            size: 36,
          ),
        ),
      ),
    );
  }
}
