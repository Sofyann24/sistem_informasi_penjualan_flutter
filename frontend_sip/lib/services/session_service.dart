import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final _storage = const FlutterSecureStorage();

  // 1. Fungsi Login
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // Simpan token ke Secure Storage
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 2. Fungsi Cek Apakah User Sudah Login (Dipanggil saat buka app)
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // 3. Fungsi Logout
  Future<void> logout() async {
    // Hapus token dari HP
    await _storage.delete(key: 'auth_token');
    // (Opsional) Panggil API logout Laravel untuk hapus token di DB
  }
}
