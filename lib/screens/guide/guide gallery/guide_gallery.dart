import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GuideGallery extends StatefulWidget {
  String idToken;
  String uid;
  GuideGallery(this.idToken, this.uid, {super.key});

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
