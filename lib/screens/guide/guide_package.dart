import 'package:flutter/material.dart';

class GuidePackage extends StatefulWidget {
  const GuidePackage({super.key});

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guide Packages")),
      body: Container(),
    );
  }
}
