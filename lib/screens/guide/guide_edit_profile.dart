import 'package:flutter/material.dart';

class EditGuideProfile extends StatefulWidget {
  const EditGuideProfile({super.key});

  @override
  State<EditGuideProfile> createState() => _EditGuideProfileState();
}

class _EditGuideProfileState extends State<EditGuideProfile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.lightGreen)),
    );
  }
}
