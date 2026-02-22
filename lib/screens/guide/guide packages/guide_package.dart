import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/AppConfig.dart';
import '../../../components/packages/guide_package_card.dart';
import 'create_package/create_guide_package.dart';

// ignore: must_be_immutable
class GuidePackage extends StatefulWidget {
  String idToken;
  String uid;
  GuidePackage(this.idToken, this.uid, {super.key});

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  List<dynamic> packages = [];

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
    getGuidePackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Packages",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    getGuidePackages();
                  },
                  icon: Row(children: [Icon(Icons.refresh), Text("Refresh")]),
                ),
              ],
            ),
            // check condition that package array empty or not
            if (packages.isEmpty)
              Container(
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(168, 255, 255, 255),
            border: Border.all(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text("+", style: TextStyle(fontSize: 50, color: Colors.green)),
        ),
      ),
    );
  }
}
