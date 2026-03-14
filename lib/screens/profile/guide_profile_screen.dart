import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../app_config.dart';
import '../guide/guide_edit_profile.dart';
import '../guide/guide packages/detailed_guide_package.dart';

// ignore: must_be_immutable
class GuideProfileScreen extends StatefulWidget {
  final String idToken;
  Map<String, dynamic> userData;

  GuideProfileScreen(this.idToken, this.userData, {super.key});

  @override
  State<GuideProfileScreen> createState() => _GuideProfileScreenState();
}

class _GuideProfileScreenState extends State<GuideProfileScreen> {
  bool _isLoading = false;
  String profilePicture = "";
  List<dynamic> _packages = [];
  bool _packagesLoading = true;

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

  Future<void> _getPackages() async {
    if (mounted) setState(() => _packagesLoading = true);
    try {
      final uid = widget.userData['uid'] ??
          FirebaseAuth.instance.currentUser?.uid ?? '';

      final response = await http.post(
        Uri.parse(
            "${AppConfig.SERVER_URL}/api/guidePackage/get-package-by-user-id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'uid': uid}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) setState(() => _packages = data['packages'] ?? []);
      } else {
        print('Error fetching packages: ${data['msg']}');
      }
    } catch (e) {
      print('Error fetching packages: $e');
    } finally {
      if (mounted) setState(() => _packagesLoading = false);
    }
  }

  Future<void> _refreshAll() async {
    await _getUserData();
    await _getPackages();
  }

  @override
  void initState() {
    super.initState();
    _getUserData().then((_) => _getPackages());
  }

  List<String> get _languages {
    final raw = widget.userData['languages'];
    if (raw == null) return [];
    if (raw is List) return List<String>.from(raw);
    return [];
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
          onPressed: () => Navigator.pop(context),
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

                // ── Profile Header ──────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!, width: 2),
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
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.userData['rating'] ?? '0.0'}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if ((widget.userData['location'] ?? '').isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.userData['location'],
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            if (widget.userData['isVerified'] == true)
                              Row(
                                children: const [
                                  Icon(Icons.verified,
                                      color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text('Verified Guide',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green)),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bio ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bio',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                        (widget.userData['bio'] != null &&
                                widget.userData['bio'].toString().isNotEmpty)
                            ? widget.userData['bio']
                            : 'No bio available.',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Edit Profile Button ───────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditGuideProfile(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Edit Profile',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Languages ────────────────────────────────
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
                        const Text('Languages',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _languages.isNotEmpty
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _languages
                                    .map((lang) => _buildChip(lang))
                                    .toList(),
                              )
                            : Text('No languages listed.',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Skills & Expertise ───────────────────────
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
                        const Text('Skills & Expertise',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Text('Not listed yet.',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── My Tour Packages ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Tour Packages',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (_packagesLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                                color: Colors.green),
                          ),
                        )
                      else if (_packages.isEmpty)
                        Text('No packages added yet.',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500]))
                      else
                        ..._packages.map((pkg) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildPackageCard(pkg),
                            )),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar() {
    final name = widget.userData['firstName']?.toString() ?? '';
    final initial = name.isNotEmpty ? name.substring(0, 1) : '?';
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[200],
      child: Center(
        child: Text(initial,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> pkg) {
    final title = pkg['packageTitle'] ?? 'Unnamed Package';
    final category = pkg['category'] ?? '';
    final duration = pkg['duration']?.toString() ?? '';
    final price = pkg['price']?.toString() ?? '';
    final location = pkg['location'] ?? '';
    final shortDescription = pkg['shortDescription'] ?? '';
    final coverImage = pkg['coverImage'] as String?;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        // ✅ navigate to detailed package view on tap
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedGuidePackage(pkg),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (coverImage != null && coverImage.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    coverImage,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey)),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (category.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F6D3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(category,
                            style: const TextStyle(
                                color: Color(0xFF7DD421),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Icon(Icons.more_vert,
                            color: Colors.grey[600], size: 20),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (location.isNotEmpty) ...[
                          const Icon(Icons.location_on,
                              size: 13, color: Colors.black45),
                          const SizedBox(width: 3),
                          Text(location,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                          const SizedBox(width: 12),
                        ],
                        if (duration.isNotEmpty) ...[
                          const Icon(Icons.access_time,
                              size: 13, color: Colors.black45),
                          const SizedBox(width: 3),
                          Text(duration,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                        ],
                      ],
                    ),
                    if (shortDescription.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.4)),
                    ],
                    if (price.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('$price LKR',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700])),
                    ],
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