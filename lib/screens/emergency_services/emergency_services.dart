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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text('Emergency Services Screen'),
              Image(image:  AssetImage('assets/images/logo.png'))
            ],
          ),
        ),
      ),
    );
  }
}