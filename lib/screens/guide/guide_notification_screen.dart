import 'package:flutter/material.dart';

class GuideNotificationScreen extends StatefulWidget {
  const GuideNotificationScreen({super.key});

  @override
  State<GuideNotificationScreen> createState() =>
      _GuideNotificationScreenState();
}

class _GuideNotificationScreenState extends State<GuideNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Guide notification")));
  }
}
