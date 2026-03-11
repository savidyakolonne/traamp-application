import 'package:flutter/material.dart';
import '../../../widgets/image_card_other.dart';
import '../../../widgets/image_card_package.dart';

// ignore: must_be_immutable
class AllImages extends StatefulWidget {
  List<Map<String, String>> galleryImages = [];
  List<String> packageImages = [];
  Future<void> Function() onRefresh;
  String uid;
  AllImages(
    this.galleryImages,
    this.packageImages,
    this.onRefresh,
    this.uid, {
    super.key,
  });

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {
    if (widget.galleryImages.isEmpty && widget.packageImages.isEmpty) {
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
              ImageCardOther(widget.galleryImages[i], widget.uid),

            for (int i = 0; i < widget.packageImages.length; i++)
              ImageCardPackage(widget.packageImages[i]),
          ],
        ),
      );
    }
  }
}
