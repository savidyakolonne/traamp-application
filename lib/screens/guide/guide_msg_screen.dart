import 'package:flutter/material.dart';

import '../../components/bottom_nav.dart';

class GuideMsgScreen extends StatefulWidget {
  const GuideMsgScreen({super.key});

  @override
  State<GuideMsgScreen> createState() => _GuideMsgScreenState();
}

class _GuideMsgScreenState extends State<GuideMsgScreen> {
  // object for bottom navigation, isTourist = false
  BottomNav nav = BottomNav(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Guide MSg"),
      ),
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
