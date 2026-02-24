import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static Future<String?> getToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('auth_token');
  }

  static Future<void> setToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final p = await SharedPreferences.getInstance();
    await p.remove('auth_token');
  }

  static Future<String?> getRefreshToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('refresh_token');
  }

  static Future<void> setRefreshToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('refresh_token', token);
  }
}