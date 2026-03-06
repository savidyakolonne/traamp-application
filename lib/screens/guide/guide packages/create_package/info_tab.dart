import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
  String coverImageName = "";
  int imageCount = 0;

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
                  Text(
                    "Package Title *",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 15, 84, 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5),
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
                  Text(
                    "Category *",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 15, 84, 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                  Text(
                    "Short Description *",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 15, 84, 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5),
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
                  Text(
                    "Full Description *",
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
                  Text(
                    "location/City *",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 15, 84, 20),
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
                      maxLength: 26,
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
                  Text(
                    "Languages Offered ",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 15, 84, 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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

              SizedBox(height: 10),

              // #7
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cover Image *",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 15, 84, 20),
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
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none, // removes the bottom line
                        enabledBorder:
                            InputBorder.none, // also removes when not focused
                        focusedBorder: InputBorder.none,
                        hintText: coverImageName.isEmpty
                            ? "Please upload a cover image"
                            : coverImageName,
                      ),
                      validator: (text) {
                        if (coverImageName.isEmpty) {
                          return "Cover Image cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png', 'heif'],
                          );

                      if (result != null) {
                        PlatformFile file = result.files.single;
                        // set file name as hintText
                        setState(() {
                          coverImageName = file.name;
                          widget.data.coverImage = File(file.path!);
                          print("cover image path: ${widget.data.coverImage}");
                        });
                      } else {
                        // User canceled the picker
                        print("User canceled the picker");
                      }
                    },
                    child: Text(
                      "Select",
                      style: TextStyle(color: Color.fromARGB(255, 15, 84, 20)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // #8
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Other Images",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 15, 84, 20),
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
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none, // removes the bottom line
                        enabledBorder:
                            InputBorder.none, // also removes when not focused
                        focusedBorder: InputBorder.none,
                        hintText: imageCount == 0
                            ? "Upload package images"
                            : "${imageCount} images selected",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png', 'heif'],
                          );

                      if (result != null) {
                        List<File> files = result.paths
                            .map((path) => File(path!))
                            .toList();
                        print(widget.data.images);
                        // set file count as hintText
                        setState(() {
                          widget.data.images = files;
                          imageCount = widget.data.images.length;
                        });
                      }
                    },
                    child: Text(
                      "Select",
                      style: TextStyle(color: Color.fromARGB(255, 15, 84, 20)),
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