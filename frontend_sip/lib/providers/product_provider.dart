import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/services/api_services.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // FETCH PRODUCTS
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.get('/products');
      final List<dynamic> data = response['data'] ?? response;
      _products = data.map((item) => ProductModel.fromJson(item)).toList();
      _sortProducts();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error fetch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // SORTIR A-Z
  void _sortProducts() {
    _products.sort(
      (a, b) =>
          a.nameProduct.toLowerCase().compareTo(b.nameProduct.toLowerCase()),
    );
  }

  bool isProductExist(String nameProduct, {int? excludeId}) {
    return products.any((product) {
      if (excludeId != null && product.id == excludeId) {
        return false;
      }
      return product.nameProduct.toLowerCase() == nameProduct.toLowerCase();
    });
  }

  // ADD PRODUCT + IMAGE
  Future<bool> addProduct({
    required String barcode,
    required String nameProduct,
    required int priceBuy,
    required int priceSell,
    required int stock,
    required int minStock,
    int? categoryId,
    String? description,
    File? image,
    required String unit,
  }) async {
    if (isProductExist(nameProduct)) {
      _errorMessage = 'Produk sudah ada!';
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.postMultipart(
        '/products/store',
        data: {
          if (barcode.isNotEmpty) 'barcode': barcode,

          'name_product': nameProduct,
          'price_buy': priceBuy.toString(),
          'price_sell': priceSell.toString(),
          'stock': stock.toString(),
          'min_stock': minStock.toString(),
          if (categoryId != null) 'category_id': categoryId.toString(),
          'description': ?description,
          'unit': unit,
        },
        image: image,
      );

      debugPrint('📦 Add response: $response');

      if (response['status'] == 'success') {
        await fetchProducts();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal menambahkan';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error add: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE PRODUCT + IMAGE
  Future<bool> updateProduct({
    required int id,
    required String barcode,
    required String nameProduct,
    required int priceBuy,
    required int priceSell,
    required int stock,
    required int minStock,
    required String unit,
    int? categoryId,
    String? description,
    File? image,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.putMultipart(
        '/products/update/$id',
        data: {
          if (barcode.isNotEmpty) 'barcode': barcode,
          'name_product': nameProduct,
          'price_buy': priceBuy.toString(),
          'price_sell': priceSell.toString(),
          'stock': stock.toString(),
          'min_stock': minStock.toString(),
          'unit': unit.toString(),
          if (categoryId != null) 'category_id': categoryId.toString(),
          'description': ?description,
        },
        image: image,
      );

      debugPrint('📦 Update response: $response');
      debugPrint('📦 Update response: $response.barcode');

      if (response['status'] == 'success') {
        await fetchProducts();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mengupdate';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error update: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE PRODUCT
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiServices.delete('/products/delete/$id');

      if (response['status'] == 'success') {
        _products.removeWhere((product) => product.id == id);
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal menghapus';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET PRODUCT BY BARCODE
  ProductModel? getProductByBarcode(String barcode) {
    try {
      return _products.firstWhere((product) => product.barcode == barcode);
    } catch (e) {
      debugPrint('❌ Produk dengan barcode $barcode tidak ditemukan');
      return null;
    }
  }

  num profitPerItem(ProductModel product) {
    num buyPrice = product.priceBuy;
    num sellPrice = product.priceSell;

    return sellPrice - buyPrice;
  }

  num amountItemProfit(ProductModel product, int quantity) {
    num buyPrice = product.priceBuy;
    num sellPrice = product.priceSell;

    return (sellPrice - buyPrice) * quantity;
  }
}
