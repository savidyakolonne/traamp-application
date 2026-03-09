import 'package:cloud_firestore/cloud_firestore.dart';

class SavedGuidesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a guide to the tourist's saved guides list
  Future<bool> saveGuide({
    required String touristUid,
    required String guideUid,
  }) async {
    try {
      await _firestore.collection('users').doc(touristUid).update({
        'savedGuides': FieldValue.arrayUnion([guideUid]),
      });
      return true;
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
      await _firestore.collection('users').doc(touristUid).update({
        'savedGuides': FieldValue.arrayRemove([guideUid]),
      });
      return true;
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
      final doc = await _firestore.collection('users').doc(touristUid).get();
      final data = doc.data();
      
      if (data == null || !data.containsKey('savedGuides')) {
        return false;
      }
      
      final savedGuides = List<String>.from(data['savedGuides'] ?? []);
      return savedGuides.contains(guideUid);
    } catch (e) {
      print('Error checking if guide is saved: $e');
      return false;
    }
  }

  /// Get all saved guide IDs for a tourist
  Future<List<String>> getSavedGuideIds({
    required String touristUid,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(touristUid).get();
      final data = doc.data();
      
      if (data == null || !data.containsKey('savedGuides')) {
        return [];
      }
      
      return List<String>.from(data['savedGuides'] ?? []);
    } catch (e) {
      print('Error fetching saved guide IDs: $e');
      return [];
    }
  }

  /// Get full guide documents for all saved guides
  Future<List<Map<String, dynamic>>> getSavedGuides({
    required String touristUid,
  }) async {
    try {
      final savedGuideIds = await getSavedGuideIds(touristUid: touristUid);
      
      if (savedGuideIds.isEmpty) {
        return [];
      }
      
      final guides = <Map<String, dynamic>>[];
      
      for (final guideId in savedGuideIds) {
        final guideDoc = await _firestore
            .collection('users')
            .doc(guideId)
            .get();
        
        if (guideDoc.exists) {
          final guideData = guideDoc.data();
          if (guideData != null && guideData['type'] == 'guide') {
            guides.add({
              ...guideData,
              'uid': guideDoc.id,
            });
          }
        }
      }
      
      return guides;
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

  /// Stream saved guide IDs for real-time updates
  Stream<List<String>> savedGuideIdsStream({
    required String touristUid,
  }) {
    return _firestore
        .collection('users')
        .doc(touristUid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || !data.containsKey('savedGuides')) {
        return <String>[];
      }
      return List<String>.from(data['savedGuides'] ?? []);
    });
  }

  /// Get count of saved guides
  Future<int> getSavedGuidesCount({
    required String touristUid,
  }) async {
    try {
      final savedGuideIds = await getSavedGuideIds(touristUid: touristUid);
      return savedGuideIds.length;
    } catch (e) {
      print('Error getting saved guides count: $e');
      return 0;
    }
  }
}