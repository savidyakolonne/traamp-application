import 'package:flutter/material.dart';

import '../../components/bottom_nav.dart';

class GuideNotificationScreen extends StatefulWidget {
  const GuideNotificationScreen({super.key});

  @override
  State<GuideNotificationScreen> createState() =>
      _GuideNotificationScreenState();
}

class _GuideNotificationScreenState extends State<GuideNotificationScreen> {
  // object for bottom navigation, isTourist = false
  BottomNav nav = BottomNav(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Guide notification"),
      ),
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
