import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/models/tourist.dart';
import '../../app_config.dart';
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

  final Color primaryColor = Colors.lightGreen;

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

  // country dropdown
  Widget selectCountryFormField() {
    return DropdownButtonFormField<String>(
      decoration: fieldStyle("Select Your Country"),
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
      decoration: fieldStyle(
        "Date of Birth",
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

  // build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png', height: 90),
                  ),

                  SizedBox(height: 20.0),

                  const Center(
                    child: Text(
                      "Please Register as a Tourist",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

                  selectCountryFormField(),

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
                                "${AppConfig.SERVER_URL}/api/users/register-tourist",
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
                                backgroundColor: const Color.fromARGB(
                                  180,
                                  76,
                                  175,
                                  79,
                                ),
                              ),
                            );
                            final data = jsonDecode(response.body);
                            print(data);
                            if (response.statusCode == 201) {
                              Navigator.pop(context, LoginSetup());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${data['msg']}'),
                                  backgroundColor: const Color.fromARGB(
                                    180,
                                    76,
                                    175,
                                    79,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${data['msg']} : status code = ${response.statusCode}',
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

                      child: Text(
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
