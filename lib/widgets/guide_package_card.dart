import 'package:flutter/material.dart';
import '../screens/guide/guide packages/detailed_guide_package.dart';

// ignore: must_be_immutable
class GuidePackageCard extends StatefulWidget {
  // map of package details retrieving from backend
  Map<String, dynamic> packageData = {};
  GuidePackageCard(this.packageData, {super.key});

  @override
  State<GuidePackageCard> createState() => _GuidePackageCardState();
}

class _GuidePackageCardState extends State<GuidePackageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(141, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          // Cover image section
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.packageData['coverImage']),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                // duration
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(172, 0, 0, 0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.white),
                      Text(
                        "${widget.packageData['duration']}",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),

                // location
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(172, 0, 0, 0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.white),
                      Text(
                        "${widget.packageData['location']}",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // content section
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                // heading and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.packageData['packageTitle'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'LKR ${widget.packageData['price']}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 125, 212, 33),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "PER PERSON",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 148, 163, 184),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // short description
                Container(
                  padding: EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: Text(
                    textAlign: TextAlign.justify,
                    widget.packageData['shortDescription'],
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 100, 116, 139),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // manage button
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailedGuidePackage(widget.packageData);
                        },
                      ),
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(141, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                      color: const Color.fromARGB(255, 125, 212, 33),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings_outlined, size: 22),
                        Text(
                          "Manage",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
