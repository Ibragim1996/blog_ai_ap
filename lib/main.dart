import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_screen.dart';
import 'auth_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_screen.dart';
import 'account_screen.dart';
import 'premium_screen.dart';
import 'delete_account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // 👈 загружаем .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seeko',
      theme: ThemeData.dark(),
      home: const AuthScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/about': (context) => const AboutScreen(),
        '/account': (context) => const AccountScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/delete': (context) => const DeleteAccountScreen(),
      },
    );
  }
}
