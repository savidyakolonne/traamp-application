// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final auth = FirebaseAuth.instance;

//   static Future<UserCredential> loginEmail({
//     required String email,
//     required String password,
//   }) {
//     return FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email.trim(),
//       password: password.trim(),
//     );
//   }

  //   static Future<UserCredential> loginGoogle() async {
  // //final googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       throw Exception('Google sign-in cancelled');
  //     }

  //     final googleAuth = await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     return FirebaseAuth.instance.signInWithCredential(credential);
  //   }

  //   static Future<void> logout() async {
  //     //await GoogleSignIn().signOut();
  //     await FirebaseAuth.instance.signOut();
  //   }
// }