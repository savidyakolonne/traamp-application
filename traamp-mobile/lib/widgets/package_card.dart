import 'package:flutter/material.dart';

import '../screens/tourist/deatailed_package_view_tourist.dart';

// ignore: must_be_immutable
class PackageCard extends StatefulWidget {
  Map<String, dynamic> packageData = {};
  String uid;
  PackageCard(this.packageData, this.uid, {super.key});

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Container(
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
                        width: MediaQuery.of(context).size.width * 0.5,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              'LKR ${widget.packageData['price']}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 125, 212, 33),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailedPackageViewTourist(widget.packageData, widget.uid);
            },
          ),
        );
      },
    );
  }
}
