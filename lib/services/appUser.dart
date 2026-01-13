import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String dob;
  final String type;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dob,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'dob': dob,
      'createdAt': DateTime.now(),
    };
  }
}
