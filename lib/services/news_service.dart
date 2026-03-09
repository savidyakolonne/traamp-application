import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  // replace with your backend URL
  static const String baseUrl =
      "https://yourproject.cloudfunctions.net/api/news";

  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}
