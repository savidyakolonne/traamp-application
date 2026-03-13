// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class SettingsPrivacy extends StatelessWidget {
  const SettingsPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
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

              Column(
                children: [
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
                        deleteProfile(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(height: 20),
                ],
              ),

              const Divider(height: 30),

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
            ],
          ),
        ),
      ),
    );
  }
}

void deleteProfile(BuildContext context) {}