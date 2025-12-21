import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const TraampApp());
}

class TraampApp extends StatelessWidget {
  const TraampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Traamp',
      home: const LoginScreen(),
    );
  }
}
