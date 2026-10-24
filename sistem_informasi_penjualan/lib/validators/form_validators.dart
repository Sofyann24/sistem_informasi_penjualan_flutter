import 'package:sistem_informasi_penjualan/models/category_model.dart';

class FormValidator {
  // Validator Auth
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username wajib diisi';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    if (!value.contains('@')) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi';
    }

    if (value.length < 10) {
      return 'Nomor HP minimal 10 digit';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != password) {
      return 'Password tidak sama';
    }

    return null;
  }

  // Validator Categories
  static String? categories(String? value, List<CategoryModel> categories) {
    if (value == null || value.isEmpty) {
      return 'Isi nama kategori!';
    }

    final isDuplicate = categories.any(
      (cat) => cat.name.toLowerCase() == value.trim().toLowerCase(),
    );

    if (isDuplicate) {
      return 'Kategori sudah ada';
    }

    return null;
  }
}
