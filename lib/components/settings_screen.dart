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
            onTap: () {},
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
