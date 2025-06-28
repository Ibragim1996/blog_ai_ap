import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Terms of Use',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'By using the Seeko app, you agree to follow all local laws and regulations. '
                'The app provides random challenges and questions for entertainment purposes only. '
                'Seeko is not responsible for any harm, injury, or issues arising from tasks performed by users.\n\n'
                'You must be at least 16 years old to use this app. Do not perform any tasks that put you or others in danger. '
                'Always act responsibly and with respect toward others.\n\n'
                'We reserve the right to update these Terms at any time. Continued use of the app means you accept any changes.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
