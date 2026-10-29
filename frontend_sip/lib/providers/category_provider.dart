import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/category_model.dart';
import 'package:sistem_informasi_penjualan/services/api_services.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get category => _categories;
  bool get isLoading => _isLoading;
  String? get errorMassage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.get('/categories');
      final List<dynamic> data = response['data'] ?? response;

      _categories = data.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
      // _categories.sort(
      //   ((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
      // );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CHECK CATEGORY EXIST
  bool isCategoryExist(String name, {int? excludeId}) {
    return _categories.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );
  }

  // ADD CATEGORY
  Future<bool> addCategory(String nameCategory, String? description) async {
    if (isCategoryExist(nameCategory)) {
      _errorMessage = 'Kategori "$nameCategory" sudah ada!';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiServices.post(
        '/categories/store',
        data: {'name_category': nameCategory, 'description': description},
      );

      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error add category: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // METHOD UPDATE CATEGORY
  Future<bool> updateCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiServices.put('/categories/update/$id');
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error update category: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // METHOD DELETE
  Future<bool> deleteCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiServices.delete('/categories/delete/$id');

      _categories.removeWhere((item) => item.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET CATEGORY NAME
  String getCatName(int? catId) {
    if (catId == null) return '-';

    final category = _categories.firstWhere(
      (cat) => cat.id == catId,
      orElse: () => CategoryModel(id: 0, name: 'Tidak ada'),
    );
    return category.name;
  }
}
