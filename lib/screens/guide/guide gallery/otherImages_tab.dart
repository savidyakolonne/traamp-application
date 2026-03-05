import 'package:flutter/material.dart';
import 'image_card_other.dart';

// ignore: must_be_immutable
class OtherImages extends StatefulWidget {
  List<Map<String, String>> galleryImages = [];
  Future<void> Function() onRefresh;
  OtherImages(this.galleryImages, this.onRefresh, {super.key});

  @override
  State<OtherImages> createState() => _OtherImagesState();
}

class _OtherImagesState extends State<OtherImages> {
  @override
  Widget build(BuildContext context) {
    if (widget.galleryImages.isEmpty) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(child: Text("No images to show")),
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          children: [
            for (int i = 0; i < widget.galleryImages.length; i++)
              ImageCardOther(widget.galleryImages[i]),
          ],
        ),
      );
    }
  }
}