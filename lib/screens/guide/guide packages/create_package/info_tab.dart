import 'package:flutter/material.dart';
import 'package:traamp_frontend/screens/guide/guide%20packages/create_package/guide_package_data.dart';

class InfoTab extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final GuidePackageData data;

  InfoTab(this._formKey, this.data, {super.key});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  Set<String> _selectedLanguages = {};

  Widget clickableIcons(String language) {
    final isSelected = _selectedLanguages.contains(language);
    return IconButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _selectedLanguages.remove(language);
            print(_selectedLanguages.toList());
            widget.data.languages = _selectedLanguages.toList();
          } else {
            _selectedLanguages.add(language);
            print(_selectedLanguages.toList());
            widget.data.languages = _selectedLanguages.toList();
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
        child: Text(language),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _categoryList = [
      "Adventure",
      "Culture",
      "Wildlife",
      "Beach",
      "City",
    ];

    return SingleChildScrollView(
      child: Form(
        key: widget._formKey,
        child: Container(
          child: Column(
            children: [
              // #1
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Package Title *", style: TextStyle(fontSize: 18)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none, // removes the bottom line
                        enabledBorder:
                            InputBorder.none, // also removes when not focused
                        focusedBorder: InputBorder.none,
                        hintText:
                            "e.g. Ancient Temples & Cultural Heritage Tour",
                      ),
                      onChanged: (text) {
                        setState(() {
                          widget.data.packageTitle = text.trim();
                        });
                      },
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Package Title cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #2
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category *", style: TextStyle(fontSize: 18)),
                  Container(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: _categoryList.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.data.category = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please select your category";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #3
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Short Description *", style: TextStyle(fontSize: 18)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none, // removes the bottom line
                        enabledBorder:
                            InputBorder.none, // also removes when not focused
                        focusedBorder: InputBorder.none,
                        hintText: "Brief one line description",
                      ),
                      onChanged: (text) {
                        setState(() {
                          widget.data.shortDescription = text.trim();
                        });
                      },
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Description cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #4
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Description *", style: TextStyle(fontSize: 18)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText:
                            "Detailed description of your tour package...",
                      ),
                      //validation
                      validator: (text) {
                        if (text == null || text == "") {
                          return "Full description cannot be empty";
                        }
                        return null;
                      },
                      //save global variable
                      onChanged: (text) {
                        setState(() {
                          widget.data.description = text.trim();
                        });
                      },
                      maxLines: 5,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #5
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("location/City *", style: TextStyle(fontSize: 18)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none, // removes the bottom line
                        enabledBorder:
                            InputBorder.none, // also removes when not focused
                        focusedBorder: InputBorder.none,
                        hintText: "e.g. Kandy, Colombo, Galle",
                      ),
                      onChanged: (text) {
                        setState(() {
                          widget.data.location = text.toLowerCase().trim();
                        });
                      },
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Location cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #6
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Languages Offered ", style: TextStyle(fontSize: 18)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // first row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            clickableIcons("English"),
                            clickableIcons("Sinhala"),
                            clickableIcons("Tamil"),
                            clickableIcons("German"),
                          ],
                        ),

                        // 2nd row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            clickableIcons("French"),
                            clickableIcons("Chinese"),
                            clickableIcons("Russian"),
                            clickableIcons("Spanish"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
