import 'package:flutter/material.dart';

import '../screens/tourist/deatailed_package_view_tourist.dart';

// ignore: must_be_immutable
class SuggestionCard extends StatefulWidget {
  String url;
  String title;
  String location;
  String price;
  String uid;
  Map<String, dynamic> packageData;

  SuggestionCard(
    this.url,
    this.title,
    this.location,
    this.price,
    this.packageData,
    this.uid, {
    super.key,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(47, 0, 0, 0),
            spreadRadius: 1,
            blurRadius: 5,
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
                image: NetworkImage(widget.url),
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
                  widget.title,
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
                      widget.location,
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
                          "LKR ${widget.price}",
                          style: TextStyle(
                            color: Colors.green,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailedPackageViewTourist(
                                widget.packageData,
                                widget.uid,
                              );
                            },
                          ),
                        );
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
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
}
