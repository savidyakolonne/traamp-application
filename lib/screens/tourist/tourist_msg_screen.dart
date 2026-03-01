import 'package:flutter/material.dart';

class TouristMsgScreen extends StatefulWidget {
  const TouristMsgScreen({super.key});

  @override
  State<TouristMsgScreen> createState() => _TouristMsgScreenState();
}

class _TouristMsgScreenState extends State<TouristMsgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tourist MSg"),
      ),
    );
  }
}
