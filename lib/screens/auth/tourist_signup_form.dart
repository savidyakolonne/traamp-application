import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/services/tourist.dart';
import '../../list-data.dart';
import 'login_setup.dart';

class TouristSignupForm extends StatefulWidget {
  const TouristSignupForm({super.key});
  @override
  State<TouristSignupForm> createState() => _TouristSignupFormState();
}

class _TouristSignupFormState extends State<TouristSignupForm> {
  // global key object for Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // DOB text editing controller
  final TextEditingController _dobController = TextEditingController();

  // array for country names
  final List<String> _countries = ListData.countryNames;
  final List<String> _genders = ListData.gender; // for gender dropdown menu

  // global variables to store data coming from form
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
                          password: password,
                          gender: gender,
                          dob: dob,
                          country: selectedCountry,
                          type: type,
                        );
                        try {
                          final response = await http.post(
                            Uri.parse(
                              "http://10.0.2.2:3000/api/users/register-tourist",
                            ),
                            headers: {
                              "Content-Type": "application/json",
                            }, //  tells the server the body is JSON
                            body: jsonEncode(tourist.toMap()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Connecting... "),
                                  CircularProgressIndicator.adaptive(),
                                ],
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          final data = jsonDecode(response.body);
                          print(data);
                          if (response.statusCode == 201) {
                            Navigator.pop(context, LoginSetup());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${data['msg']}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${data['msg']} : status code = ${response.statusCode}',
                                ),
                                backgroundColor: Colors.red,
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
