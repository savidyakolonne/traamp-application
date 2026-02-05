import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main_tab_view.dart';
import 'signup.dart';

class LoginSetup extends StatefulWidget {
  const LoginSetup({super.key});

  @override
  State<LoginSetup> createState() => _LoginSetupState();
}

class _LoginSetupState extends State<LoginSetup> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  bool _obscureState = true;
  late Map<String, dynamic> userData;

  Widget showAndHidePasswordIcon() {
    return IconButton(
      icon: Icon(
        _obscureState
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
      onPressed: () {
        setState(() {
          _obscureState = !_obscureState;
        });
      },
    );
  }

  Future<void> loginEmail() async {
    String email = emailCtrl.text.trim().toLowerCase();
    String password = passCtrl.text;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final idToken = await userCredential.user!.getIdToken();
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/users/loginWithEmail"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      final data = await jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Connecting... ", style: TextStyle(color: Colors.white)),
              CircularProgressIndicator.adaptive(backgroundColor: Colors.green),
            ],
          ),
          backgroundColor: const Color.fromARGB(123, 0, 0, 0),
        ),
      );

      if (response.statusCode == 404 || response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 200) {
        userData = data['profile'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: const Color.fromARGB(125, 76, 175, 79),
          ),
        );
        // routing
        if (userData['type'] == "tourist") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainTabView(true);
              },
            ),
          );
        } else if (userData['type'] == "guide") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainTabView(false);
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something wrong...'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while connecting to server...'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 100, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUp()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passCtrl,
                obscureText: _obscureState,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: showAndHidePasswordIcon(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    loginEmail();
                  },
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Continue with Google"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
