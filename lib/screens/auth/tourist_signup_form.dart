import 'package:flutter/material.dart';
import 'countryNames.dart';

class TouristSignupForm extends StatefulWidget {
  const TouristSignupForm({super.key});

  @override
  State<TouristSignupForm> createState() => _TouristSignupFormState();
}

class _TouristSignupFormState extends State<TouristSignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  final _countries = Countries.countryNames;
  final List<String> _genders = ["Male", "Female"];

  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? password;
  String? cPassword;
  String? selectedCountry;
  String? dob;

  Widget firstNameFormField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "First Name"),
      //validation
      validator: (text) {
        if (text!.isEmpty) {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      //save global variable
      onSaved: (text) {
        firstName = text?.toLowerCase();
      },
    );
  }

  Widget lastNameFormField() {
    return TextFormField(
      decoration: InputDecoration(hintText: "Last Name"),
      //validation
      validator: (text) {
        if (text!.isEmpty) {
          return "Name cannot be empty";
        }
        if (text.length <= 2) {
          return "Must be more than 2 charactors";
        }
        return null;
      },
      //save global variable
      onSaved: (text) {
        lastName = text?.toLowerCase();
      },
    );
  }

  Widget emailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: "Email Address"),
      validator: (mail) {
        return null;
      },
      onSaved: (mail) {
        email = mail?.toLowerCase();
      },
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(hintText: "Password"),
      validator: (pass) {
        return null;
      },
      onSaved: (pass) {
        password = pass;
      },
    );
  }

  Widget confirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(hintText: "Confirm Password"),
      validator: (cPass) {
        return null;
      },
      onSaved: (cPass) {
        cPassword = cPass;
      },
    );
  }

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
          gender = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return "Please select your gender";
        }
        return null;
      },
    );
  }

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
          selectedCountry = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return "Please select a country";
        }
        return null;
      },
    );
  }

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
        if (value == "") {
          return "Please select your DOB";
        }
        return null;
      },
      onSaved: (date) {
        dob = date;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Traamp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
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
                        SizedBox(height: 15.0),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        print(firstName);
                        print(lastName);
                        print(email);
                        print(password);
                        print(cPassword);
                        print(selectedCountry);
                        print(gender);
                        print(dob);
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
