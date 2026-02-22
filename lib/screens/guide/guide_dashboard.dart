import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../appConfig.dart';
import '../../services/location_service.dart';
import '../../components/weather/weather_screen.dart';
import 'guide gallery/guide_gallery.dart';
import 'guide packages/guide_package.dart';

class GuideDashboard extends StatefulWidget {
  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

class _GuideDashboardState extends State<GuideDashboard> {
  String currentLocation = "Unknown location";
  String profilePicture = "";
  late String? idToken = "";
  bool availability = false;
  late String dropdownValue;
  late Map<String, dynamic> userData = {};

  // get user data from DB
  Future<void> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        idToken = await user.getIdToken(true);
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
              availability = userData['availability'];
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

  Future<void> getCurrentCity() async {
    try {
      // Get current position
      Position position = await LocationService.getCurrentPosition();

      // Convert coordinates to placemark
      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract city/town name
      Placemark place = placemark[0];
      setState(() {
        currentLocation = place.locality!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
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
                  "Hi, ${userData['firstName']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: const Color.fromARGB(255, 234, 210, 0),
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 100, 116, 139),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 10),
              // current status
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CURRENT STATUS",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 100, 116, 139),
                          ),
                        ),
                        Text(
                          "Available for Tours",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 139, 195, 74),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: availability,
                      trackColor: availability
                          ? WidgetStatePropertyAll<Color>(
                              const Color.fromARGB(255, 139, 195, 74),
                            )
                          : WidgetStatePropertyAll<Color>(
                              const Color.fromARGB(255, 200, 200, 200),
                            ),
                      thumbColor: const WidgetStatePropertyAll<Color>(
                        Colors.white,
                      ),
                      onChanged: (bool value) async {
                        setState(() {
                          if (availability) {
                            availability = false;
                          } else {
                            availability = true;
                          }
                        });
                        // update database
                        try {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null && idToken != null) {
                            final response = await http.put(
                              Uri.parse(
                                "${AppConfig.SERVER_URL}/api/users/update-guide-availability",
                              ),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode({
                                "idToken": idToken,
                                "availability": availability,
                              }),
                            );
                            final data = jsonDecode(response.body);
                            if (response.statusCode == 200) {
                              print('${data['msg']}');
                            }
                            if (response.statusCode == 404) {
                              print('${data['msg']}');
                            }
                            if (response.statusCode == 400) {
                              print('${data['msg']}');
                            }
                          } else {
                            print(
                              "Something wrong during creating instance from firebase or idToken",
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // packages
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/mountain.png"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Packages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return GuidePackage(userData['uid']);
                            },
                          ),
                        );
                      },
                      icon: Row(
                        spacing: 10,
                        children: [
                          Text(
                            "Manage",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 179, 255, 93),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: const Color.fromARGB(255, 179, 255, 93),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // gallery
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/beach.png"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Photo Gallery",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return GuideGallery(userData['uid']);
                            },
                          ),
                        );
                      },
                      icon: Row(
                        spacing: 10,
                        children: [
                          Text(
                            "View More",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 179, 255, 93),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: const Color.fromARGB(255, 179, 255, 93),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // utility section
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Utilities",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // news
                        detailIcons(
                          const Color.fromARGB(255, 255, 237, 213),
                          Icon(
                            Icons.newspaper,
                            size: 30,
                            color: const Color.fromARGB(255, 249, 115, 22),
                          ),
                          "News",
                          () {},
                        ),

                        // weather
                        detailIcons(
                          const Color.fromARGB(255, 219, 234, 254),
                          Icon(
                            Icons.wb_sunny,
                            size: 30,
                            color: const Color.fromARGB(255, 59, 130, 246),
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
                          const Color.fromARGB(255, 254, 226, 226),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
