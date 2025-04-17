// lib/home_screen.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';

class TabbedHomeScreen extends StatefulWidget {
  const TabbedHomeScreen({super.key});

  @override
  State<TabbedHomeScreen> createState() => _TabbedHomeScreenState();
}

class _TabbedHomeScreenState extends State<TabbedHomeScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['DROP', 'MY PROGRESS'];
  String _activeTab = 'DROP';

  String _username = '';
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    final avatarBase64 = prefs.getString('avatar_base64');

    setState(() {
      _username = name ?? '';
      if (avatarBase64 != null) {
        _avatarBytes = base64Decode(avatarBase64);
      }
    });
  }

  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
    _loadProfile(); // Refresh data after returning
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setActiveTab(String tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  Widget _buildMainContent() {
    if (_activeTab == 'DROP') {
      return Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureButton('Daily'),
              const SizedBox(width: 16),
              _buildFeatureButton('Question'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureButton('Challenge'),
              const SizedBox(width: 16),
              _buildFeatureButton('Goal'),
            ],
          ),
          const SizedBox(height: 30),
          _buildAICenterButton()
        ],
      );
    } else {
      return const Center(
        child: Text(
          'No stories yet',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
  }

  Widget _buildFeatureButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
        minimumSize: const Size(130, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(title),
    );
  }

  Widget _buildAICenterButton() {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'S',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'SEEKO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    backgroundImage: _avatarBytes != null
                        ? MemoryImage(_avatarBytes!)
                        : null,
                    child: _avatarBytes == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _username.isNotEmpty ? _username : 'Username',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: _goToEditProfile,
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _tabs.map((tab) {
                  final isActive = tab == _activeTab;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GestureDetector(
                      onTap: () => _setActiveTab(tab),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : Colors.grey,
                          decoration:
                              isActive ? TextDecoration.underline : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => _onTabTapped(0),
                icon: const Icon(Icons.home, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
