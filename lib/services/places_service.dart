import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class PlacesService {
  static const String baseUrl = "http://localhost:3000/api/places";

  static Future<List<Place>> getPlaces() async {
    final res = await http.get(Uri.parse(baseUrl));
    final List data = jsonDecode(res.body);
    return data.map((e) => Place.fromJson(e)).toList();
  }

  static Future<Place> getPlaceById(String id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));
    return Place.fromJson(jsonDecode(res.body));
  }
}
