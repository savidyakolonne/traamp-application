import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';

// ignore: must_be_immutable
class ImageCardOther extends StatefulWidget {
  Map<String, String> imageData = {};
  ImageCardOther(this.imageData, {super.key});

  @override
  State<ImageCardOther> createState() => _ImageCardOtherState();
}

class _ImageCardOtherState extends State<ImageCardOther> {
  bool longPressed = false;

  Future<void> deleteImage() async {
    try {
      final response = await http.delete(
        Uri.parse("${AppConfig.SERVER_URL}/api/gallery/delete-gallery"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'galleryId': widget.imageData['galleryId'],
          'image': widget.imageData['url'],
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: const Color.fromARGB(180, 244, 67, 54),
          ),
        );
      } else {
        print('${data['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while deleting the package.'),
            backgroundColor: const Color.fromARGB(180, 244, 67, 54),
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while connecting to server'),
          backgroundColor: const Color.fromARGB(180, 244, 67, 54),
        ),
      );
    }
  }

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
            image: NetworkImage(widget.imageData['url']!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (longPressed == true)
              IconButton(
                padding: EdgeInsets.zero,
                icon: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(163, 0, 0, 0),
                  ),
                  child: Icon(Icons.delete_outline, color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    deleteImage();
                    longPressed = false;
                  });
                },
              ),
          ],
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
                    image: NetworkImage(widget.imageData['url']!),
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
      onLongPress: () {
        if (longPressed) {
          setState(() {
            longPressed = false;
            print(widget.imageData['url']);
            print(widget.imageData['galleryId']);
          });
        } else {
          setState(() {
            longPressed = true;
            print(widget.imageData['url']);
            print(widget.imageData['galleryId']!);
          });
        }
      },
    );
  }
}
