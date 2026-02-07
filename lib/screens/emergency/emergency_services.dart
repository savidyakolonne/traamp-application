import 'package:flutter/material.dart';

class EmergencyServices extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Emergency Services'),
        ),
        body: Center(
          child: Text('Emergency Services Screen (phase 1)'),
        ),
      ),
    );
  }
}