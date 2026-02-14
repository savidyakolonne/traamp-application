import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/services/location_service.dart';
import 'package:traamp_frontend/screens/map/map_screen.dart';
import '../places/places_list_screen.dart';
import '../activities/activities_list_screen.dart';

import '../../components/weather/weather_screen.dart';

class TouristDashboard extends StatefulWidget {
  @override
  State<TouristDashboard> createState() => _TouristDashboardState();
}

class _TouristDashboardState extends State<TouristDashboard> {
  String currentLocation = "Unknown location";
  late Map<String, dynamic> userData = {};

  // get user data from DB
  Future<void> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken(true);
        if (idToken != null) {
          final response = await http.post(
            Uri.parse("http://10.0.2.2:3000/api/users/get-user-data"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"idToken": idToken}),
          );

          final data = await jsonDecode(response.body);

          if (response.statusCode == 200) {
            setState(() {
              userData = data['data'];
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
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 70,
              width: 70,
              child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
            ),
            Text(
              "Shehan Kumar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
            ),
          ],
        ),
        SizedBox(width: 10),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 60,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.black, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "Traamp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Hi ${userData['firstName']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.amber[900],
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 15),
            onPressed: () {},
            icon: Icon(Icons.favorite, size: 25.0, color: Colors.red[700]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20.0,
            left: 18.0,
            right: 18.0,
            bottom: 20,
          ),
          child: Column(
            children: [
              Text(
                "Welcome to your\nDashboard",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      getCurrentCity();
                    },
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  Text(currentLocation),
                ],
              ),

              // menu icons
              Column(
                spacing: 20.0,
                children: [
                  // first row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1st row - 1st icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/guidesIcon.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Guides",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // 1st row - 2nd icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlacesListScreen(),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/places.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Places",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // 1st row - 3rd icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActivitiesListScreen(),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/activity.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Activities",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 2nd row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2nd row - first icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MapScreen(),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/AImap.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "AI Map",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // 2nd row - 2nd icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return WeatherScreen(true);
                                    },
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/weather.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Weather",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // 2nd row - 3rd icon
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/sos.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Emergency\nContacts",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // suggestion area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "We suggest you",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Text(
                      "See more",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: const Color.fromARGB(255, 8, 5, 172),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [suggestionScrollableView()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 90,
        width: 80,
        child: Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/chatBot.png"),
            ),
            Text("Need help?", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
