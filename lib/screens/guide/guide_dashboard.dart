import 'dart:convert';
import 'package:clickable_widget/clickable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:text_gradiate/text_gradiate.dart';
import 'package:traamp_frontend/screens/emergency_services/emergency_services.dart';
import '../../services/location_service.dart';
import '../../components/weather/weather_screen.dart';
import 'guide_gallery.dart';
import 'guide_package.dart';

class GuideDashboard extends StatefulWidget {
  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

class _GuideDashboardState extends State<GuideDashboard> {
  String currentLocation = "Unknown location";
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
            Uri.parse("http://localhost:3000/api/users/get-user-data"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"idToken": idToken}),
          );

          final data = await jsonDecode(response.body);

          if (response.statusCode == 200) {
            setState(() {
              userData = data['data'];
              availability = userData['availability'];
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

  String getAvailability(List<String> list) {
    if (availability == true) {
      return list[1];
    } else if (availability == false) {
      return list[0];
    } else {
      return "";
    }
  }

  Widget availabilityStatusDropMenu() {
    List<String> list = ["I'm not available", "I'm currently available"];
    String dropdownValue = getAvailability(list);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          elevation: 16,
          style: TextStyle(color: availability ? Colors.green : Colors.red),
          onChanged: (String? value) async {
            setState(() {
              // update dropdown value
              dropdownValue = value!;
              availability = (dropdownValue == list[1]);
            });
            // update database
            try {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null && idToken != null) {
                final response = await http.put(
                  Uri.parse(
                    "http://localhost:3000/api/users/update-guide-availability",
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
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ],
    );
  }

  Widget cardElement(String imageURL, String cardTitle, bool toGuidePackage) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClickableCard(
        color: Colors.white,
        child: Row(
          children: [
            Image.asset(imageURL),
            SizedBox(width: 8),
            TextGradiate(
              text: Text(
                cardTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              colors: [
                const Color.fromARGB(255, 61, 141, 64),
                const Color.fromARGB(255, 0, 64, 36),
              ],
              gradientType: GradientType.linear,
            ),
            SizedBox(width: 8),
          ],
        ),
        // if toGuidePackage = true go to guide package screen else go to gallery screen
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  toGuidePackage ? GuidePackage() : GuideGallery(),
            ),
          );
        },
      ),
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
          Padding(
            padding: EdgeInsetsGeometry.only(right: 8),
            child: Row(
              children: [
                Icon(Icons.star, size: 20.0, color: Colors.yellow[700]),
                Text('${userData['rating']}'),
              ],
            ),
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
            spacing: 8,
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
              availabilityStatusDropMenu(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  cardElement(
                    "assets/images/jeep.png",
                    "Your Packages  ",
                    true,
                  ),
                  cardElement(
                    "assets/images/wild.png",
                    "Your Gallery       ",
                    false,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // #1
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Image.asset("assets/images/news.png"),
                        ),
                      ),
                      Text("News"),
                    ],
                  ),

                  // #2
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return WeatherScreen(false);
                                },
                              ),
                            );
                          },
                          icon: Image.asset("assets/images/weather.png"),
                        ),
                      ),
                      Text("Weather"),
                    ],
                  ),

                  // #3
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                  return EmergencyServices();
                                }));
                              },
                          icon: Image.asset("assets/images/sos.png"),
                        ),
                      ),
                      Text("Emergency\ncontacts", textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
