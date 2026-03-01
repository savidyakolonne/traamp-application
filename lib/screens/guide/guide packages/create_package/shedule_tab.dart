import 'package:flutter/material.dart';
import 'guide_package_data.dart';

class ScheduleTab extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final GuidePackageData data;

  const ScheduleTab(this._formKey, this.data, {super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabTabState();
}

class _ScheduleTabTabState extends State<ScheduleTab> {
  List<String> _units = ["Hours", "Days"];
  List<String> _season = ["All Year", "Summer", "Winter", "Monsoon"];
  List<String> durationArray = ["", ""];

  Set<String> _availableDays = {};

  String durationValue = "";

  Widget clickableIcons(String day) {
    final isSelected = _availableDays.contains(day);
    return IconButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _availableDays.remove(day);
            print(_availableDays.toList());
            widget.data.availableDays = _availableDays.toList();
          } else {
            _availableDays.add(day);
            print(_availableDays.toList());
            widget.data.availableDays = _availableDays.toList();
          }
        });
      },
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(day),
      ),
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
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration Value*", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 4),
                    Container(
                      width: 150,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: TextFormField(
                        maxLength: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none, // removes the bottom line
                          enabledBorder:
                              InputBorder.none, // also removes when not focused
                          focusedBorder: InputBorder.none,
                          hintText: "e.g. 4",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Duration cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (text) {
                          setState(() {
                            durationArray[0] = text.trim();
                            widget.data.duration =
                                durationArray[0] + " " + durationArray[1];
                          });
                          print(widget.data.duration);
                        },
                      ),
                    ),
                  ],
                ),
                // Unit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Unit *", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Container(
                      width: 100,
                      height: 80,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _units.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            durationArray[1] = value!;
                            widget.data.duration =
                                durationArray[0] + " " + durationArray[1];
                          });
                          print(widget.data.duration);
                        },
                        validator: (value) {
                          if (value == null || value == "") {
                            return "*";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            // second form element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Available Days", style: TextStyle(fontSize: 18)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // first row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          clickableIcons("Monday"),
                          clickableIcons("Tuesday"),
                          clickableIcons("Wednesday"),
                          clickableIcons("Thursday"),
                        ],
                      ),

                      // 2nd row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          clickableIcons("Friday"),
                          clickableIcons("Saturday"),
                          clickableIcons("Sunday"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // third form element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Season *", style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Container(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _season.map((season) {
                      return DropdownMenuItem(
                        value: season,
                        child: Text(season),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.data.season = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
