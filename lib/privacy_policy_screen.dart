import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'This is the Privacy Policy page. Here you will describe how user data is handled, stored, and protected.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
