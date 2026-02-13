import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../list-data.dart';

class EditGuideProfile extends StatefulWidget {
  const EditGuideProfile({super.key});

  @override
  State<EditGuideProfile> createState() => _EditGuideProfileState();
}

class _EditGuideProfileState extends State<EditGuideProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;

  // Read-only Controllers for Credentials
  late TextEditingController _nicController;
  late TextEditingController _certTypeController;
  late TextEditingController _certNumController;

  // Dialog Controllers
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedLocation;
  String? _selectedGender;
  String? _profileImageUrl;
  DateTime? _selectedDate;
  bool _isLoading = true;

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _nicController = TextEditingController();
    _certTypeController = TextEditingController();
    _certNumController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nicController.dispose();
    _certTypeController.dispose();
    _certNumController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _db.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _firstNameController.text = data['firstName'] ?? "";
            _lastNameController.text = data['lastName'] ?? "";
            _emailController.text = data['email'] ?? "";
            _phoneController.text = data['phoneNumber'] ?? "";
            _addressController.text = data['address'] ?? "";
            _selectedLocation = data['location'];
            _selectedGender = data['gender'];
            _profileImageUrl = data['profilePicture'];

            // Read-only fields
            _nicController.text = data['nic'] ?? "";
            _certTypeController.text = data['certificateType'] ?? "";
            _certNumController.text = data['certificateNumber'] ?? "";

            if (data['dob'] != null && data['dob'].toString().isNotEmpty) {
              final dobString = data['dob'].toString();

              DateTime? parsedDate;

              // Try ISO format first (yyyy-MM-dd)
              parsedDate = DateTime.tryParse(dobString);

              // If ISO fails, try dd/MM/yyyy
              if (parsedDate == null && dobString.contains('/')) {
                final parts = dobString.split('/');
                if (parts.length == 3) {
                  parsedDate = DateTime(
                    int.parse(parts[2]), // year
                    int.parse(parts[1]), // month
                    int.parse(parts[0]), // day
                  );
                }
              }

              if (parsedDate != null) {
                _selectedDate = parsedDate;
                _dobController.text =
                    "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
              }
            }

            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.lightGreen)),
    );
  }
}
