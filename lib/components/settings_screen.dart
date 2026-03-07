import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/guide_profile_screen.dart';
import '../screens/profile/tourist_profile_screen.dart';

class Settings extends StatefulWidget {
  final bool isTourist;
  final String idToken;
  const Settings(this.isTourist, this.idToken, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool loggedOut = false;

  Future<void> signOutUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response = await http.post(
          Uri.parse("${AppConfig.SERVER_URL}/api/users/user-logout"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"idToken": widget.idToken}),
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
      appBar: AppBar(automaticallyImplyLeading: false, title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle_outlined, size: 30),
            title: Text("Profile"),
            subtitle: Text("View your profile"),
            trailing: Icon(Icons.menu),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    if (widget.isTourist) {
                      return TouristProfileScreen();
                    } else {
                      return GuideProfileScreen();
                    }
                  },
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mode_night_outlined, size: 30),
            title: Text("Theme"),
            subtitle: Text("Change your theme"),
            trailing: Icon(Icons.menu),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock_outline_rounded, size: 30),
            title: Text("Privacy"),
            subtitle: Text("Secure your account with privacy"),
            trailing: Icon(Icons.menu),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.volunteer_activism_outlined, size: 30),
            title: Text("Help and Support"),
            subtitle: Text("Get help from our team"),
            trailing: Icon(Icons.menu),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.error_outline_rounded, size: 30),
            title: Text("About"),
            subtitle: Text("Version info, terms & conditions, privacy policy"),
            trailing: Icon(Icons.menu),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, size: 30),
            title: Text("Logout"),
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
        ],
      ),
    );
  }
}
