// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../services/user_service.dart';
// import '../guide/guide_dashboard.dart';

// class RoleRouter {
//   static Future<void> goToDashboard(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final role = await UserService.getRole(user.uid);

//     if (!context.mounted) return;

//     if (role == 'guide') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         //MaterialPageRoute(builder: (_) => const GuideDashboard()),
//         //(_) => false,
//       );
//     } else if (role == 'tourist') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const TouristDashboard()),
//         (_) => false,
//       );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Account profile not found. Please sign up.'),
//           ),
//         );
//       }
//     }
//   }