import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:traamp_frontend/app_config.dart';
import '../tourist/tourist_edit_profile.dart';
import '../tourist/saved_guides_screen.dart';
import '../../services/saved_guides_service.dart';
import 'guide_public_view_screen.dart';

// ignore: must_be_immutable
class TouristProfileScreen extends StatefulWidget {
  final String idToken;
  Map<String, dynamic> userData;

  TouristProfileScreen(this.idToken, this.userData, {super.key});

  @override
  State<TouristProfileScreen> createState() => _TouristProfileScreenState();
}

class _TouristProfileScreenState extends State<TouristProfileScreen> {
  bool _isLoading = false;
  String profilePicture = "";
  List<Map<String, dynamic>> _savedGuides = [];
  bool _isLoadingSavedGuides = false;
  final SavedGuidesService _savedGuidesService = SavedGuidesService();

  Future<void> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response = await http.post(
          Uri.parse("${AppConfig.SERVER_URL}/api/users/get-user-data"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"idToken": widget.idToken}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          setState(() {
            widget.userData = data['data'];
            profilePicture = widget.userData['profilePicture'] ?? '';
          });
          print(data['msg']);
        } else if (response.statusCode == 401) {
          print(data['msg']);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _loadSavedGuides() async {
    setState(() => _isLoadingSavedGuides = true);
    try {
      final guides = await _savedGuidesService.getSavedGuides();
      setState(() => _savedGuides = guides);
    } catch (e) {
      print('Error loading saved guides: $e');
    } finally {
      setState(() => _isLoadingSavedGuides = false);
    }
  }

  Future<void> _refreshAll() async {
    await _getUserData();
    await _loadSavedGuides();
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadSavedGuides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            print('Back button tapped');
          },
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Header ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: profilePicture.isNotEmpty
                                ? Image.network(
                                    profilePicture,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildInitialAvatar(),
                                  )
                                : _buildInitialAvatar(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.userData['firstName'] ?? ''} ${widget.userData['lastName'] ?? ''}'
                                  .trim(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Traamp Explorer',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Edit Profile Button ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditTouristProfile(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Tourist Details ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // email
                        if ((widget.userData['email'] ?? '').isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: widget.userData['email'],
                          ),
                        // phone
                        if ((widget.userData['phoneNumber'] ?? '').isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: widget.userData['phoneNumber'],
                          ),
                        // country
                        if ((widget.userData['country'] ?? '').isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.flag_outlined,
                            label: 'Country',
                            value: widget.userData['country'],
                          ),
                        // gender
                        if ((widget.userData['gender'] ?? '').isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.person_outline,
                            label: 'Gender',
                            value: widget.userData['gender'],
                          ),
                        // date of birth
                        if ((widget.userData['dob'] ?? '').isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.cake_outlined,
                            label: 'Date of Birth',
                            value: widget.userData['dob'].toString().split(
                              'T',
                            )[0],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Saved Guides ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saved Guides',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SavedGuidesScreen(
                                    widget.userData['uid'].toString(),
                                  ),
                                ),
                              );
                              _loadSavedGuides();
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_isLoadingSavedGuides)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        )
                      else if (_savedGuides.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No saved guides yet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...List.generate(_savedGuides.length, (index) {
                          final guide = _savedGuides[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildGuideListTile(guide),
                          );
                        }),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Detail row helper ──────────────────────────────────────
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Initial avatar fallback ────────────────────────────────
  Widget _buildInitialAvatar() {
    final name = widget.userData['firstName']?.toString() ?? '';
    final initial = name.isNotEmpty ? name.substring(0, 1) : '?';
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGuideListTile(Map<String, dynamic> guide) {
    final String firstName = guide['firstName'] ?? 'Unknown';
    final String lastName = guide['lastName'] ?? '';
    final String rating;
    if (guide['rating'].runtimeType == String) {
      rating = guide['rating'];
    } else {
      rating = guide['rating'].toStringAsFixed(1);
    }
    final String guideUid = guide['uid'] ?? '';
    final String? profilePic = guide['profilePicture'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (guideUid.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuidePublicViewScreen(
                  guideId: guideUid,
                  uid: widget.userData['uid'].toString(),
                ),
              ),
            ).then((_) => _loadSavedGuides());
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: profilePic != null && profilePic.isNotEmpty
                    ? NetworkImage(profilePic)
                    : null,
                child: profilePic == null || profilePic.isEmpty
                    ? Icon(Icons.person, size: 24, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      guide['location'] ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
