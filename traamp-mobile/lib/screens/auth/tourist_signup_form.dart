import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traamp_frontend/models/tourist.dart';
import '../../list-data.dart';
import 'verify_email_screen.dart';

class TouristSignupForm extends StatefulWidget {
  const TouristSignupForm({super.key});
  @override
  State<TouristSignupForm> createState() => _TouristSignupFormState();
}

class _TouristSignupFormState extends State<TouristSignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  final Color primaryColor = Colors.lightGreen;

  final List<String> _countries = ListData.countryNames;
  final List<String> _genders = ListData.gender;

  String firstName = "";
  String lastName = "";
  String gender = "";
  String email = "";
  String rowPassword = "";
  String password = "";
  String selectedCountry = "";
  String dob = "";
  String type = "tourist";

  Widget firstNameFormField() {
    return TextFormField(
      decoration: fieldStyle("First Name"),
      validator: (text) {
        if (text == null || text == "") {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      onSaved: (text) {
        firstName = text!.trim();
      },
      showCursor: true,
    );
  }

  Widget lastNameFormField() {
    return TextFormField(
      decoration: fieldStyle("Last Name"),
      validator: (text) {
        if (text == null || text == "") {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      onSaved: (text) {
        lastName = text!.trim();
      },
    );
  }

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

  Widget genderFormField() {
    return DropdownButtonFormField<String>(
      decoration: fieldStyle("Gender"),
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

  Widget dobFormField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: fieldStyle(
        "Date of Birth",
      ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
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

  Future<void> _registerTourist() async {
    if (!_formKey.currentState!.validate()) return;

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
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.sendEmailVerification();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            endpoint: "/api/users/register-tourist",
            profileData: tourist.toMap()
              ..remove("email")
              ..remove("password"),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Registration failed"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while connecting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

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
        title: const Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
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
                  const SizedBox(height: 20.0),
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
                      onPressed: _registerTourist,
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
