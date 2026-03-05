import 'package:flutter/material.dart';
import 'guide_profile_screen.dart';
import 'tourist_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String role; // "guide" or "tourist"

  const ProfileScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == "guide") {
      return const GuideProfileScreen();
    } else {
      return const TouristProfileScreen();
    }
  }
}