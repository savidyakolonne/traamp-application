import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_config.dart';

class SavedGuidesService {
  final String _baseUrl = '${AppConfig.SERVER_URL}/api/saved-guides';

  // Helper to get auth headers with Firebase token
  Future<Map<String, String>> _getHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Add a guide to the tourist's saved guides list
  Future<bool> saveGuide({
    required String guideUid,
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await http.post(
        Uri.parse(_baseUrl),                  // POST /api/saved-guides
        headers: headers,
        body: jsonEncode({
          'guideUid': guideUid,              // touristUid comes from token on backend
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else if (response.statusCode == 409) {
        print('Guide already saved');
        return true;
      } else {
        print('Error saving guide: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error saving guide: $e');
      return false;
    }
  }

  /// Remove a guide from the tourist's saved guides list
  Future<bool> unsaveGuide({
    required String guideUid,
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$_baseUrl/$guideUid'),     // DELETE /api/saved-guides/:guideId
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Error removing saved guide: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error removing saved guide: $e');
      return false;
    }
  }

  /// Check if a guide is saved by the tourist
  Future<bool> isGuideSaved({
    required String guideUid,
  }) async {
    try {
      final headers = await _getHeaders();

      // Fetch all saved guides and check locally
      final guides = await getSavedGuides();
      return guides.any((guide) => guide['uid'] == guideUid);

    } catch (e) {
      print('Error checking if guide is saved: $e');
      return false;
    }
  }

  /// Get all saved guides for current user
  Future<List<Map<String, dynamic>>> getSavedGuides() async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse(_baseUrl),                  // GET /api/saved-guides
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        print('Error fetching saved guides: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching saved guides: $e');
      return [];
    }
  }

  /// Toggle save status
  Future<bool> toggleSaveGuide({
    required String guideUid,
  }) async {
    try {
      final isSaved = await isGuideSaved(guideUid: guideUid);

      if (isSaved) {
        return await unsaveGuide(guideUid: guideUid);
      } else {
        return await saveGuide(guideUid: guideUid);
      }
    } catch (e) {
      print('Error toggling save guide: $e');
      return false;
    }
  }

  /// Get all saved guide IDs
  Future<List<String>> getSavedGuideIds() async {
    try {
      final guides = await getSavedGuides();
      return guides.map((guide) => guide['uid'] as String).toList();
    } catch (e) {
      print('Error fetching saved guide IDs: $e');
      return [];
    }
  }
}