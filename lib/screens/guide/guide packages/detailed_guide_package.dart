import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailedGuidePackage extends StatefulWidget {
  // map of package details retrieving from backend
  Map<String, dynamic> packageData = {};
  DetailedGuidePackage(this.packageData, {super.key});

  @override
  State<DetailedGuidePackage> createState() => _DetailedGuidePackageState();
}

class _DetailedGuidePackageState extends State<DetailedGuidePackage> {
  late List<dynamic> languages = widget.packageData['languages'];
  late List<dynamic> availableDays = widget.packageData['availableDays'];
  late List<dynamic> stops = widget.packageData['stops'];
  late List<dynamic> packageInclude = widget.packageData['packageInclude'];
  late List<dynamic> packageExclude = widget.packageData['packageExclude'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.packageData['packageTitle'],
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 10,
            children: [
              // description
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 15, 84, 20),
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                widget.packageData['description'],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  //color: const Color.fromARGB(255, 101, 101, 101),
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              // category section
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    width: 1.5,
                    color: const Color.fromARGB(255, 15, 84, 20),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // category
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.widgets_outlined,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.packageData['category'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // location
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.packageData['location'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // duration
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.packageData['duration'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // season
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.beach_access_outlined,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Season",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.packageData['season'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // min guests
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.person_3_outlined,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Min Guests",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${widget.packageData['minGuests']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // max guests
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.groups_3_outlined,
                                size: 30,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Max Guests",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${widget.packageData['maxGuests']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
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

              SizedBox(height: 20),
              // start and end locations
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    width: 1.5,
                    color: const Color.fromARGB(255, 15, 84, 20),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 360,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.hail_outlined,
                                  size: 40,
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                ),
                              ],
                            ),
                            Text(
                              "|\n|\n|\n|\n|\n|",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.brown,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 40,
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start",
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.packageData['startLocation'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End",
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.packageData['endLocation'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // languages
              if (languages.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1.5,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Languages",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              for (int i = 0; i < languages.length; i++)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                    ),
                                    Text(
                                      '${languages[i]}',
                                      style: TextStyle(
                                        fontSize: 18,
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

              // available days
              if (availableDays.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1.5,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Available Days",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              for (int i = 0; i < availableDays.length; i++)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                    ),
                                    Text(
                                      '${availableDays[i]}',
                                      style: TextStyle(
                                        fontSize: 18,
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

              // stops
              if (stops.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.tram_outlined,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Stops",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Column(
                            spacing: 10,
                            children: [
                              for (int i = 0; i < stops.length; i++)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.stop_circle_outlined,
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Text(
                                        '${stops[i]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
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

              // Package Includes
              if (packageInclude.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1.5,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.card_giftcard_outlined,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Package Includes",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < packageInclude.length; i++)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                    ),
                                    Text(
                                      '${packageInclude[i]}',
                                      style: TextStyle(
                                        fontSize: 18,
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

              // Package Exclude
              if (packageExclude.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1.5,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.explicit_outlined,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Package Excludes",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < packageExclude.length; i++)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.not_interested,
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        84,
                                        20,
                                      ),
                                    ),
                                    Text(
                                      '${packageExclude[i]}',
                                      style: TextStyle(
                                        fontSize: 18,
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

              // options
              if (widget.packageData['havePrivateTourOption'] ||
                  widget.packageData['haveGroupDiscounts'])
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 1.5,
                          color: const Color.fromARGB(255, 15, 84, 20),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.plus_one_outlined,
                                color: const Color.fromARGB(255, 15, 84, 20),
                              ),
                              Text(
                                "Additional Options",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          if (widget.packageData['havePrivateTourOption'])
                            Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.lock_person_sharp,
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                ),
                                Text(
                                  "Private Tour Option Available",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                          if (widget.packageData['haveGroupDiscounts'])
                            Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.lock_person_sharp,
                                  color: const Color.fromARGB(255, 15, 84, 20),
                                ),
                                Text(
                                  "Group Discounts Available",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),

              //price
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 15, 84, 20),
                    border: BoxBorder.all(width: 1, color: Colors.green),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money_outlined, color: Colors.green),
                      Text(
                        "Package Price: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '${widget.packageData['price']}',
                        style: TextStyle(fontSize: 20, color: Colors.white),

                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        " LKR ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        "(p/p) ",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
