import 'package:flutter/material.dart';

import '../../components/bottom_nav.dart';

class TouristNotificationScreen extends StatefulWidget {
  const TouristNotificationScreen({super.key});

  @override
  State<TouristNotificationScreen> createState() =>
      _TouristNotificationScreenState();
}

class _TouristNotificationScreenState extends State<TouristNotificationScreen> {
  // object for bottom navigation, isTourist = true
  BottomNav nav = BottomNav(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tourist notification"),
      ),
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
