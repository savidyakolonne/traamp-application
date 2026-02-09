import 'package:flutter/material.dart';

class EditTouristProfile extends StatefulWidget {
  const EditTouristProfile({super.key});

  @override
  State<EditTouristProfile> createState() => _EditTouristProfileState();
}

class _EditTouristProfileState extends State<EditTouristProfile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Edit Profile")));
  }
}
