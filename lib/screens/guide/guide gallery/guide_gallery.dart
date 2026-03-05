import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_config.dart';
import '../guide_dashboard.dart';
import 'allImages_tab.dart';
import 'otherImages_tab.dart';
import 'packageImages_tab.dart';

// ignore: must_be_immutable
class GuideGallery extends StatefulWidget {
  String uid;
  GuideGallery(this.uid, {super.key});

  @override
  State<GuideGallery> createState() => _GuideGalleryState();
}

class _GuideGalleryState extends State<GuideGallery> {
  List<dynamic> packages = [];
  List<String> packageImages = [];
  List<Map<String, String>> galleryImages = [];
  List<File> imagesToSet = [];
  List<dynamic> galleries = [];
  String galleryId = '';

  // get all gallery collections by uid
  Future<void> getImageDocuments() async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/gallery/get-gallery-by-uid"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'uid': widget.uid}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          galleries = data["data"];
          setGalleryImages();
        });
      } else {
        print(data["msg"]);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  // set all galley images to galleryImage array
  void setGalleryImages() {
    galleryImages = [];
    List<dynamic> images = [];
    if (galleries.isNotEmpty) {
      for (int i = 0; i < galleries.length; i++) {
        images = galleries[i]['images'];
        for (int j = 0; j < images.length; j++) {
          setState(() {
            galleryImages.add({
              'galleryId': galleries[i]['galleryId'].toString(),
              'url': images[j].toString(),
            });
          });
        }
      }
    } else {
      print("Package is empty");
    }
  }

  Future<void> addImagesToDataBase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heif'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      // set file count as hintText
      setState(() {
        imagesToSet = files;
        print(imagesToSet.length);
      });

      try {
        var uri = Uri.parse(
          "${AppConfig.SERVER_URL}/api/gallery/add-to-gallery",
        );
        var request = http.MultipartRequest('POST', uri);

        request.fields['uid'] = widget.uid;

        // Add multiple images
        for (var img in imagesToSet) {
          request.files.add(
            await http.MultipartFile.fromPath('images', img.path),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Trying to add your images... "),
                CircularProgressIndicator.adaptive(),
              ],
            ),
            backgroundColor: const Color.fromARGB(180, 76, 175, 79),
          ),
        );

        // Send request
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          var data = jsonDecode(responseBody);
          print(data);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text('${data['msg']}'),
                  CircularProgressIndicator.adaptive(),
                ],
              ),
              backgroundColor: const Color.fromARGB(180, 76, 175, 79),
            ),
          );
        } else {
          try {
            var data = jsonDecode(responseBody);
            print(data['msg']);
          } catch (_) {
            print("Server returned non-JSON: $responseBody");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error while adding images to server'),
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
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }

  // to get all packages by uid
  Future<void> getGuidePackages() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${AppConfig.SERVER_URL}/api/guidePackage/get-package-by-user-id",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'uid': widget.uid}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data["msg"]);
        setState(() {
          packages = data["packages"];
          setPackageImages();
          print(packageImages);
        });
      } else {
        print(data["msg"]);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  // set all package images to packageImage array
  void setPackageImages() {
    List<dynamic> images = [];
    if (packages.isNotEmpty) {
      for (int i = 0; i < packages.length; i++) {
        packageImages.add(packages[i]['coverImage'].toString());
        images = packages[i]['images'];
        for (int j = 0; j < images.length; j++) {
          packageImages.add(images[j].toString());
        }
      }
    } else {
      print("Package is empty");
    }
  }

  @override
  void initState() {
    super.initState();
    getGuidePackages();
    getImageDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, GuideDashboard());
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Photo Gallery",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: Color.fromARGB(255, 247, 248, 246),
          bottom: const TabBar(
            labelColor: Colors.green,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            tabs: [
              Text(
                "ALL",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "PACKAGE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "OTHER",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: RefreshIndicator(
            onRefresh: getImageDocuments,
            child: TabBarView(
              children: [
                AllImages(galleryImages, packageImages, getImageDocuments),

                PackageImages(packageImages),

                OtherImages(galleryImages, getImageDocuments),
              ],
            ),
          ),
        ),

        floatingActionButton: IconButton(
          icon: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(255, 92, 209, 96),
            ),
            child: Center(
              child: Icon(Icons.photo_camera, color: Colors.white, size: 30),
            ),
          ),
          onPressed: () {
            addImagesToDataBase();
            getImageDocuments();
          },
        ),
      ),
    );
  }
}