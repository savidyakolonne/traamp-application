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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Edit Profile")));
  }
}
