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
    // TODO: implement build
    throw UnimplementedError();
  }
}


