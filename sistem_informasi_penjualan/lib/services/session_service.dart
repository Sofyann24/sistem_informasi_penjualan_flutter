import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  static const String _tokenKey = 'auth_token';
  static const String _rememberMeKey = 'remember_me';

  // Simpan token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Ambil token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Simpan pilihan "Tetap Masuk"
  Future<void> setRememberMe(bool value) async {
    await _preferences.setBool(_rememberMeKey, value);
  }

  // Cek apakah user memilih "Tetap Masuk"
  Future<bool> getRememberMe() async {
    return await _preferences.getBool(_rememberMeKey) ?? false;
  }

  // Logout
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _tokenKey);

    await _preferences.remove(_rememberMeKey);
  }
}
