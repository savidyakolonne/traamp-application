import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../list-data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:traamp_frontend/app_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class EditTouristProfile extends StatefulWidget {
  const EditTouristProfile({super.key});

  @override
  State<EditTouristProfile> createState() => _EditTouristProfileState();
}

class _EditTouristProfileState extends State<EditTouristProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
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
  Uint8List? _webImage;

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
    if (user == null) return;

    try {
      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/users/get-user-data"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        final data = resData["data"];

        setState(() {
          _firstNameController.text = data['firstName'] ?? "";
          _lastNameController.text = data['lastName'] ?? "";
          _emailController.text = data['email'] ?? "";
          _selectedCountry = data['country'];
          _selectedGender = data['gender'];
          _profileImageUrl = data['profilePicture'];

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

  // image picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        _webImage = await image.readAsBytes();
        _pickedImage = null;
      } else {
        _pickedImage = File(image.path);
        _webImage = null;
      }

      setState(() {});
    }
  }

  // upload image to firebase storage
  Future<String?> _uploadImage(String uid) async {
    try {
      if (_webImage == null && _pickedImage == null) {
        return _profileImageUrl;
      }

      Reference ref = _storage.ref().child('profile_pictures').child(uid);

      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(_webImage!);
      } else {
        uploadTask = ref.putFile(_pickedImage!);
      }

      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Image Upload Error: $e");
      return _profileImageUrl;
    }
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _inputField("Current Password", _currentPasswordController, true),
            _inputField("New Password", _newPasswordController, true),
            const SizedBox(height: 10),
            _inputField("Confirm Password", _confirmPasswordController, true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            onPressed: () async {
              Navigator.pop(context);
              await _changePassword();
            },
            child: const Text("Change", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      _showSnack("Enter your current password", isError: true);
      return;
    }

    if (newPassword.length < 6) {
      _showSnack("Password must be at least 6 characters", isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnack("Passwords do not match", isError: true);
      return;
    }

    try {
      final user = _auth.currentUser!;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      _showSnack("Password updated successfully");

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showSnack("Current password is incorrect", isError: true);
      } else if (e.code == 'weak-password') {
        _showSnack("Password must be at least 6 characters", isError: true);
      } else {
        _showSnack(e.message ?? "Password update failed", isError: true);
      }
    } catch (e) {
      _showSnack("Something went wrong", isError: true);
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

      final idToken = await user.getIdToken();

      final response = await http.put(
        Uri.parse("${AppConfig.SERVER_URL}/api/users/update-tourist-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "country": _selectedCountry,
          "gender": _selectedGender,
          "dob": _selectedDate?.toIso8601String(),
          "profilePicture": imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update profile"),
            backgroundColor: Colors.red,
          ),
        );
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
                          : _webImage != null
                          ? MemoryImage(_webImage!)
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
                        "Upload Photo",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildLabel("First Name"),
              TextFormField(
                controller: _firstNameController,
                decoration: _inputDecoration("First Name"),
              ),
              const SizedBox(height: 15),
              _buildLabel("Last Name"),
              TextFormField(
                controller: _lastNameController,
                decoration: _inputDecoration("Last Name"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Country"),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: ListData.countryNames
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCountry = val),
                decoration: _inputDecoration("Select Country"),
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Birthday"),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: _inputDecoration("Birthday").copyWith(
                            suffixIcon: const Icon(Icons.calendar_month),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                                _dobController.text =
                                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildLabel("Gender"), _buildGenderToggle()],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "Account & Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildLabel("Email Address"),
              TextFormField(
                readOnly: true,
                controller: _emailController,
                decoration: _inputDecoration("Email"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Password"),
              TextFormField(
                readOnly: true,
                obscureText: true,
                initialValue: "••••••••",
                decoration: _inputDecoration("").copyWith(
                  suffixIcon: TextButton(
                    onPressed: _showPasswordChangeDialog,
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: _inputDecoration(label),
        ),
      ],
    );
  }

  Widget _buildGenderToggle() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: ["Male", "Female"]
            .map(
              (g) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedGender = g),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedGender == g
                          ? Colors.lightGreen.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      g,
                      style: TextStyle(
                        color: _selectedGender == g
                            ? Colors.lightGreen
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.lightGreen,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.lightGreen, width: 2),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}
