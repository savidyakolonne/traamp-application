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

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;

  // Dialog Controllers
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedCountry;
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

    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
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
            _selectedCountry = data['country'];
            _selectedGender = data['gender'];
            _profileImageUrl = data['profilePicture'];
            _isLoading = false;

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
        debugPrint("Error loading user data: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  // image picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // upload image to firebase storage
  Future<String?> _uploadImage(String uid) async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint("CURRENT USER UID: ${user?.uid}");
    if (_pickedImage == null) return _profileImageUrl;

    try {
      Reference ref = _storage.ref().child('profile_pictures').child(uid);
      UploadTask uploadTask = ref.putFile(_pickedImage!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Image Upload Error: $e");
      return null;
    }
  }

  Future<void> _saveAllChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Upload image
      String? imageUrl = await _uploadImage(user.uid);

      // UPDATE UI immediately
      if (imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
      // Save data to Firestore
      await _db.collection('users').doc(user.uid).update({
        'profilePicture': imageUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.lightGreen),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveAllChanges,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[200],

                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (_profileImageUrl != null &&
                                        _profileImageUrl!.isNotEmpty
                                    ? NetworkImage(_profileImageUrl!)
                                    : const AssetImage(
                                        'assets/images/user_placeholder.png',
                                      ))
                                as ImageProvider,
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text(
                        "Change Photo",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
