import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/saved_guides_service.dart';
import '../profile/guide_public_view_screen.dart';

// ignore: must_be_immutable
class SavedGuidesScreen extends StatefulWidget {
  String uid;
  SavedGuidesScreen(this.uid, {super.key});

  @override
  State<SavedGuidesScreen> createState() => _SavedGuidesScreenState();
}

class _SavedGuidesScreenState extends State<SavedGuidesScreen> {
  final SavedGuidesService _savedGuidesService = SavedGuidesService();
  List<Map<String, dynamic>> _savedGuides = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loadSavedGuides(); // load guides after UID is ready
    }
  }

  Future<void> _loadSavedGuides() async {
    setState(() => _isLoading = true);

    try {
      final guides = await _savedGuidesService.getSavedGuides();
      setState(() => _savedGuides = guides);
    } catch (e) {
      print('Error loading saved guides: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load saved guides'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
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
        title: const Text(
          'Saved Guides',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : _savedGuides.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _loadSavedGuides,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedGuides.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final guide = _savedGuides[index];
                    return _buildGuideCard(guide);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No saved guides yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and save your favorite guides',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // For now just go back to previous screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore Guides',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> guide) {
    final String firstName = guide['firstName'] ?? 'Unknown';
    final String lastName = guide['lastName'] ?? '';
    final double rating = (guide['rating'] ?? 0.0).toDouble();
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
                builder: (context) =>
                    GuidePublicViewScreen(guideId: guideUid, uid: widget.uid),
              ),
            ).then((_) {
              // Refresh the list when returning from guide profile
              _loadSavedGuides();
            });
          }
        },
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
          child: Row(
            children: [
              // Profile Picture
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      profilePicture != null && profilePicture.isNotEmpty
                      ? NetworkImage(profilePicture)
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: profilePicture == null || profilePicture.isEmpty
                      ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Guide Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
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
              // Arrow Icon
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
