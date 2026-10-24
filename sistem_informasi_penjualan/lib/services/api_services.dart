import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  // BASE URL
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Emulator Android
  // static const String baseUrl = 'http://localhost:8000/api'; // Untuk Chrome / Desktop
  // static const String baseUrl = 'http://{IP Address}:8000/api'; // Untuk Hp Asli

  // TIMEOUT
  static const Duration timeout = Duration(seconds: 30);

  static const String registerUrl = '$baseUrl/register';
  static const Map<String, String> headers = {'Accept': 'application/json'};

  // TOKEN STORAGE
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('auth_token');
    return null;
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }

  // POST PHOTO (UPLOAD GAMBAR)
  static Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> data,
    File? image,
    String imageField = 'image',
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🟢 POST MULTIPART: $url');

      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Accept': 'application/json'});
      request.fields.addAll(data);
      if (image != null) {
        final ext = image.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'png' : 'jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            imageField,
            image.path,
            contentType: MediaType('image', mimeType),
          ),
        );
        debugPrint('📸 Image: ${image.path}');
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('📊 Status: ${response.statusCode}');
      debugPrint('📦 Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ POST Multipart Error: $e');
      rethrow;
    }
  }

  // PUT PHOTO (EDIT GAMBAR)
  static Future<dynamic> putMultipart(
    String endpoint, {
    required Map<String, String> data,
    File? image,
    String imageField = 'image',
    String method = 'PUT',
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🟢 PUT MULTIPART: $url');

      // PAKE POST + _method=PUT (LARAVEL TRICK)
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Accept': 'application/json'});
      request.fields.addAll({...data, '_method': 'PUT'});

      if (image != null) {
        final ext = image.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'png' : 'jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            imageField,
            image.path,
            contentType: MediaType('image', mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📊 Status: ${response.statusCode}');
      debugPrint('📦 Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('❌ PUT Multipart Error: $e');
      rethrow;
    }
  }

  // GET REQUEST
  static Future<dynamic> get(String endpoint) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseUrl$endpoint');

      print('get: $url');

      final response = await http
          .get(
            url,
            headers: {
              'Content_type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'bearer $token',
            },
          )
          .timeout(const Duration(seconds: 20));

      print('📊 Status: ${response.statusCode}');

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Get Error: $e');
    }
  }

  // POST REQUEST
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseUrl$endpoint');

      print('🟢 POST: $url');
      print('📦 Data: $data');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(const Duration(seconds: 20));

      print('📊 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST Error: $e');
    }
  }

  // PUT REQUEST
  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseUrl$endpoint');
      print('🟢 PUT: $url');
      print('📦 Data: $data');

      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(const Duration(seconds: 30));
      print('📊 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT Error: $e');
    }
  }

  // DELETE REQUEST
  static Future<dynamic> delete(String endpoint) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🗑️ DELETE: $url');

      final response = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer: $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      debugPrint('📊 Status: ${response.statusCode}');
      debugPrint('📦 Response: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE Error: $e');
    }
  }

  // HANDLE RESPONSE
  static dynamic _handleResponse(http.Response response) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse;
    } else {
      String errorMassage = 'Terjadi Kesalahan';

      if (jsonResponse.containsKey('massage')) {
        errorMassage = jsonResponse['massage'];
      }

      if (jsonResponse.containsKey('errors')) {
        final errors = jsonResponse['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          errorMassage = firstError.first;
        }
        throw Exception(errorMassage);
      }
    }
  }
}
