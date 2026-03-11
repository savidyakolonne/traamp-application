import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/saved_guides_service.dart';
import '../profile/guide_public_view_screen.dart';

class SavedGuidesScreen extends StatefulWidget {
  const SavedGuidesScreen({Key? key}) : super(key: key);

  @override
  State<SavedGuidesScreen> createState() => _SavedGuidesScreenState();
}

class _SavedGuidesScreenState extends State<SavedGuidesScreen> {
  final SavedGuidesService _savedGuidesService = SavedGuidesService();
  String? _touristUid;
  List<Map<String, dynamic>> _savedGuides = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadSavedGuides();
  }

  void _initializeUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _touristUid = user.uid;
    }
  }

  Future<void> _loadSavedGuides() async {
    if (_touristUid == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final guides = await _savedGuidesService.getSavedGuides(
        touristUid: _touristUid!,
      );

      setState(() {
        _savedGuides = guides;
      });
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showRemoveConfirmationDialog(
    String guideUid,
    String guideName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Remove Guide'),
          content: Text(
            'Remove $guideName from your saved guides?',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _removeGuide(guideUid);
    }
  }

  Future<void> _removeGuide(String guideUid) async {
    if (_touristUid == null) return;

    try {
      final success = await _savedGuidesService.unsaveGuide(
        touristUid: _touristUid!,
        guideUid: guideUid,
      );

      if (success) {
        // Remove from local list immediately for better UX
        setState(() {
          _savedGuides.removeWhere((guide) => guide['uid'] == guideUid);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guide removed from saved list'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove guide'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error removing guide: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> guide) {
    final String firstName = guide['firstName'] ?? 'Unknown';
    final String lastName = guide['lastName'] ?? '';
    final String fullName = '$firstName $lastName';
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
                builder: (context) => GuidePublicViewScreen(
                  guideId: guideUid,
                ),
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
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: profilePicture != null &&
                          profilePicture.isNotEmpty
                      ? NetworkImage(profilePicture)
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: profilePicture == null || profilePicture.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey[600],
                        )
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
                      fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
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
              // Favorite Icon Button
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  _showRemoveConfirmationDialog(guideUid, fullName);
                },
                tooltip: 'Remove from favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}