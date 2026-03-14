import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../models/guide.dart';
import '../../services/guide_service.dart';
import '../../services/saved_guides_service.dart';
import '../../app_config.dart';
import '../tourist/deatailed_package_view_tourist.dart';

class GuidePublicViewScreen extends StatefulWidget {
  final String guideId;

  const GuidePublicViewScreen({Key? key, required this.guideId})
      : super(key: key);

  @override
  State<GuidePublicViewScreen> createState() => _GuidePublicViewScreenState();
}

class _GuidePublicViewScreenState extends State<GuidePublicViewScreen> {
  bool _isLoading = true;
  Guide? _guide;
  String? _errorMessage;
  List<dynamic> _packages = [];
  bool _packagesLoading = true;

  final SavedGuidesService _savedGuidesService = SavedGuidesService();
  final GuideService _guideService = GuideService();
  bool _isGuideSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await _loadProfile();
    await Future.wait([
      _checkIfGuideSaved(),
      _loadPackages(),
    ]);
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final guide = await _guideService.getGuideByUid(widget.guideId);
      if (guide != null) {
        setState(() => _guide = guide);
      } else {
        setState(() => _errorMessage = 'Guide not found');
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _errorMessage = 'Failed to load guide profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPackages() async {
    if (mounted) setState(() => _packagesLoading = true);
    try {
      final response = await http.post(
        Uri.parse(
            '${AppConfig.SERVER_URL}/api/guidePackage/get-package-by-user-id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': widget.guideId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) setState(() => _packages = data['packages'] ?? []);
      }
    } catch (e) {
      print('Error loading packages: $e');
    } finally {
      if (mounted) setState(() => _packagesLoading = false);
    }
  }

  Future<void> _checkIfGuideSaved() async {
    try {
      final isSaved = await _savedGuidesService.isGuideSaved(
          guideUid: widget.guideId);
      if (mounted) setState(() => _isGuideSaved = isSaved);
    } catch (e) {
      print('Error checking if guide is saved: $e');
    }
  }

  Future<void> _toggleSaveGuide() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please log in to save guides'),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (_isSaving) return;
    setState(() {
      _isSaving = true;
      _isGuideSaved = !_isGuideSaved;
    });

    try {
      final success = await _savedGuidesService.toggleSaveGuide(
          guideUid: widget.guideId);
      if (!success) {
        setState(() => _isGuideSaved = !_isGuideSaved);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to update favorites'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isGuideSaved
                  ? 'Guide added to favorites'
                  : 'Guide removed from favorites'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isGuideSaved = !_isGuideSaved);
      print('Error toggling save guide: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // open email app
  Future<void> _launchEmail() async {
    final email = _guide?.email ?? '';
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email address available')),
      );
      return;
    }
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  // open WhatsApp with guide's phone number
  Future<void> _launchWhatsApp() async {
    final phone = _guide?.phoneNumber ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number available')),
      );
      return;
    }
    // strip non-digits and ensure + prefix handled
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), ''); // strip everything except digits
    final uri = Uri.parse('https://wa.me/$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  String _getInitial() {
    final firstName = _guide?.firstName ?? '';
    return firstName.isNotEmpty ? firstName.substring(0, 1) : '?';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage!,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _loadAll, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.red),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isGuideSaved ? Icons.favorite : Icons.favorite_border,
                    color: _isGuideSaved ? Colors.red : Colors.black,
                  ),
                  onPressed: _toggleSaveGuide,
                ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => print('Share tapped'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAll,
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
                          border:
                              Border.all(color: Colors.grey[300]!, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: _guide?.profilePicture != null &&
                                    _guide!.profilePicture!.isNotEmpty
                                ? Image.network(
                                    _guide!.profilePicture!,
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
                              '${_guide?.firstName ?? ''} ${_guide?.lastName ?? ''}'
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
                                  _guide?.rating.toStringAsFixed(1) ?? '0.0',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (_guide?.location != null &&
                                _guide!.location.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    _guide!.location,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            if (_guide?.isVerified ?? false)
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

                // ── Bio ──────────────────────────────────────────
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
                        (_guide?.bio != null && _guide!.bio!.isNotEmpty)
                            ? _guide!.bio!
                            : 'No bio available.',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Email + WhatsApp Buttons ─────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // ✅ Email button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _launchEmail,
                          icon: const Icon(Icons.email_outlined, size: 18),
                          label: const Text('Email',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ✅ WhatsApp button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _launchWhatsApp,
                          icon: const Icon(Icons.chat_outlined, size: 18),
                          label: const Text('WhatsApp',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Languages ────────────────────────────────────
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
                        (_guide?.languages != null &&
                                _guide!.languages!.isNotEmpty)
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _guide!.languages!
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

                // ── Skills & Expertise ───────────────────────────
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

                // ── Tour Packages ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tour Packages',
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
                        Text('No tour packages listed yet.',
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
                const SizedBox(height: 24),

                // ── Reviews ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Reviews',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => print('See All tapped'),
                            child: const Text('See All',
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('No reviews yet.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[500])),
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
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[200],
      child: Center(
        child: Text(_getInitial(),
            style:
                const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
              builder: (context) => DetailedPackageViewTourist(
                pkg,
                widget.guideId,
              ),
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
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
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
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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