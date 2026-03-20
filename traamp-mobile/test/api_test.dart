import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:traamp_frontend/app_config.dart';

Future<String> loginEmail(http.Client client) async {
  final response = await client.post(
    Uri.parse("${AppConfig.SERVER_URL}/api/users/loginWithEmail"),
  );
  final data = jsonDecode(response.body);
  return data['msg'].toString();
}

Future<String> getPackages(http.Client client) async {
  final response = await client.get(
    Uri.parse("${AppConfig.SERVER_URL}/api/guidePackage/get-all-packages"),
  );
  final data = jsonDecode(response.body);
  return data['msg'].toString();
}

Future<String> getAllFavorites(http.Client client) async {
  final response = await client.post(
    Uri.parse("${AppConfig.SERVER_URL}/api/favorite/get-favorites"),
  );

  final data = await jsonDecode(response.body);
  return data['msg'].toString();
}

Future<String> getActivities(http.Client client) async {
  final res = await client.get(
    Uri.parse("${AppConfig.SERVER_URL}/api/activity"),
  );
  final data = jsonDecode(res.body);
  return data['msg'].toString();
}

Future<String> getPlaces(http.Client client) async {
  final res = await client.get(Uri.parse("${AppConfig.SERVER_URL}/api/places"));
  final data = jsonDecode(res.body);
  return data['msg'].toString();
}

Future<String> getNotifications(http.Client client) async {
  final response = await client.post(
    Uri.parse("${AppConfig.SERVER_URL}/api/notification/getNotifications"),
  );
  final data = jsonDecode(response.body);
  return data['msg'].toString();
}

Future<String> getGalleries(http.Client client) async {
  final response = await client.post(
    Uri.parse("${AppConfig.SERVER_URL}/api/gallery/get-gallery-by-uid"),
  );
  final data = jsonDecode(response.body);
  return data['msg'].toString();
}

void main() {
  // mock client responding success
  final client = MockClient((request) async {
    return http.Response(
      jsonEncode({'msg': 'Successfully retrieved data'}),
      200,
    );
  });

  // test #1
  test('test user login', () async {
    final result = await loginEmail(client);
    expect(result, "Successfully retrieved data");
  });

  // test #2
  test('test packages API', () async {
    final result = await getPackages(client);
    expect(result, "Successfully retrieved data");
  });

  // test #3
  test('test favorites API', () async {
    final result = await getAllFavorites(client);
    expect(result, "Successfully retrieved data");
  });

  // test #4
  test('test activity service', () async {
    final result = await getActivities(client);
    expect(result, "Successfully retrieved data");
  });

  // test #5
  test('test places service', () async {
    final result = await getPlaces(client);
    expect(result, "Successfully retrieved data");
  });

  // test #6
  test('test notification service', () async {
    final result = await getNotifications(client);
    expect(result, "Successfully retrieved data");
  });

  // test #7
  test('test gallery API', () async {
    final result = await getGalleries(client);
    expect(result, "Successfully retrieved data");
  });
}
