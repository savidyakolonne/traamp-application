import 'package:flutter/material.dart';

import 'create_package/create_guide_package.dart';

class GuidePackage extends StatefulWidget {
  String idToken;
  String uid;
  GuidePackage(this.idToken, this.uid);

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(
          "Your Packages",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      body: Container(),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CreateGuidePackage(widget.uid);
              },
            ),
          );
        },
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text("+", style: TextStyle(fontSize: 50, color: Colors.green)),
        ),
      ),
    );
  }
}
