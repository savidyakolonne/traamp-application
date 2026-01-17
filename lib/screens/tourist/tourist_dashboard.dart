import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class TouristDashboard extends StatefulWidget {
  const TouristDashboard({super.key});

  @override
  State<TouristDashboard> createState() => _TouristDashboardState();
}

class _TouristDashboardState extends State<TouristDashboard> {
  Widget suggetionScrollableView() {
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
                  "Hi Lyod",
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
            onPressed: () {},
            icon: Icon(Icons.favorite, size: 35.0, color: Colors.red[700]),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
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
                      onPressed: () {},
                      icon: Icon(Icons.location_on_outlined),
                    ),
                    Text("Kurunegala"),
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
                                border: BoxBorder.all(width: 2.0),
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
                            SizedBox(height: 8.0),
                            Text(
                              "Guides",
                              style: TextStyle(
                                fontSize: 18.0,
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
                                border: BoxBorder.all(width: 2.0),
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
                            SizedBox(height: 8.0),
                            Text(
                              "Places",
                              style: TextStyle(
                                fontSize: 18.0,
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
                                border: BoxBorder.all(width: 2.0),
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
                            SizedBox(height: 8.0),
                            Text(
                              "Activities",
                              style: TextStyle(
                                fontSize: 18.0,
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
                                border: BoxBorder.all(width: 2.0),
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(16.0),
                                ),
                              ),

                              child: IconButton(
                                onPressed: () {},
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
                                border: BoxBorder.all(width: 2.0),
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
                            SizedBox(height: 8.0),
                            Text(
                              "Weather",
                              style: TextStyle(
                                fontSize: 18.0,
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
                                border: BoxBorder.all(width: 2.0),
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
                            SizedBox(height: 8.0),
                            Text(
                              "Emergency\nContacts",
                              style: TextStyle(
                                fontSize: 18.0,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [suggetionScrollableView()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        color: const Color.fromARGB(131, 122, 9, 144),
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
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(),
        color: Colors.green,
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              IconButton(
                icon: Icon(Icons.home_outlined, size: 40, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.email_outlined, size: 36, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  size: 36,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
