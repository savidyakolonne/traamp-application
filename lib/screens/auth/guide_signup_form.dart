import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../listData.dart';
import '../../services/guide.dart';
import 'login_setup.dart';

class GuideSignupForm extends StatefulWidget {
  const GuideSignupForm({super.key});
  @override
  State<GuideSignupForm> createState() => _GuideSignupFormState();
}

class _GuideSignupFormState extends State<GuideSignupForm> {
  // instance of firebase - firestore
  final db = FirebaseFirestore.instance;
  // global key object for Form
  final GlobalKey<FormState> _formKeyGuide = GlobalKey<FormState>();
  // DOB text editing controller
  final TextEditingController _dobController = TextEditingController();
  // creating object for fireStore users collection
  late final users = db.collection("users");

  final List<String> _genders = ListData.gender;
  final List<String> _certificateType = ListData.guideCertificates;
  final List<String> _districts = ListData.districts;

  // global variables to store data coming from form
  late final userId = users.doc().id;
  String firstName = "";
  String lastName = "";
  String email = "";
  String rowPassword = "";
  String password = "";
  String gender = "";
  String dob = "";
  String phoneNumber = "";
  String? guideCertifateType;
  String? certificateNumber;
  String nic = "";
  String location = "";
  String address = "";
  String country = "Sri Lanka";
  String type = "guide";
  double rating = 0.0;

  // first name
  Widget firstNameFormField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "First Name"),
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
      decoration: InputDecoration(hintText: "Last Name"),
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
      decoration: InputDecoration(hintText: "Email Address"),
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
      decoration: InputDecoration(hintText: "Password"),
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
      decoration: InputDecoration(hintText: "Confirm Password"),
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
      onSaved: (cPass) {},
    );
  }

  // Gender
  Widget genderFormField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select Gender",
        border: OutlineInputBorder(),
      ),
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
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
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
      decoration: InputDecoration(hintText: "Phone Number (ex: +94771234567)"),
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
      decoration: const InputDecoration(
        labelText: "Select Certificate Type",
        border: OutlineInputBorder(),
      ),
      items: _certificateType.map((certificateType) {
        return DropdownMenuItem(
          value: certificateType,
          child: Text(certificateType),
        );
      }).toList(),
      onChanged: (certificate) {
        setState(() {
          guideCertifateType = certificate;
        });
      },
      validator: (certificate) {
        return null;
      },
    );
  }

  //NIC
  Widget NICFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "NIC Number (123214255v/123456789123)",
      ),
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
      decoration: InputDecoration(hintText: "Certificate Number"),
      //validation
      validator: (number) {
        return null;
      },
      //save global variable
      onSaved: (number) {
        if (number == "") {
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
      decoration: const InputDecoration(
        labelText: "Select Location",
        border: OutlineInputBorder(),
      ),
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

  //Address
  Widget addressFormField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "Address"),
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
      appBar: AppBar(
        title: const Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKeyGuide,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png'),
                  SizedBox(height: 20.0),
                  Text(
                    "Please Register as a Guide",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Column(
                      children: [
                        // Form elements here
                        firstNameFormField(),
                        lastNameFormField(),
                        emailFormField(),
                        passwordFormField(),
                        confirmPasswordFormField(),
                        SizedBox(height: 15.0), // to reserve some space
                        genderFormField(),
                        SizedBox(height: 15.0),
                        dobFormField(),
                        SizedBox(height: 15.0),
                        phoneNumberFormField(),
                        NICFormField(),
                        SizedBox(height: 15.0),
                        certificateTypeFormField(),
                        SizedBox(height: 15.0),
                        certificateNumberField(),
                        addressFormField(),
                        SizedBox(height: 15.0),
                        locationFormField(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  OutlinedButton(
                    onPressed: () async {
                      // if validated save to global variables
                      if (_formKeyGuide.currentState!.validate()) {
                        _formKeyGuide.currentState?.save();
                        Guide guide = Guide(
                          uid: userId,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          gender: gender,
                          dob: dob,
                          phoneNumber: phoneNumber,
                          guideCertifateType: guideCertifateType,
                          certificateNumber: certificateNumber,
                          nic: nic,
                          location: location,
                          address: address,
                          country: country,
                          type: type,
                          rating: rating,
                        );
                        // save to database after validation
                        try {
                          // email and password authentication
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          // add data to users collection
                          await users
                              .doc(credential.user!.uid)
                              .set(guide.toMap());

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully Created.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // return back to signin page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginSetup();
                              },
                            ),
                          );
                        } on FirebaseException catch (e) {
                          debugPrint(
                            'Firestore error: ${e.code} - ${e.message}',
                          );
                          print(e);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed to create user. Please try again. Try to use another email.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
