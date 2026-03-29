import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';
import '../../components/main_tab_view.dart';
import '../../services/login_state.dart';
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
  late String idToken;

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

  Future<void> _loginEmail() async {
    String email = emailCtrl.text.trim().toLowerCase();
    String password = passCtrl.text;

    setState(() {
      loading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || !user.emailVerified) {
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before logging in.'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          loading = false;
        });
        return;
      }

      String? idToken;
      String? token = await user.getIdToken(true);
      setState(() {
        idToken = token;
      });

      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/users/loginWithEmail"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 404 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 200) {
        LoginState.setLoggedIn(true);
        userData = data['profile'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: const Color.fromARGB(125, 76, 175, 79),
          ),
        );

        if (userData['type'] == "tourist") {
          LoginState.setUserType('tourist');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainTabView(true, idToken!, userData);
              },
            ),
          );
        } else if (userData['type'] == "guide") {
          LoginState.setUserType('guide');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainTabView(false, idToken!, userData);
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User type is invalid...'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect username or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
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
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
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
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passCtrl,
                obscureText: _obscureState,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: showAndHidePasswordIcon(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _loginEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 247, 250, 247),
                    foregroundColor: Colors.green,
                  ),
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
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 247, 250, 247),
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
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
