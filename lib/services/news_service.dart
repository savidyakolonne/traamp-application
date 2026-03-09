import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/news_model.dart';

class NewsService {
  static const String baseUrl = "${AppConfig.SERVER_URL}/api/news";

  static Future<List<News>> getNews() async {
    final res = await http.get(Uri.parse(baseUrl));

    final List data = jsonDecode(res.body);

    return data.map((e) => News.fromJson(e)).toList();
  }
}
