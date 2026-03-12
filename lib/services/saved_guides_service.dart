import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app_config.dart';

class SavedGuidesService {
  // Use AppConfig.SERVER_URL instead of hardcoded localhost
  final String _baseUrl = '${AppConfig.SERVER_URL}/api/saved-guides';

  /// Add a guide to the tourist's saved guides list
  Future<bool> saveGuide({
    required String touristUid,
    required String guideUid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'touristUid': touristUid,
          'guideUid': guideUid,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else if (response.statusCode == 409) {
        // Guide already saved - treat as success
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
    required String touristUid,
    required String guideUid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/remove'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'touristUid': touristUid,
          'guideUid': guideUid,
        }),
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
    required String touristUid,
    required String guideUid,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/check').replace(queryParameters: {
        'touristUid': touristUid,
        'guideUid': guideUid,
      });

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isSaved'] == true;
      } else {
        print('Error checking if guide is saved: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking if guide is saved: $e');
      return false;
    }
  }

  /// Get all saved guides for a tourist
  Future<List<Map<String, dynamic>>> getSavedGuides({
    required String touristUid,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$touristUid'),
        headers: {'Content-Type': 'application/json'},
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

  /// Toggle save status (save if not saved, unsave if saved)
  Future<bool> toggleSaveGuide({
    required String touristUid,
    required String guideUid,
  }) async {
    try {
      final isSaved = await isGuideSaved(
        touristUid: touristUid,
        guideUid: guideUid,
      );

      if (isSaved) {
        return await unsaveGuide(
          touristUid: touristUid,
          guideUid: guideUid,
        );
      } else {
        return await saveGuide(
          touristUid: touristUid,
          guideUid: guideUid,
        );
      }
    } catch (e) {
      print('Error toggling save guide: $e');
      return false;
    }
  }

  /// Get count of saved guides
  Future<int> getSavedGuidesCount({
    required String touristUid,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$touristUid/count'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      } else {
        print('Error getting saved guides count: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error getting saved guides count: $e');
      return 0;
    }
  }

  /// Get all saved guide IDs for a tourist (helper method for compatibility)
  Future<List<String>> getSavedGuideIds({
    required String touristUid,
  }) async {
    try {
      final guides = await getSavedGuides(touristUid: touristUid);
      return guides.map((guide) => guide['uid'] as String).toList();
    } catch (e) {
      print('Error fetching saved guide IDs: $e');
      return [];
    }
  }
}