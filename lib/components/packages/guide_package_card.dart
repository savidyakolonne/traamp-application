import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../appConfig.dart';
import '../../screens/guide/guide packages/detailed_guide_package.dart';

// ignore: must_be_immutable
class GuidePackageCard extends StatefulWidget {
  // map of package details retrieving from backend
  Map<String, dynamic> packageData = {};
  GuidePackageCard(this.packageData, {super.key});

  @override
  State<GuidePackageCard> createState() => _GuidePackageCardState();
}

class _GuidePackageCardState extends State<GuidePackageCard> {
  bool delete = false; // to check if long tapped or not

  Future<void> deletePackage() async {
    try {
      final response = await http.delete(
        Uri.parse("${AppConfig.SERVER_URL}/api/guidePackage/delete-package"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'packageId': widget.packageData['packageId']}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: const Color.fromARGB(180, 244, 67, 54),
          ),
        );
      } else {
        print('${data['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while deleting the package.'),
            backgroundColor: const Color.fromARGB(180, 244, 67, 54),
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while connecting to server'),
          backgroundColor: const Color.fromARGB(180, 244, 67, 54),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          onLongPress: () {
            setState(() {
              if (delete) {
                delete = false;
              } else {
                delete = true;
              }
            });
          },
          icon: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: const Color.fromARGB(255, 15, 84, 20),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //first element
                Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 85, 205, 89),
                    border: BoxBorder.all(
                      color: const Color.fromARGB(255, 115, 194, 117),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.widgets_outlined,
                        color: const Color.fromARGB(255, 15, 84, 20),
                      ),
                      Text(
                        "${widget.packageData['category']}",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 15, 84, 20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2nd element
                Text(
                  "${widget.packageData['packageTitle']}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 15, 84, 20),
                  ),
                ),

                // 3rd element
                Text(
                  "${widget.packageData['shortDescription']}",
                  style: TextStyle(fontSize: 15),
                ),

                // 4th element
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: const Color.fromARGB(255, 15, 84, 20),
                      size: 28,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        Text(
                          "${widget.packageData['duration']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                // 5th element
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: const Color.fromARGB(255, 15, 84, 20),
                          size: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 120, 120, 120),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "${widget.packageData['location']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.attach_money_outlined,
                          color: const Color.fromARGB(255, 15, 84, 20),
                          size: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 120, 120, 120),
                              ),
                            ),
                            Text(
                              "LKR ${widget.packageData['price']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // delete button
        if (delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: const Color.fromARGB(255, 183, 13, 1),
                  ),
                  //color: const Color.fromARGB(75, 158, 158, 158),
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.only(right: 16, bottom: 10),
                padding: EdgeInsets.only(right: 1),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      deletePackage();
                    });
                  },
                  icon: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: const Color.fromARGB(255, 183, 13, 1),
                      ),
                      Text(
                        "Delete Package",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 183, 13, 1),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
