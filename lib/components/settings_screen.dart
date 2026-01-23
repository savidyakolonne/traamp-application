import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import '../screens/auth/login_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool loggedOut = false;

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User logout successfully");
      loggedOut = true;
    } on FirebaseAuthException catch (e) {
      print("Error signing out: $e");
      loggedOut = false;
    } catch (e) {
      print("An unexpected error occurred: $e");
      loggedOut = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // object for bottom navigation, isTourist = true
    BottomNav nav = BottomNav(true);

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
      bottomNavigationBar: nav.bottom_nav(context),
    );
  }
}
