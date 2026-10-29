import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_informasi_penjualan/helpers/storage_helper.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/services/services.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _token;
  bool _isLoggedIn = false;
  bool _isCheckingAuth = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuth => _token != null && _token!.trim().isNotEmpty;
  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckingAuth => _isCheckingAuth;

  /* METHOD REGISTER */
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiServices.registerUrl),
        headers: ApiServices.headers,
        body: {
          'name': username,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = jsonDecode(response.body);
      _isLoading = false;

      if (response.statusCode == 201) {
        _user = UserModel.fromJson(data['data']);
        _token = data['access_token'];
        notifyListeners();
        return {'success': true};
      } else {
        notifyListeners();
        String errorMessage = data['message'] ?? 'Registrasi gagal';
        if (data['errors'] != null) {
          Map<String, dynamic> errors = data['errors'];
          // Mengambil pesan error pertama yang ditemukan
          errorMessage = errors.values.first[0];
        }
        return {
          'success': false,
          // 'message': data['message'] ?? 'Registrasi gagal',
          'message': errorMessage,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /* METHOD STAY LOGGED IN */
  Future<void> checkLoginStatus() async {
    _isCheckingAuth = true;
    notifyListeners();

    try {
      final rememberMe = await StorageHelper.getRememberMe();
      final token = await StorageHelper.getToken();

      // Tidak memilih "Tetap Masuk"
      if (!rememberMe) {
        _token = null;
        _user = null;
        _isLoggedIn = false;
        return;
      }

      // Token tidak ditemukan
      if (token == null || token.trim().isEmpty) {
        _token = null;
        _user = null;
        _isLoggedIn = false;
        return;
      }

      // Token ditemukan
      _token = token;
      _isLoggedIn = true;

      // Ambil user dari storage
      final userData = await StorageHelper.getUser();

      if (userData != null) {
        _user = UserModel.fromJson(userData);
      }
    } catch (e) {
      debugPrint('Check login status error: $e');

      _token = null;
      _user = null;
      _isLoggedIn = false;
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  /* METHOD LOGIN */
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse('${ApiServices.baseUrl}/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiServices.timeout);

      // DEBUG: CETAK RESPONSE
      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      // DEBUG: CETAK PARSED DATA
      print('📦 Parsed Data: $data');

      if (response.statusCode == 200) {
        // CEK STRUKTUR RESPONSE DARI LARAVEL
        String? token;
        Map<String, dynamic>? userData;

        // 🔥 Coba cek berbagai kemungkinan struktur response
        if (data['access_token'] != null) {
          // JWT format
          token = data['access_token'];
          userData = data['user'] ?? data['data'];
        } else if (data['data'] != null && data['data']['token'] != null) {
          // Sanctum format (data.token)
          token = data['data']['token'];
          userData = data['data']['user'] ?? data['data'];
        } else if (data['token'] != null) {
          // Token langsung di root
          token = data['token'];
          userData = data['user'] ?? data['data'];
        } else {
          // GAGAL: Token tidak ditemukan
          _isLoading = false;
          notifyListeners();
          return {
            'success': false,
            'message':
                data['message'] ??
                'Response tidak valid: token tidak ditemukan',
          };
        }

        if (token != null && token.isNotEmpty) {
          _token = token;
          if (userData != null) {
            _user = UserModel.fromJson(userData);
          }

          _isLoggedIn = true;
          _isLoading = false;

          await _saveLoginData();
          notifyListeners();

          print('✅ Login berhasil! Token: $token');
          return {'success': true};
        }
      }

      // LOGIN GAGAL
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': data['message'] ?? 'Email atau password salah!',
      };
    } on SocketException {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      };
    } on http.ClientException {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Terjadi masalah saat menghubungi server.',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // SIMPAN DATA LOGIN
  Future<List<dynamic>> _saveLoginData() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('${AuthService().baseUrl}/notes'),
      headers: {
        'Authorization': 'Bearer $token', // <-- INI KUNCINYA
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil notes');
    }
  }

  // 3. Method Logout
  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('${ApiServices.baseUrl}/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      // Ignore error
      debugPrint('Logout API error: $e');
    } finally {
      // HAPUS SEMUA DATA STORAGE
      await StorageHelper.clearAll();
      _isLoggedIn = false;
      _token = null;
      _user = null;
      notifyListeners();
    }
  }
}
