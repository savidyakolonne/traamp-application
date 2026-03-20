import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traamp_frontend/app_config.dart';
import '../screens/auth/login_screen.dart';

// ignore: must_be_immutable
class SettingsPrivacy extends StatelessWidget {
  final String _uid;
  final bool _isTourist;
  const SettingsPrivacy(this._uid, this._isTourist, {super.key});

  Future<void> deleteProfile() async {
    try {
      final response = await http.delete(
        Uri.parse("${AppConfig.SERVER_URL}/api/users/delete-user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": _uid, "isTourist": _isTourist}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(data['msg']);
      } else {
        print(data['msg']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(39, 0, 0, 0).withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 5,
              ),
            ],
          ),

          child: Column(
            spacing: 10,
            children: [
              /// Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EDE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF6CD21F),
                  size: 34,
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Scrollable Text
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    "TRAMMP respects your privacy and is committed to protecting your personal information. "
                    "When you use the application, we may collect basic details such as your name, email address, "
                    "profile information, and location data to provide personalized travel services, connect tourists "
                    "with guides, and improve the overall user experience.\n\n"
                    "This information is used only to support the functionality of the app, including navigation, "
                    "recommendations, and communication features. TRAMMP implements appropriate security measures "
                    "to protect your data from unauthorized access, and we do not share personal information with "
                    "unauthorized parties.\n\n"
                    "Some features of the app may rely on trusted third-party services such as Firebase and Google Maps, "
                    "which process data according to their own privacy policies. By using the TRAMMP application, you "
                    "agree to the collection and use of information as described in this privacy policy.",

                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              /// OK Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ED321),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),

              /// Delete Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    "Delete Profile",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: SizedBox(
                            width: 250,
                            height: 180,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(28, 0, 0, 0),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Are you sure you want to delete your profile?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        71,
                                        71,
                                        71,
                                      ),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6CD21F),
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            border: BoxBorder.all(
                                              color: const Color.fromARGB(
                                                43,
                                                0,
                                                0,
                                                0,
                                              ),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Close",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () async {
                                          await deleteProfile();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return LoginScreen();
                                              },
                                            ),
                                          );
                                        },
                                        icon: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            border: BoxBorder.all(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Delete",

                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
