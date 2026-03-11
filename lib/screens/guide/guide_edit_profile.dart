import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../list-data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:traamp_frontend/app_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class EditGuideProfile extends StatefulWidget {
  const EditGuideProfile({super.key});

  @override
  State<EditGuideProfile> createState() => _EditGuideProfileState();
}

class _EditGuideProfileState extends State<EditGuideProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
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
  Uint8List? _webImage;
  List<String> _selectedLanguages = [];

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
          _phoneController.text = data['phoneNumber'] ?? "";
          _addressController.text = data['address'] ?? "";
          _selectedLocation = data['location'];
          _selectedGender = data['gender'];
          _profileImageUrl = data['profilePicture'];
          _selectedLanguages = List<String>.from(data['languages'] ?? []);

          // Read-only fields
          _nicController.text = data['nic'] ?? "";
          _certTypeController.text = data['guideCertificateType'] ?? "";
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
      debugPrint("Error loading guide data: $e");
      setState(() => _isLoading = false);
    }
  }

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

  Future<String?> _uploadImage(String uid) async {
    if (_webImage == null && _pickedImage == null) {
      return _profileImageUrl;
    }

    try {
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
            _dialogInputField(
              "Current Password",
              _currentPasswordController,
              true,
            ),
            _dialogInputField("New Password", _newPasswordController, true),
            const SizedBox(height: 10),
            _dialogInputField(
              "Confirm Password",
              _confirmPasswordController,
              true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            onPressed: () {
              Navigator.pop(context);
              _updatePasswordLogic();
            },
            child: const Text("Change", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePasswordLogic() async {
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();
    final currentPass = _currentPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty || currentPass.isEmpty) {
      _showSnackBar("All password fields are required", Colors.red);
      return;
    }

    if (newPass != confirmPass) {
      _showSnackBar("Passwords do not match!", Colors.red);
      return;
    }

    try {
      final user = _auth.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPass,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPass);

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      _showSnackBar("Password updated successfully!", Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showSnackBar("Current password is incorrect", Colors.red);
      } else if (e.code == 'weak-password') {
        _showSnackBar("Password must be at least 6 characters", Colors.red);
      } else {
        _showSnackBar(e.message ?? "Password update failed", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Something went wrong", Colors.red);
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

      final idToken = await user.getIdToken();

      final response = await http.put(
        Uri.parse("${AppConfig.SERVER_URL}/api/users/update-guide-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "phoneNumber": _phoneController.text.trim(),
          "address": _addressController.text.trim(),
          "location": _selectedLocation,
          "gender": _selectedGender,
          "dob": _selectedDate?.toIso8601String(),
          "languages": _selectedLanguages,
          "profilePicture": imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar("Profile updated successfully!", Colors.green);
        Navigator.pop(context);
      } else {
        _showSnackBar("Failed to update profile", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: ListData.languages.map((language) {
                final isSelected = _selectedLanguages.contains(language);

                return CheckboxListTile(
                  title: Text(language),
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedLanguages.add(language);
                      } else {
                        _selectedLanguages.remove(language);
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
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
                                _profileImageUrl!.isNotEmpty)
                          ? NetworkImage(_profileImageUrl!)
                          : const AssetImage(
                                  'assets/images/user_placeholder.png',
                                )
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

              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
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
                      children: [
                        _buildLabel("Gender"),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          items: ListData.gender
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                          decoration: _inputDecoration("Gender"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              _buildLabel("Location"),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: ListData.districts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(), //
                onChanged: (val) => setState(() => _selectedLocation = val),
                decoration: _inputDecoration("Select Location"),
              ),

              // Languages Section
              const SizedBox(height: 20),
              _buildLabel("Languages"),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._selectedLanguages.map((language) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9C8), // soft green background
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            language,
                            style: const TextStyle(
                              color: Color(0xFF2E7D32), // dark green text
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLanguages.remove(language);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Add Language Button
                  GestureDetector(
                    onTap: _showLanguageDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Add Language",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              _buildLabel("Address"),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: _inputDecoration("Address"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Phone Number"),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration("Phone Number"),
              ),

              const SizedBox(height: 30),
              const Text(
                "Account & Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildLabel("Email Address"),
              TextFormField(
                readOnly: true,
                controller: _emailController,
                decoration: _inputDecoration("Email"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Password"),
              TextFormField(
                obscureText: true,
                readOnly: true,
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
              Row(
                children: const [
                  Text(
                    "Professional Credentials",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 15),
              _buildLabel("National Identity Card (NIC)"),
              TextFormField(
                controller: _nicController,
                readOnly: true,
                decoration: _inputDecoration("NIC"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Type Of Certificate"),
              TextFormField(
                controller: _certTypeController,
                readOnly: true,
                decoration: _inputDecoration("Certificate Type"),
              ),

              const SizedBox(height: 15),
              _buildLabel("Certificate Number"),
              TextFormField(
                controller: _certNumController,
                readOnly: true,
                decoration: _inputDecoration("Certificate Number"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogInputField(
    String label,
    TextEditingController ctrl,
    bool obscure,
  ) {
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

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}
