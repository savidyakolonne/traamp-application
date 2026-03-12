import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';
import '../../list-data.dart';
import '../../models/guide.dart';
import 'login_setup.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class GuideSignupForm extends StatefulWidget {
  const GuideSignupForm({super.key});
  @override
  State<GuideSignupForm> createState() => _GuideSignupFormState();
}

class _GuideSignupFormState extends State<GuideSignupForm> {
  // global key object for Form
  final GlobalKey<FormState> _formKeyGuide = GlobalKey<FormState>();
  // DOB text editing controller
  final TextEditingController _dobController = TextEditingController();

  final Color primaryColor = Colors.lightGreen;

  final List<String> _genders = ListData.gender;
  final List<String> _certificateType = ListData.guideCertificates;
  final List<String> _districts = ListData.districts;

  // global variables to store data coming from form
  String firstName = "";
  String lastName = "";
  String email = "";
  String rowPassword = "";
  String password = "";
  String gender = "";
  String dob = "";
  String phoneNumber = "";
  String? guideCertificateType;
  String? certificateNumber;
  File? uploadedCertificatePath;
  Uint8List? uploadedCertificateBytes;
  String nic = "";
  String location = "";
  String address = "";
  String country = "Sri Lanka";
  String type = "guide";
  double rating = 0.0;
  bool availability = false;

  // first name
  Widget firstNameFormField() {
    return TextFormField(
      decoration: fieldStyle("First Name"),
      //validation
      validator: (text) {
        if (text == null || text == "") {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      //save global variable
      onSaved: (text) {
        firstName = text!.trim();
      },
      showCursor: true,
    );
  }

  // last name
  Widget lastNameFormField() {
    return TextFormField(
      decoration: fieldStyle("Last Name"),
      //validation
      validator: (text) {
        if (text == null || text == "") {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      //save global variable
      onSaved: (text) {
        lastName = text!.trim();
      },
    );
  }

  // email
  Widget emailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: fieldStyle("Email Address"),
      validator: (mail) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (mail == null || mail == "") {
          return "Email cannot be empty";
        } else {
          if (!emailRegex.hasMatch(mail)) {
            return 'Enter a valid email address';
          }
        }
        return null;
      },
      onSaved: (mail) {
        email = mail!.toLowerCase().trim();
      },
    );
  }

  // passowrd
  Widget passwordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: fieldStyle("Password"),
      validator: (pass) {
        if (pass != null && pass != "") {
          if (pass.length >= 8 && pass.length <= 16) {
            if (RegExp(r'[A-Z]').hasMatch(pass)) {
              if (RegExp(r'[a-z]').hasMatch(pass)) {
                if (RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) {
                  rowPassword = pass;
                } else {
                  return 'Password must contain at least one symbol';
                }
              } else {
                return 'Password must contain at least one lowercase letter';
              }
            } else {
              return 'Password must contain at least one uppercase letter';
            }
          } else {
            return "Password must have 8 - 16 characters";
          }
        } else {
          return "Enter a password";
        }
        return null;
      },
      onSaved: (pass) {
        password = pass!;
      },
    );
  }

  // confirm password
  Widget confirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: fieldStyle("Confirm Password"),
      validator: (cPass) {
        if (cPass != null && cPass != "") {
          if (rowPassword != cPass) {
            return "Passwords do not match.";
          }
        } else {
          return "Please confirm your password";
        }
        return null;
      },
    );
  }

  // Gender
  Widget genderFormField() {
    return DropdownButtonFormField<String>(
      decoration: fieldStyle("Select Gender"),
      items: _genders.map((gender) {
        return DropdownMenuItem(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (value) {
        setState(() {
          gender = value!;
        });
      },
      validator: (value) {
        if (value == null || value == "") {
          return "Please select your gender";
        }
        return null;
      },
    );
  }

  // DOB
  Widget dobFormField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true, // prevent manual typing
      decoration: fieldStyle(
        "DOB",
      ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000), // default date
          firstDate: DateTime(1900), // earliest allowed DOB
          lastDate: DateTime.now(), // latest allowed DOB
        );

        if (pickedDate != null) {
          setState(() {
            _dobController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      validator: (value) {
        if (value == null || value == "") {
          return "Please select your DOB";
        }
        return null;
      },
      onSaved: (date) {
        dob = date!;
      },
    );
  }

  // phone number
  Widget phoneNumberFormField() {
    return TextFormField(
      decoration: fieldStyle("Phone Number (ex: +94771234567)"),
      //validation
      validator: (number) {
        if (number == null || number.isEmpty) {
          return 'Phone number is required';
        }
        // Must be exactly 12 characters
        if (number.length != 12) {
          return 'Phone number must be exactly 12 characters';
        }
        // Must start with +94
        if (!number.startsWith('+94')) {
          return 'Phone number must start with +94';
        }
        // Remaining 9 characters must be digits only
        final digitsPart = number.substring(3);
        if (!RegExp(r'^[0-9]{9}$').hasMatch(digitsPart)) {
          return 'Phone number must contain 9 digits after +94';
        }
        return null;
      },
      //save global variable
      onSaved: (number) {
        phoneNumber = number!.trim();
      },
      keyboardType: TextInputType.number,
    );
  }

  //certificate type
  Widget certificateTypeFormField() {
    return DropdownButtonFormField<String>(
      decoration: fieldStyle("Select Certificate Type"),
      items: _certificateType.map((certificateType) {
        return DropdownMenuItem(
          value: certificateType,
          child: Text(certificateType),
        );
      }).toList(),
      onChanged: (certificate) {
        setState(() {
          guideCertificateType = certificate;
        });
      },
      validator: (certificate) {
        return null;
      },
      onSaved: (certificate) {
        guideCertificateType = certificate;
      },
    );
  }

  //NIC
  Widget NICFormField() {
    return TextFormField(
      decoration: fieldStyle("NIC Number (123214255v/123456789123)"),
      //validation
      validator: (number) {
        if (number == null || number.isEmpty) {
          return 'NIC number is required';
        }
        if (number.length != 12 && number.length != 10) {
          return 'NIC must be 123456789v or 123456789123';
        }
        return null;
      },
      //save global variable
      onSaved: (number) {
        nic = number!.toLowerCase().trim();
      },
    );
  }

  // certificate number
  Widget certificateNumberField() {
    return TextFormField(
      decoration: fieldStyle("Certificate Number"),
      //validation
      validator: (number) {
        return null;
      },
      //save global variable
      onSaved: (number) {
        if (number == "" || number == null) {
          certificateNumber = null;
        } else {
          certificateNumber = number;
        }
      },
    );
  }

  // Location
  Widget locationFormField() {
    return DropdownButtonFormField<String>(
      decoration: fieldStyle("Select Location"),
      items: _districts.map((district) {
        return DropdownMenuItem(value: district, child: Text(district));
      }).toList(),
      onChanged: (value) {
        setState(() {
          location = value!;
        });
      },
      validator: (value) {
        if (value == null || value == "") {
          return "Please select your location";
        }
        return null;
      },
    );
  }

  // upload certificate section
  String hint = "";
  Widget uploadCertificateBox() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'doc', 'heif', 'png', 'jpeg'],
          withData: true,
        );

        if (result != null) {
          PlatformFile file = result.files.single;

          setState(() {
            hint = file.name;
          });

          if (kIsWeb) {
            uploadedCertificateBytes = file.bytes;
          } else {
            uploadedCertificatePath = File(file.path!);
          }
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upload Guide Certificate",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, color: primaryColor, size: 32),
                const SizedBox(height: 8),
                Text(
                  hint.isEmpty ? "Tap to upload certificate" : hint,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 10) {
        setState(() => _appBarColor = const Color.fromARGB(241, 177, 177, 177));
      } else {
        setState(() => _appBarColor = Colors.white);
      }
    });
  }

  //Address
  Widget addressFormField() {
    return TextFormField(
      decoration: fieldStyle("Address"),
      //validation
      validator: (text) {
        if (text == null || text == "") {
          return "Address cannot be empty";
        }
        if (text.length <= 5) {
          return "Must be more than 5 charactors";
        }
        return null;
      },
      //save global variable
      onSaved: (text) {
        address = text!;
      },
      maxLines: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKeyGuide,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// LOGO
              Center(child: Image.asset("assets/images/logo.png", height: 90)),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Register as a Guide",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: Text(
                  "Fill the details below to continue",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),

              /// FIRST + LAST NAME
              Row(
                children: [
                  Expanded(child: firstNameFormField()),
                  const SizedBox(width: 15),
                  Expanded(child: lastNameFormField()),
                ],
              ),

              const SizedBox(height: 15),

              emailFormField(),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(child: genderFormField()),
                  const SizedBox(width: 15),
                  Expanded(child: dobFormField()),
                ],
              ),

              const SizedBox(height: 15),

              phoneNumberFormField(),

              const SizedBox(height: 15),

              addressFormField(),

              const SizedBox(height: 15),

              NICFormField(),

              const SizedBox(height: 15),

              certificateTypeFormField(),

              const SizedBox(height: 15),

              certificateNumberField(),

              const SizedBox(height: 15),

              uploadCertificateBox(),

              const SizedBox(height: 15),

              locationFormField(),

              const SizedBox(height: 30),

              passwordFormField(),

              const SizedBox(height: 15),

              confirmPasswordFormField(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () async {
                    if (_formKeyGuide.currentState!.validate()) {
                      _formKeyGuide.currentState?.save();
                      Guide guide = Guide(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        gender: gender,
                        dob: dob,
                        phoneNumber: phoneNumber,
                        guideCertificateType: guideCertificateType,
                        certificateNumber: certificateNumber,
                        uploadedCertificatePath: uploadedCertificatePath,
                        nic: nic,
                        location: location,
                        address: address,
                        country: country,
                        type: type,
                        rating: rating,
                        availability: availability,
                      );
                      // save to database after validation
                      try {
                        var uri = Uri.parse(
                          "${AppConfig.SERVER_URL}/api/users/register-guide",
                        );

                        var request = http.MultipartRequest("POST", uri);

                        // Add JSON fields
                        guide.toMap().forEach((key, value) {
                          if (value != null) {
                            request.fields[key] = value.toString();
                          }
                        });

                        // Add certificate file (web + mobile)
                        if (uploadedCertificateBytes != null) {
                          request.files.add(
                            http.MultipartFile.fromBytes(
                              "certificate",
                              uploadedCertificateBytes!,
                              filename: hint,
                            ),
                          );
                        } else if (uploadedCertificatePath != null) {
                          request.files.add(
                            await http.MultipartFile.fromPath(
                              "certificate",
                              uploadedCertificatePath!.path,
                            ),
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Connecting... "),
                                CircularProgressIndicator.adaptive(),
                              ],
                            ),
                            backgroundColor: const Color.fromARGB(
                              180,
                              76,
                              175,
                              79,
                            ),
                          ),
                        );

                        var response = await request.send();
                        var resp = await http.Response.fromStream(response);
                        final data = jsonDecode(resp.body);

                        if (response.statusCode == 201) {
                          print("Guide registered successfully");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(data['msg']),
                              backgroundColor: const Color.fromARGB(
                                180,
                                76,
                                175,
                                79,
                              ),
                            ),
                          );
                          Navigator.pop(context, LoginSetup());
                        } else {
                          print("Error: ${data['msg']}");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error: Already registered with this email. Please try a different email.",
                              ),
                              backgroundColor: const Color.fromARGB(
                                180,
                                244,
                                67,
                                54,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error while connecting to server...',
                            ),
                            backgroundColor: const Color.fromARGB(
                              180,
                              244,
                              67,
                              54,
                            ),
                          ),
                        );
                      }
                    }
                  },

                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: "By registering, you agree to Traamp's ",
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green),
      ),
    );
  }
}
