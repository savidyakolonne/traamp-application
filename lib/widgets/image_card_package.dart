import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageCardPackage extends StatefulWidget {
  String packageImages = "";
  ImageCardPackage(this.packageImages, {super.key});

  @override
  State<ImageCardPackage> createState() => _ImageCardPackageState();
}

class _ImageCardPackageState extends State<ImageCardPackage> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.packageImages),
          ),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shadowColor: Colors.black,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                height: 400,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color.fromARGB(188, 0, 0, 0),
                  image: DecorationImage(
                    image: NetworkImage(widget.packageImages),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}