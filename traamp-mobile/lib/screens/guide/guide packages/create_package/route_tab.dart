import 'package:flutter/material.dart';
import '../../../../models/guide_package_data.dart';

class RouteTab extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final GuidePackageData data;

  const RouteTab(this._formKey, this.data, {super.key});

  @override
  State<RouteTab> createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab> {
  int stopCount = 1;
  List<TextEditingController> stopControllers = [TextEditingController()];
  List<String> get stops => stopControllers.map((c) => c.text.trim()).toList();
  List<bool> checkValues = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void addStop() {
    setState(() {
      stopControllers.add(TextEditingController());
      widget.data.stops = stops;
      print(stops);
    });
  }

  void removeStop(int index) {
    setState(() {
      stopControllers[index].dispose();
      stopControllers.removeAt(index);
      widget.data.stops = stops;
      print(stops);
    });
  }

  Widget checkWidgetForPackageIncludes(int index, String name) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: const Color.fromARGB(255, 15, 84, 20),
          value: checkValues[index],
          onChanged: (bool? value) {
            setState(() {
              checkValues[index] = value!;
              if (value) {
                widget.data.packageInclude.add(name);
              } else {
                widget.data.packageInclude.remove(name);
              }
              print(widget.data.packageInclude);
            });
          },
        ),
        Text(name, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget checkWidgetForPackageNotIncludes(int index, String name) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: const Color.fromARGB(255, 15, 84, 20),
          value: checkValues[index],
          onChanged: (bool? value) {
            setState(() {
              checkValues[index] = value!;
              if (value) {
                widget.data.packageExclude.add(name);
              } else {
                widget.data.packageExclude.remove(name);
              }
              print(widget.data.packageExclude);
            });
          },
        ),
        Text(name, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget tourStopWidget(int stopCount) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tour Stops",
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 15, 84, 20),
            fontWeight: FontWeight.w500,
          ),
        ),
        // Dynamic Stop Fields
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stopControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: stopControllers[index],
                      decoration: InputDecoration(
                        hintText: "Stop ${index + 1}",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          stops.add(value.trim());
                          widget.data.stops = stops;
                          print(stops);
                        });
                      },
                    ),
                  ),

                  // Remove button
                  if (stopControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => removeStop(index),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // first form element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Start Location *",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 15, 84, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none, // removes the bottom line
                      enabledBorder:
                          InputBorder.none, // also removes when not focused
                      focusedBorder: InputBorder.none,
                      hintText: "e.g. Hotel Pickup, Airport Pickup",
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Start location cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        widget.data.startLocation = text.trim();
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // second form element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "End Location *",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 15, 84, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none, // removes the bottom line
                      enabledBorder:
                          InputBorder.none, // also removes when not focused
                      focusedBorder: InputBorder.none,
                      hintText: "e.g. Same as Pickup, Kandy City Center",
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "End location cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        widget.data.endLocation = text.trim();
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // third form element
            tourStopWidget(stopCount),
            SizedBox(height: 10),
            IconButton(
              onPressed: () => addStop(),
              icon: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 15, 84, 20),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      "+",
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 15, 84, 20),
                      ),
                    ),
                    Text(
                      "Add Stop",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 15, 84, 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // fourth element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What's Included",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 15, 84, 20),
                  ),
                ),
                SizedBox(height: 10),
                checkWidgetForPackageIncludes(0, "Transportation"),
                checkWidgetForPackageIncludes(1, "Tour Guide"),
                checkWidgetForPackageIncludes(2, "Entry Fees"),
                checkWidgetForPackageIncludes(3, "Lunch"),
                checkWidgetForPackageIncludes(4, "Refreshment"),
                checkWidgetForPackageIncludes(5, "Photography"),
                checkWidgetForPackageIncludes(6, "Insurance"),
              ],
            ),

            SizedBox(height: 10),

            // fifth element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What's Not Included",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 15, 84, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                checkWidgetForPackageNotIncludes(7, "Personal Expenses"),
                checkWidgetForPackageNotIncludes(8, "Alcoholic Beverages"),
                checkWidgetForPackageNotIncludes(9, "Tips"),
                checkWidgetForPackageNotIncludes(10, "Additional Activities"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
