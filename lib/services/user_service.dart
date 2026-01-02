// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserService {
//   static final _db = FirebaseFirestore.instance;

//   static Future<Map<String, dynamic>?> getUserDoc(String uid) async {
//     final doc = await _db.collection('users').doc(uid).get();
//     if (!doc.exists) return null;
//     return doc.data();
//   }

//   static Future<void> createTourist({
//     required String uid,
//     required String name,
//     required String email,
//     required String phone,
//   }) async {
//     await _db.collection('users').doc(uid).set({
//       'role': 'tourist',
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> createGuide({
//     required String uid,
//     required String name,
//     required String email,
//     required String phone,
//     required String guideType,
//     required List<String> operatingAreas,
//   }) async {
//     await _db.collection('users').doc(uid).set({
//       'role': 'guide',
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//     await _db.collection('guides').doc(uid).set({
//       'verified': false,
//       'verificationStatus': 'not_submitted',
//       'guideType': guideType, // chauffeur / national / siteGuide
//       'operatingAreas': operatingAreas,
//       'createdAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final _db = FirebaseFirestore.instance;

  static Future<String?> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['role'] as String?;
  }
}
