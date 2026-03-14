import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/guide.dart';
import '../app_config.dart';

class GuideService {
  final String baseUrl = "${AppConfig.SERVER_URL}/api/guides";

  Future<List<Guide>> fetchGuides({
    String? location,
    List<String>? languages,
  }) async {
    try {
      String query = '';
      if (location != null) query += 'location=$location&';
      if (languages != null && languages.isNotEmpty) {
        query += 'languages=${languages.join(',')}&';
      }

      final response = await http.get(
        Uri.parse("$baseUrl?$query"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body is List ? body : (body['data'] ?? []);

        final guides = data.map((e) {
          return Guide.fromMap({
            ...e,
            'rating': e['rating']?.toString() ?? '0',
          });
        }).toList();

        //shuffle on client side too so each refresh looks different
        guides.shuffle(Random());

        return guides;
      } else {
        print("Error fetching guides: ${response.body}");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Guide?> getGuideByUid(String uid) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$uid"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        return Guide.fromMap({
          ...data,
          'rating': data['rating']?.toString() ?? '0',
        });
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}