import 'package:flutter/material.dart';

class GuideGallery extends StatefulWidget {
  const GuideGallery({super.key});

  @override
  State<GuideGallery> createState() => _GuideGalleryState();
}

class _GuideGalleryState extends State<GuideGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guide Gallery")),
      body: Container(),
    );
  }
}
