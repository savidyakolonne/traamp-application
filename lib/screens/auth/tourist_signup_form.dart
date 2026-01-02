import 'package:flutter/material.dart';

class TouristSignupForm extends StatelessWidget {
  const TouristSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tourist Sign Up')),
      body: const Center(
        child: Text(
          'Tourist Signup Form (Coming Soon)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
