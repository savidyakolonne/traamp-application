import 'package:flutter/material.dart';
import 'package:traamp_frontend/screens/guide/guide%20gallery/image_card_package.dart';

// ignore: must_be_immutable
class PackageImages extends StatefulWidget {
  List<String> packageImages = [];
  PackageImages(this.packageImages, {super.key});

  @override
  State<PackageImages> createState() => _PackageImagesState();
}

class _PackageImagesState extends State<PackageImages> {
  @override
  Widget build(BuildContext context) {
    if (widget.packageImages.isEmpty) {
      return Center(child: Text("No images to show"));
    } else {
      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          for (int i = 0; i < widget.packageImages.length; i++)
            ImageCardPackage(widget.packageImages[i]),
        ],
      );
    }
  }
}
