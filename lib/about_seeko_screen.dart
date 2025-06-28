import 'package:flutter/material.dart';

class AboutSeekoScreen extends StatelessWidget {
  const AboutSeekoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Seeko')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Seeko is an app designed to challenge you daily with fun tasks, questions, and personal growth goals. Stay motivated and track your progress easily!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
