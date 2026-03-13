import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/guide.dart';
import '../../services/guide_service.dart';
import '../../services/saved_guides_service.dart';

class GuidePublicViewScreen extends StatefulWidget {
  final String guideId;

  const GuidePublicViewScreen({Key? key, required this.guideId})
      : super(key: key);

  @override
  State<GuidePublicViewScreen> createState() => _GuidePublicViewScreenState();
}

class _GuidePublicViewScreenState extends State<GuidePublicViewScreen> {
  bool _isLoading = false;
  Guide? _guide;
  String? _errorMessage;

  final SavedGuidesService _savedGuidesService = SavedGuidesService();
  final GuideService _guideService = GuideService();
  String? _touristUid;
  bool _isGuideSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadProfile();
    _checkIfGuideSaved();
  }

  void _initializeUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _touristUid = user.uid;
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final guide = await _guideService.getGuideByUid(widget.guideId);

      if (guide != null) {
        setState(() {
          _guide = guide;
        });
      } else {
        setState(() {
          _errorMessage = 'Guide not found';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _errorMessage = 'Failed to load guide profile';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkIfGuideSaved() async {
    if (_touristUid == null) return;
    try {
      final isSaved = await _savedGuidesService.isGuideSaved(
        guideUid: widget.guideId,
      );
      setState(() {
        _isGuideSaved = isSaved;
      });
    } catch (e) {
      print('Error checking if guide is saved: $e');
    }
  }

  Future<void> _toggleSaveGuide() async {
    if (_touristUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save guides'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final success = await _savedGuidesService.toggleSaveGuide(
        guideUid: widget.guideId,
      );

      if (success) {
        setState(() {
          _isGuideSaved = !_isGuideSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isGuideSaved
                  ? 'Guide added to favorites'
                  : 'Guide removed from favorites',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error toggling save guide: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // ✅ safe helper to get first letter of name
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
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
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
          IconButton(
            icon: Icon(
              _isGuideSaved ? Icons.favorite : Icons.favorite_border,
              color: _isGuideSaved ? Colors.red : Colors.black,
            ),
            onPressed: _isSaving ? null : _toggleSaveGuide,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => print('Share tapped'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
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
                        backgroundImage: _guide?.profilePicture != null &&
                                _guide!.profilePicture!.isNotEmpty
                            ? NetworkImage(_guide!.profilePicture!)
                            : null,
                        child: _guide?.profilePicture == null ||
                                _guide!.profilePicture!.isEmpty
                            ? Text(
                                // ✅ crash fix — safe initial letter
                                _getInitial(),
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_guide?.firstName ?? ''} ${_guide?.lastName ?? ''}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                _guide?.rating.toStringAsFixed(1) ?? '0.0',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _guide?.location ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bio Section
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
                      _guide?.bio ?? 'No bio available.',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => print('Book Now tapped'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Book Now',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => print('Message tapped'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Message',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Languages
              if (_guide?.languages != null && _guide!.languages!.isNotEmpty)
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _guide!.languages!
                              .map((lang) => _buildChip(lang))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Skills Section
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildChip('Cultural Heritage'),
                          _buildChip('Wildlife Tours'),
                          _buildChip('Photography'),
                          _buildChip('History'),
                          _buildChip('Tea Plantations'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tour Packages
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tour Packages',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildPackageCard('Cultural Kandy Experience', '3 Days',
                        '\$450',
                        'Temple of the Tooth, Royal Botanical Gardens, Traditional Dance'),
                    const SizedBox(height: 12),
                    _buildPackageCard('Yala Wildlife Safari', '2 Days', '\$350',
                        'Leopard tracking, Elephant herds, Bird watching'),
                    const SizedBox(height: 12),
                    _buildPackageCard('Ella Hill Country', '4 Days', '\$550',
                        'Nine Arch Bridge, Tea estates, Little Adam\'s Peak hiking'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Tours
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Tours',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1656159625990-8cd23231c218?q=80&w=870&auto=format&fit=crop',
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://plus.unsplash.com/premium_photo-1663089942980-b817c683b40f?q=80&w=387&auto=format&fit=crop',
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Showing highlights from recent adventures in Kandy, Yala & Sigiriya',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reviews
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reviews',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => print('See All Reviews tapped'),
                          child: const Text('See All',
                              style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildReviewTile('SJ', 'Sarah Jenkins', 'United Kingdom',
                        'Kasun was incredible! His knowledge about local wildlife in Yala was world-class.'),
                    const SizedBox(height: 12),
                    _buildReviewTile('MK', 'Markus K.', 'Germany',
                        'Great experience in Kandy. Punctual and very friendly!'),
                    const SizedBox(height: 12),
                    _buildReviewTile('LA', 'Lucia A.', 'Spain',
                        'Kasun is the best guide we\'ve had in Sri Lanka. Highly recommend for families.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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

  Widget _buildPackageCard(
      String title, String duration, String price, String description) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => print('Package tapped: $title'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(duration,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(width: 16),
                  Icon(Icons.attach_money, size: 14, color: Colors.green[700]),
                  Text(price,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700])),
                ],
              ),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[700], height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTile(
      String initials, String name, String country, String review) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Text(initials,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(country,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(Icons.star,
                            color: Colors.amber, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black87, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}