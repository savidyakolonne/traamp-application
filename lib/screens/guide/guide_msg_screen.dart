import 'package:flutter/material.dart';

class GuideMsgScreen extends StatefulWidget {
  const GuideMsgScreen({super.key});

  @override
  State<GuideMsgScreen> createState() => _GuideMsgScreenState();
}

class _GuideMsgScreenState extends State<GuideMsgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Guide MSg"),
      ),
    );
  }
}
