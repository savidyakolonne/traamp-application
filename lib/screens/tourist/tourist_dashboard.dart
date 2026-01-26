import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../../components/bottom_nav.dart';
import 'package:traamp_frontend/services/location_service.dart';
import 'package:traamp_frontend/screens/map/map_screen.dart';

class TouristDashboard extends StatefulWidget {
  const TouristDashboard({super.key});

  @override
  State<TouristDashboard> createState() => _TouristDashboardState();
}

class _TouristDashboardState extends State<TouristDashboard> {
  String? name;
  String currentLocation = "Unknown location";

  // object for bottom navigation, isTourist = true
  BottomNav nav = BottomNav(true);

  @override
  void initState() {
    super.initState();
    getNameFromEmail();
    getCurrentCity();
  }

  // get name from db from email
  Future<void> getNameFromEmail() async {
    try {
      //get firstName from firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('firstName')) {
        setState(() {
          name = doc['firstName'];
        });
      }
    } catch (e) {
      setState(() {
        print('Error fetching name: $e');
        name = null;
      });
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
                  "Hi $name",
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
                              onPressed: () {},
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
                              onPressed: () {},
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
                              onPressed: () {},
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
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
