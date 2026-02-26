import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../appConfig.dart';
import '../guide_dashboard.dart';
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
          child: TabBarView(
            children: [
              Container(child: Text(" 2")),

              PackageImages(packageImages),

              Container(child: Text(" 3")),
            ],
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
          onPressed: () {},
        ),
      ),
    );
  }
}
