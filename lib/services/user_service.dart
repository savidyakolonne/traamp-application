import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String?> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return doc.data()?['type'] as String?;
  }

  // 2. Get full user data
  static Future<Map<String, dynamic>?> getUserDoc(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  // 3. Create a Tourist document
  static Future<void> createTourist({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String dob,
    required String country,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'dob': dob,
      'country': country,
      'type': 'tourist',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. Create a Guide document
  static Future<void> createGuide({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String nic,
    required String location,
    required String address,
    required String country,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'nic': nic,
      'location': location,
      'address': address,
      'country': country,
      'type': 'guide',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
