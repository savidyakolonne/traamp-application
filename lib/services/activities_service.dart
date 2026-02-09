import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivitiesService {
  static const String baseUrl = "http://localhost:3000/api/activity";

  static Future<List<Activity>> getActivities() async {
    final res = await http.get(Uri.parse(baseUrl));
    final List data = jsonDecode(res.body);
    return data.map((e) => Activity.fromJson(e)).toList();
  }

  static Future<Activity> getActivityById(String id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));
    return Activity.fromJson(jsonDecode(res.body));
  }
}