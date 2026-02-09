import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../list-data.dart';
import '../../services/tourist.dart';

class EditTouristProfile extends StatefulWidget {
  const EditTouristProfile({super.key});

  @override
  State<EditTouristProfile> createState() => _EditTouristProfileState();
}

class _EditTouristProfileState extends State<EditTouristProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Edit Profile")));
  }
}
