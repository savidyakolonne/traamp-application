import 'package:flutter/material.dart';

class GuideSignupForm extends StatelessWidget {
  const GuideSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guide Sign Up')),
      body: const Center(
        child: Text(
          'Guide Signup Form (Coming Soon)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
