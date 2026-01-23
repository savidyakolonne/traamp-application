import 'package:flutter/material.dart';

import '../../components/bottom_nav.dart';

class TouristMsgScreen extends StatefulWidget {
  const TouristMsgScreen({super.key});

  @override
  State<TouristMsgScreen> createState() => _TouristMsgScreenState();
}

class _TouristMsgScreenState extends State<TouristMsgScreen> {
  // object for bottom navigation, isTourist = true
  BottomNav nav = BottomNav(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tourist MSg"),
      ),
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
