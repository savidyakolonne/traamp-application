// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../screens/auth/login_screen.dart';

class Settings extends StatefulWidget {
  final bool isTourist;
  const Settings(this.isTourist);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool loggedOut = false;

  Future<void> signOutUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken(true);
        if (idToken != null) {
          final response = await http.post(
            Uri.parse("${AppConfig.SERVER_URL}/api/users/user-logout"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"idToken": idToken}),
          );
          final data = jsonDecode(response.body);
          if (response.statusCode == 400) {
            print(data['msg']);
            loggedOut = false;
          }
          if (response.statusCode == 200) {
            print(data['msg']);
            await FirebaseAuth.instance.signOut();
            loggedOut = true;
          }
        } else {
          print("Something wrong during creating instance from firebase");
          loggedOut = false;
        }
      }
    } catch (e) {
      print(e.toString());
      loggedOut = false;
    }
  }

  Widget buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isLogout ? Colors.red : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Settings",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // Profile
              buildSettingsTile(
                icon: Icons.person_outline,
                iconColor: Colors.green,
                bgColor: Colors.green.withOpacity(0.15),
                title: "Profile",
                subtitle: "View your profile",
                onTap: () {},
              ),

              // Theme
              buildSettingsTile(
                icon: Icons.nightlight_round,
                iconColor: Colors.blue,
                bgColor: Colors.blue.withOpacity(0.15),
                title: "Theme",
                subtitle: "Change your theme",
                onTap: () {},
              ),

              // Privacy
              buildSettingsTile(
                icon: Icons.lock_outline,
                iconColor: Colors.orange,
                bgColor: Colors.orange.withOpacity(0.15),
                title: "Privacy",
                subtitle: "Secure your account with privacy",
                onTap: () {},
              ),

              // Help & Support
              buildSettingsTile(
                icon: Icons.favorite_border,
                iconColor: Colors.purple,
                bgColor: Colors.purple.withOpacity(0.15),
                title: "Help and Support",
                subtitle: "Get help from our team",
                onTap: () {},
              ),

              // About
              buildSettingsTile(
                icon: Icons.info_outline,
                iconColor: Colors.teal,
                bgColor: Colors.teal.withOpacity(0.15),
                title: "About",
                subtitle: "Version info, terms & conditions, privacy policy",
                onTap: () {},
              ),

              // Logout
              buildSettingsTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                bgColor: Colors.red.withOpacity(0.15),
                title: "Logout",
                subtitle: "End your current session",
                isLogout: true,
                onTap: () async {
                  await signOutUser();
                  if (loggedOut) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logged out successfully."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error while logging out"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(automaticallyImplyLeading: false, title: Text("Settings")),
  //     body: ListView(
  //       children: [
  //         ListTile(
  //           leading: Icon(Icons.account_circle_outlined, size: 30),
  //           title: Text("Profile"),
  //           subtitle: Text("View your profile"),            
  //           onTap: () {},
  //         ),
  //         Divider(),
  //         ListTile(
  //           leading: Icon(Icons.mode_night_outlined, size: 30),
  //           title: Text("Theme"),
  //           subtitle: Text("Change your theme"),            
  //           onTap: () {},
  //         ),
  //         Divider(),
  //         ListTile(
  //           leading: Icon(Icons.lock_outline_rounded, size: 30),
  //           title: Text("Privacy"),
  //           subtitle: Text("Secure your account with privacy"),
  //           onTap: () {},
  //         ),
  //         Divider(),
  //         ListTile(
  //           leading: Icon(Icons.volunteer_activism_outlined, size: 30),
  //           title: Text("Help and Support"),
  //           subtitle: Text("Get help from our team"),
  //           onTap: () {},
  //         ),
  //         Divider(),
  //         ListTile(
  //           leading: Icon(Icons.error_outline_rounded, size: 30),
  //           title: Text("About"),
  //           subtitle: Text("Version info, terms & conditions, privacy policy"),
  //           onTap: () {},
  //         ),
  //         Divider(),
  //         ListTile(
  //           leading: Icon(Icons.logout, size: 30),
  //           title: Text("Logout"),
  //           onTap: () async {
  //             await signOutUser();
  //             if (loggedOut) {
  //               Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(builder: (context) => LoginScreen()),
  //               );
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("Logged out successfully."),
  //                   backgroundColor: Colors.green,
  //                 ),
  //               );
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("Error while logging out"),
  //                   backgroundColor: Colors.red,
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

