import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/product_provider.dart';
import 'package:sistem_informasi_penjualan/services/api_services.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // FETCH
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiServices.get('/transaction');
      final List<dynamic> data = response['data'] ?? response;
      _transactions = data
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error fetch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // STORE
  Future<bool> storeTransaction({
    int? customerId,
    required int totalPrice,
    required int totalProfit,
    required double totalItems,
    required String paymentMethod,
    required String status,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiServices.post(
        '/transaction/store',
        data: {
          if (customerId != null && customerId > 0) 'customer_id': customerId,
          'total_price': totalPrice,
          'total_profit': totalProfit,
          'total_items': totalItems,
          'payment_method': paymentMethod,
          'status': status,
          if (notes != null) 'notes': notes,
          'items': items,
        },
      );

      if (response['status'] == 'success') {
        await fetchTransactions();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error store: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE
  Future<bool> deleteTransaction(int id) async {
    try {
      final response = await ApiServices.delete('/transaction/delete/$id');
      if (response['status'] == 'success') {
        _transactions.removeWhere((t) => t.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  num get profitPerToday {
    final now = DateTime.now();

    final todayTransac = _transactions.where((item) {
      return item.createdAt.year == now.year &&
          item.createdAt.month == now.month &&
          item.createdAt.day == now.day;
    });

    num totalProfit = 0;
    for (var profit in _transactions) {
      totalProfit += profit.totalPrice;
    }
    return totalProfit;
  }
}
