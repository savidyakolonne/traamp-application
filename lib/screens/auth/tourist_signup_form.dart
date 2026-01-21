import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traamp_frontend/services/tourist.dart';
import '../../list_data.dart';
import 'login_setup.dart';

class TouristSignupForm extends StatefulWidget {
  const TouristSignupForm({super.key});
  @override
  State<TouristSignupForm> createState() => _TouristSignupFormState();
}

class _TouristSignupFormState extends State<TouristSignupForm> {
  // instance of firebase - firestore
  final db = FirebaseFirestore.instance;
  // global key object for Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // DOB text editing controller
  final TextEditingController _dobController = TextEditingController();

  // array for country names
  final List<String> _countries = ListData.countryNames;
  final List<String> _genders = ListData.gender; // for gender dropdown menu

  // creating object for fireStore users collection
  late final users = db.collection("users");

  // global variables to store data coming from form
  late String uid = users.doc().id;
  String firstName = "";
  String lastName = "";
  String gender = "";
  String email = "";
  String rowPassword = "";
  String password = "";
  String selectedCountry = "";
  String dob = "";
  String type = "tourist";

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
            return "Password do not match.";
          }
        } else {
          return "Please confirm your password";
        }

        return null;
      },
      onSaved: (cPass) {},
    );
  }

  // gender dropdown
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

  // country dropdown
  Widget selectCountryFormField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select Your Country",
        border: OutlineInputBorder(),
      ),
      items: _countries.map((country) {
        return DropdownMenuItem(value: country, child: Text(country));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCountry = value!;
        });
      },
      validator: (value) {
        if (value == null || value == "") {
          return "Please select a country";
        }
        return null;
      },
    );
  }

  // calender for DOB
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

  // build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png'),
                  SizedBox(height: 20.0),
                  Text(
                    "Please Register as a Tourist",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Column(
                      children: [
                        firstNameFormField(),
                        lastNameFormField(),
                        emailFormField(),
                        passwordFormField(),
                        confirmPasswordFormField(),
                        SizedBox(height: 15.0), // to reserve some space
                        selectCountryFormField(),
                        SizedBox(height: 15.0),
                        genderFormField(),
                        SizedBox(height: 15.0),
                        dobFormField(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  OutlinedButton(
                    onPressed: () async {
                      // if validated save to global variables
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();

                        final tourist = Tourist(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          gender: gender,
                          dob: dob,
                          country: selectedCountry,
                          uid: uid,
                          type: type,
                        );

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
                              .set(tourist.toMap());

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
