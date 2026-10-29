import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // ============================================================
  // SAVE TOKEN
  // ============================================================

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userKey, jsonEncode(user));
  }

  // ============================================================
  // GET USER
  // ============================================================

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString(_userKey);

    if (userData == null || userData.isEmpty) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // REMEMBER ME
  // ============================================================

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_rememberMeKey, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // ============================================================
  // CHECK LOGIN
  // ============================================================

  static Future<bool> isLoggedIn() async {
    final rememberMe = await getRememberMe();
    final token = await getToken();

    return rememberMe && token != null && token.trim().isNotEmpty;
  }

  // ============================================================
  // CLEAR STORAGE
  // ============================================================

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    // Hapus token dari secure storage
    await _secureStorage.delete(key: _tokenKey);

    // Hapus data lainnya
    await prefs.remove(_userKey);
    await prefs.remove(_rememberMeKey);
  }
}
