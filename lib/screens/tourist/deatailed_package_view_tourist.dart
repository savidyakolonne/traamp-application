import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailedPackageViewTourist extends StatefulWidget {
  // map of package details retrieving from backend
  Map<String, dynamic> packageData = {};
  DetailedPackageViewTourist(this.packageData, {super.key});

  @override
  State<DetailedPackageViewTourist> createState() =>
      _DetailedPackageViewTouristState();
}

class _DetailedPackageViewTouristState
    extends State<DetailedPackageViewTourist> {
  late List<dynamic> languages = widget.packageData['languages'];
  late List<dynamic> availableDays = widget.packageData['availableDays'];
  late List<dynamic> stops = widget.packageData['stops'];
  late List<dynamic> packageInclude = widget.packageData['packageInclude'];
  late List<dynamic> packageExclude = widget.packageData['packageExclude'];
  late List<dynamic> images = widget.packageData['images'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover image
            Container(
              padding: EdgeInsets.only(top: 60, left: 16),
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.packageData['coverImage']),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(162, 141, 145, 145),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // title section
            Transform.translate(
              offset: Offset(0, -50), // move up
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 30,
                  children: [
                    // heading section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(74, 0, 0, 0),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // category
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 229, 246, 211),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              widget.packageData['category'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 125, 212, 33),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // title
                          Text(
                            widget.packageData['packageTitle'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          // location
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Color.fromARGB(255, 100, 116, 139),
                              ),
                              Text(
                                widget.packageData['location'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 100, 116, 139),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // duration, season, guest section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        // duration
                        Container(
                          padding: EdgeInsets.all(16),
                          width: 105,
                          height: 120,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(74, 0, 0, 0),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Color.fromARGB(255, 125, 212, 33),
                                size: 28,
                              ),
                              Text(
                                "DURATION",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 116, 139),
                                ),
                              ),
                              Text(
                                widget.packageData['duration'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // season
                        Container(
                          padding: EdgeInsets.all(16),
                          width: 105,
                          height: 120,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(74, 0, 0, 0),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Color.fromARGB(255, 125, 212, 33),
                                size: 28,
                              ),
                              Text(
                                "SEASON",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 116, 139),
                                ),
                              ),
                              Text(
                                widget.packageData['season'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // guests
                        Container(
                          padding: EdgeInsets.all(16),
                          width: 105,
                          height: 120,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(74, 0, 0, 0),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.groups_3_outlined,
                                color: Color.fromARGB(255, 125, 212, 33),
                                size: 28,
                              ),
                              Text(
                                "GUESTS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 116, 139),
                                ),
                              ),
                              Text(
                                '${widget.packageData['minGuests']}-${widget.packageData['maxGuests']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // description
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            textAlign: TextAlign.justify,
                            widget.packageData['shortDescription'],
                            style: TextStyle(
                              color: Color.fromARGB(255, 104, 188, 14),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.packageData['description'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Color.fromARGB(255, 100, 116, 139),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),

                          if (images.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 20,
                                  children: [
                                    for (int i = 0; i < images.length; i++)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                74,
                                                0,
                                                0,
                                                0,
                                              ),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: NetworkImage(images[i]),
                                          ),
                                        ),

                                        width: 200,
                                        height: 150,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // what's include section
                    if (packageInclude.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's Included",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // elements
                            for (int i = 0; i < packageInclude.length; i++)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        0.435,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          packageInclude[i]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Color.fromARGB(255, 125, 212, 33),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                    // what's excluded section
                    if (packageExclude.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's Excluded",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(),
                            // elements
                            for (int i = 0; i < packageExclude.length; i++)
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  Text(
                                    packageExclude[i].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: .fromARGB(255, 100, 116, 139),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                    // planned stops
                    if (stops.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Planned Stops",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            // elements
                            for (int i = 0; i < stops.length; i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 40,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: const Color.fromARGB(
                                              255,
                                              125,
                                              212,
                                              33,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        stops[i].toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (i != stops.length - 1)
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 3,
                                      height: 30,
                                      color: const Color.fromARGB(
                                        255,
                                        181,
                                        235,
                                        122,
                                      ),
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

            // price
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(28, 0, 0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                spacing: 20,
                children: [
                  Text(
                    "TOTAL PRICE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: .fromARGB(255, 100, 116, 139),
                    ),
                  ),
                  Text(
                    "${widget.packageData['price']} LKR",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 130, 185, 70),
                    ),
                  ),
                ],
              ),
            ),

            // additional details
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              color: Color.fromARGB(255, 241, 245, 249),
              child: Column(
                spacing: 10,
                children: [
                  // 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Start Location", style: TextStyle(fontSize: 16)),
                      Text(
                        textAlign: TextAlign.right,
                        "${widget.packageData['startLocation']}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("End Location", style: TextStyle(fontSize: 16)),
                      Text(
                        textAlign: TextAlign.right,
                        "${widget.packageData['endLocation']}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // 3
                  if (languages.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Languages", style: TextStyle(fontSize: 16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (int i = 0; i < languages.length; i++)
                              Text(
                                textAlign: TextAlign.right,
                                "${languages[i].toString()}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                  // 4
                  if (widget.packageData['haveGroupDiscounts'] ||
                      widget.packageData['havePrivateTourOption'])
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tour Options", style: TextStyle(fontSize: 16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            widget.packageData['havePrivateTourOption']
                                ? Text(
                                    textAlign: TextAlign.right,
                                    "Private Tour Available",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    textAlign: TextAlign.right,
                                    "No Private Tours",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                            widget.packageData['haveGroupDiscounts']
                                ? Text(
                                    textAlign: TextAlign.right,
                                    "Group Discounts Available",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    textAlign: TextAlign.right,
                                    "No Group Discounts",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),

                  // 5
                  if (availableDays.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Available Days", style: TextStyle(fontSize: 16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (availableDays.length == 7)
                              Text(
                                textAlign: TextAlign.right,
                                "Mon - Sun",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            if (availableDays.length != 7)
                              for (int i = 0; i < availableDays.length; i++)
                                Text(
                                  textAlign: TextAlign.right,
                                  "${availableDays[i].toString()}",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
