import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/services/location_service.dart';
import 'package:traamp_frontend/screens/map/map_screen.dart';
import '../places/places_list_screen.dart';
import '../activities/activities_list_screen.dart';
import '../../appConfig.dart';
import '../../components/weather/weather_screen.dart';

class TouristDashboard extends StatefulWidget {
  @override
  State<TouristDashboard> createState() => _TouristDashboardState();
}

class _TouristDashboardState extends State<TouristDashboard> {
  String currentLocation = "Unknown location";
  String profilePicture = "";
  late Map<String, dynamic> userData = {};

  // get user data from DB
  Future<void> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken(true);
        if (idToken != null) {
          final response = await http.post(
            Uri.parse("${AppConfig.SERVER_URL}/api/users/get-user-data"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"idToken": idToken}),
          );

          final data = await jsonDecode(response.body);

          if (response.statusCode == 200) {
            setState(() {
              userData = data['data'];
              if (userData['profilePicture'] != null) {
                profilePicture = userData['profilePicture'];
              }
            });
            print(data['msg']);
          } else if (response.statusCode == 401) {
            print(data['msg']);
          }
        } else {
          print("idToken is Null");
        }
      } else {
        print("Something wrong during creating instance from firebase");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // get current location via GPS
  Future<void> getCurrentCity() async {
    try {
      // Get current position
      final position = await LocationService.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      setState(() {
        currentLocation = (place?.locality?.isNotEmpty == true
            ? place!.locality!
            : "Unknown");
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        currentLocation = "Location unavailable";
      });
    }
  }

  Widget suggestionScrollableView() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(47, 0, 0, 0),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // image
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  "https://media.gettyimages.com/id/2210026760/photo/sri-lanka-central-province-polonnaruwa-district-sigiriya-ancient-city-and-fortress-of.jpg?s=2048x2048&w=gi&k=20&c=VKN5d3SgPZSiV7Yq46VNXPo2143B4M-ibuZeO-Tienw=",
                ),
              ),
            ),
          ),
          // below image
          Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // package title
                Text(
                  "Sigiriya Rock Fortress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 30, 41, 59),
                  ),
                ),
                // location
                Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: const Color.fromARGB(255, 100, 116, 139),
                    ),
                    Text(
                      "Matale district",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 100, 116, 139),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "LKR 3000",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 153, 204, 102),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "/pp",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 100, 116, 139),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 153, 204, 102),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          "View Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailIcons(
    Color backgroundColor,
    Widget icon,
    String name,
    Function() function,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: function,
          icon: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(47, 0, 0, 0),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],

              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: icon,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: name == "Emergency"
                ? const Color.fromARGB(255, 239, 68, 68)
                : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  initState() {
    super.initState();
    getUserData();
    getCurrentCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: (profilePicture.isNotEmpty)
                  ? NetworkImage(profilePicture)
                  : (userData['gender'] == "Female"
                        ? AssetImage('assets/images/avatar-female.avif')
                        : AssetImage('assets/images/avatar-male.avif')),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back,",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 100, 116, 139),
                    fontSize: 16,
                  ),
                ),

                Text(
                  "Ayubowan, ${userData['firstName']}!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 15),
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 241, 245, 249),
              child: Icon(
                Icons.favorite,
                color: const Color.fromARGB(255, 71, 85, 105),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              // cover image section
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/tourist_wallpaper_darked.png',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Explore the Pearl of the Indian\nOcean",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Discover hidden gems in Sri Lanka",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // icon section
              Column(
                children: [
                  // first row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // find guides
                      detailIcons(
                        const Color.fromARGB(255, 240, 253, 244),
                        Icon(
                          Icons.hail,
                          size: 30,
                          color: const Color.fromARGB(255, 153, 204, 102),
                        ),
                        "Find guides",
                        () {},
                      ),

                      // places
                      detailIcons(
                        const Color.fromARGB(255, 239, 246, 255),
                        Icon(
                          Icons.landscape,
                          size: 30,
                          color: const Color.fromARGB(255, 59, 130, 246),
                        ),
                        "Places",
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PlacesListScreen();
                              },
                            ),
                          );
                        },
                      ),

                      // activities
                      detailIcons(
                        const Color.fromARGB(255, 255, 247, 237),
                        Icon(
                          Icons.surfing,
                          size: 30,
                          color: const Color.fromARGB(255, 249, 115, 22),
                        ),
                        "Activities",
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ActivitiesListScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // second row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // map
                      detailIcons(
                        const Color.fromARGB(255, 238, 242, 255),
                        Icon(
                          Icons.map,
                          size: 30,
                          color: const Color.fromARGB(255, 99, 102, 241),
                        ),
                        "Map",
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MapScreen();
                              },
                            ),
                          );
                        },
                      ),

                      // weather
                      detailIcons(
                        const Color.fromARGB(255, 240, 249, 255),
                        Icon(
                          Icons.wb_sunny,
                          size: 30,
                          color: const Color.fromARGB(255, 56, 189, 248),
                        ),
                        "Weather",
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return WeatherScreen();
                              },
                            ),
                          );
                        },
                      ),

                      // emergency
                      detailIcons(
                        const Color.fromARGB(255, 254, 242, 242),
                        Icon(
                          Icons.sos,
                          size: 30,
                          color: const Color.fromARGB(255, 239, 68, 68),
                        ),
                        "Emergency",
                        () {},
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // recommendation section
              Column(
                children: [
                  // heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recommendations for you",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Text(
                          "See more",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          suggestionScrollableView(),
                          suggestionScrollableView(),
                          suggestionScrollableView(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // AI guide
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 15, 23, 42),
                      const Color.fromARGB(255, 42, 58, 53),
                    ],
                    begin: Alignment.topLeft, // start point
                    end: Alignment.bottomRight, // end point
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Text(
                      "Need a customized\ntour plan?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Ask AI Guide",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
