import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:traamp_frontend/app_config.dart';
import '../tourist/tourist_edit_profile.dart';
import '../tourist/saved_guides_screen.dart';
import '../../services/saved_guides_service.dart';
import '../profile/guide_public_view_screen.dart';

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

        final data = await jsonDecode(response.body);

        if (response.statusCode == 200) {
          setState(() {
            widget.userData = data['data'];
            if (widget.userData['profilePicture'] != null) {
              profilePicture = widget.userData['profilePicture'];
            }
          });
          print(data['msg']);
        } else if (response.statusCode == 401) {
          print(data['msg']);
        }
      } else {
        print("Something wrong during creating instance from firebase");
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Section
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
                          backgroundImage: (profilePicture.isNotEmpty)
                              ? NetworkImage(profilePicture)
                              : (widget.userData['gender'] == "Female"
                                  ? const AssetImage(
                                      'assets/images/avatar-female.avif',
                                    )
                                  : const AssetImage(
                                      'assets/images/avatar-male.avif',
                                    )),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.userData['firstName']} ${widget.userData['lastName']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Traamp Explorer since 2023',
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

                // Edit Profile Button
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
                const SizedBox(height: 32),

                // Saved Guides Section
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
                                  builder: (context) =>
                                      const SavedGuidesScreen(),
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

                      // Loading state
                      if (_isLoadingSavedGuides)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        )

                      // Empty state
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

                      // Real saved guides from backend
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

  Widget _buildGuideListTile(Map<String, dynamic> guide) {
    final String firstName = guide['firstName'] ?? 'Unknown';
    final String lastName = guide['lastName'] ?? '';
    final double rating = double.tryParse(guide['rating']?.toString() ?? '0') ?? 0.0;
    final String guideUid = guide['uid'] ?? '';
    final String? profilePicture = guide['profilePicture'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (guideUid.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuidePublicViewScreen(guideId: guideUid),
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
                backgroundImage: profilePicture != null && profilePicture.isNotEmpty
                    ? NetworkImage(profilePicture)
                    : null,
                child: profilePicture == null || profilePicture.isEmpty
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
                    rating.toStringAsFixed(1),
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