import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:traamp_frontend/app_config.dart';
import '../tourist/tourist_edit_profile.dart';
import '../tourist/saved_guides_screen.dart';
import '../../services/saved_guides_service.dart';

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
  int _savedGuidesCount = 0;
  final SavedGuidesService _savedGuidesService = SavedGuidesService();

  // get user data from DB
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
          
          // Fetch saved guides count after user data is loaded
          await _loadSavedGuidesCount();
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

  Future<void> _loadSavedGuidesCount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final guides = await _savedGuidesService.getSavedGuides();
        final count = guides.length;
        
        setState(() {
          _savedGuidesCount = count;
        });
      }
    } catch (e) {
      print('Error loading saved guides count: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
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
          onRefresh: _getUserData,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Section (Instagram-like)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture
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
                      // Name and Info
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

                // Action Buttons Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Edit Profile Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditTouristProfile();
                                },
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
                      const SizedBox(width: 12),
                      // Saved Guides Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedGuidesScreen(),
                              ),
                            );
                            // Refresh count when returning from SavedGuidesScreen
                            _loadSavedGuidesCount();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.favorite,
                            size: 18,
                          ),
                          label: Text(
                            _savedGuidesCount > 0
                                ? 'Saved ($_savedGuidesCount)'
                                : 'Saved',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                  builder: (context) => const SavedGuidesScreen(),
                                ),
                              );
                              // Refresh count when returning from SavedGuidesScreen
                              _loadSavedGuidesCount();
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildGuideListTile(
                        'Amara J.',
                        'Cultural Heritage Expert',
                        4.9,
                        124,
                        'https://plus.unsplash.com/premium_photo-1682142702814-5999525b4346?q=80&w=883&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      const SizedBox(height: 12),
                      _buildGuideListTile(
                        'Ruwan K.',
                        'Wildlife & Safari Specialist',
                        4.8,
                        89,
                        'https://plus.unsplash.com/premium_photo-1663089942980-b817c683b40f?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      const SizedBox(height: 12),
                      _buildGuideListTile(
                        'Priya M.',
                        'Adventure & Trekking Guide',
                        4.7,
                        56,
                        'https://plus.unsplash.com/premium_photo-1682097908465-398bf580bf81?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
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

  Widget _buildGuideListTile(
    String name,
    String specialty,
    double rating,
    int reviews,
    String imageUrl,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Guide tapped: $name');
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
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$reviews tours',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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