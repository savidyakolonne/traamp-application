import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';
import '../../components/weather/weather_screen.dart';
import '../emergency_services/emergency_services.dart';
import 'guide gallery/guide_gallery.dart';
import 'guide packages/guide_package.dart';
import 'news_screen.dart';

// ignore: must_be_immutable
class GuideDashboard extends StatefulWidget {
  final String idToken;
  Map<String, dynamic> userData;
  GuideDashboard(this.idToken, this.userData, {super.key});

  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

class _GuideDashboardState extends State<GuideDashboard> {
  String currentLocation = "Unknown location";
  String profilePicture = "";
  bool availability = false;
  late String dropdownValue;

  // get user data from DB
  Future<void> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response = await http.post(
          Uri.parse("${AppConfig.SERVER_URL}/api/users/get-user-data"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"idToken": widget.idToken}),
        );

        final data = await jsonDecode(response.body);

        if (response.statusCode == 200) {
          setState(() {
            widget.userData = data['data'];
            if (widget.userData['availability'] == "false" ||
                widget.userData['availability'] == false) {
              availability = false;
            } else {
              availability = true;
            }

            if (widget.userData['profilePicture'] != null) {
              profilePicture = widget.userData['profilePicture'];
            }
          });
          print(data['msg']);
        } else if (response.statusCode == 401) {
          print(data['msg']);
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

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: (profilePicture.isNotEmpty)
                  ? NetworkImage(profilePicture)
                  : (widget.userData['gender'] == "Female"
                        ? AssetImage('assets/images/avatar-female.avif')
                        : AssetImage('assets/images/avatar-male.avif')),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${widget.userData['firstName']}",
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
                    widget.userData['rating'].runtimeType == String
                        ? Text(
                            "${widget.userData['rating']}",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 100, 116, 139),
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            "${widget.userData['rating'].toStringAsFixed(1)}",
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
      body: RefreshIndicator(
        onRefresh: _getUserData,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 10),

                // current status
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(53, 0, 0, 0),
                        blurRadius: 30,
                        spreadRadius: 1,
                      ),
                    ],
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
                              fontWeight: FontWeight.w500,
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
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              final response = await http.put(
                                Uri.parse(
                                  "${AppConfig.SERVER_URL}/api/users/update-guide-availability",
                                ),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "idToken": widget.idToken,
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
                                return GuidePackage(widget.userData['uid']);
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
                                return GuideGallery(widget.userData['uid']);
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
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewsScreen(),
                                ),
                              );
                            },
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
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EmergencyServices();
                                  },
                                ),
                              );
                            },
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
      ),
    );
  }
}
