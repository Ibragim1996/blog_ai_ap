import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    final avatarBase64 = prefs.getString('avatar');

    if (name != null) _usernameController.text = name;
    if (avatarBase64 != null) {
      setState(() {
        _avatarBytes = Uint8List.fromList(List<int>.from(
            avatarBase64.codeUnits.map((c) => c).toList()));
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _avatarBytes = bytes;
      });
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _usernameController.text.trim();

    if (name.isNotEmpty) {
      await prefs.setString('username', name);
    }

    if (_avatarBytes != null) {
      final base64String = String.fromCharCodes(_avatarBytes!);
      await prefs.setString('avatar', base64String);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
              child: _avatarBytes == null
                  ? const Icon(Icons.camera_alt, color: Colors.white, size: 32)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white12,
              hintText: 'Enter your name',
              hintStyle: const TextStyle(color: Colors.white38),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text('Save'),
          )
        ]),
      ),
    );
  }
}
