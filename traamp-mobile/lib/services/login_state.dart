import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  static late final SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool('isLoggedIn', value);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setUserType(String type) async {
    await _prefs?.setString('userType', type);
  }

  static String getUserType() {
    return _prefs?.getString('userType') ?? "";
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
