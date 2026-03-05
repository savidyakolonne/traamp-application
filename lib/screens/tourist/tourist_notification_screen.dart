import 'package:flutter/material.dart';

class TouristNotificationScreen extends StatefulWidget {
  const TouristNotificationScreen({super.key});

  @override
  State<TouristNotificationScreen> createState() =>
      _TouristNotificationScreenState();
}

class _TouristNotificationScreenState extends State<TouristNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tourist notification"),
      ),
    );
  }
}