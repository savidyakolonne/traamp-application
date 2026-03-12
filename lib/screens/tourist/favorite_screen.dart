import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/app_config.dart';

import '../../widgets/package_card.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatefulWidget {
  String uid;
  FavoriteScreen(this.uid, {super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> favoriteList = [];
  List<dynamic> favoritePackageList = [];

  Future<void> getAllFavorites() async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/favorite/get-favorites"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": widget.uid}),
      );

      final data = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(data['msg']);
        List<dynamic> list = data['favorites'];
        setState(() {
          favoriteList = list;
        });
        print("favorite List: ${favoriteList}");
      } else {
        print(data['msg']);
      }
      // calling get all favorite packages
      getAllFavoritesPackages();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getAllFavoritesPackages() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${AppConfig.SERVER_URL}/api/favorite/get-favorites-packages",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"favoriteList": favoriteList}),
      );

      final data = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(data['msg']);
        List<dynamic> list = data['favoritePackageList'];
        setState(() {
          favoritePackageList = list;
        });
      } else {
        print(data['msg']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        title: Text(
          "Your Favorites",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
        child: RefreshIndicator(
          onRefresh: getAllFavorites,
          child: ListView(
            children: [
              // check condition that package array empty or not
              if (favoritePackageList.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(child: Text("No Recommendations to Show")),
                )
              else
                for (int i = 0; i < favoritePackageList.length; i++)
                  PackageCard(favoritePackageList[i], widget.uid),
            ],
          ),
        ),
      ),
    );
  }
}
