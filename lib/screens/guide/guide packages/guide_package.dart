import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_config.dart';
import '../../../widgets/guide_package_card.dart';
import 'create_package/create_guide_package.dart';

// ignore: must_be_immutable
class GuidePackage extends StatefulWidget {
  String uid;
  GuidePackage(this.uid, {super.key});

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  List<dynamic> packages = [];

  Future<void> _getGuidePackages() async {
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
          print(packages);
        });
      } else {
        print(data["msg"]);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getGuidePackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        title: Text(
          "Your Packages",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 71, 85, 105)),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
        child: RefreshIndicator(
          onRefresh: _getGuidePackages,
          child: ListView(
            children: [
              // check condition that package array empty or not
              if (packages.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(child: Text("No Packages to Show")),
                )
              else
                for (int i = 0; i < packages.length; i++)
                  GuidePackageCard(packages[i]),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CreateGuidePackage(widget.uid);
              },
            ),
          );
        },
        icon: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(131, 0, 0, 0),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
            color: const Color.fromARGB(255, 125, 212, 33),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(child: Icon(Icons.add, color: Colors.black, size: 40)),
        ),
      ),
    );
  }
}
