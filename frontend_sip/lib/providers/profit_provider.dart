import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';

import '../services/api_services.dart';

class ProfitProvider extends ChangeNotifier {
  ProfitModel? _todayData;
  bool _isLoading = false;
  String? _errorMessage;

  // GETTER
  ProfitModel? get todayData => _todayData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // FETCH TODAY SUMMARY
  Future<void> fetchTodaySummary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.get('/dashboard/today');
      debugPrint('📦 Response: $response');
      debugPrint('📦 Response type: ${response.runtimeType}');
      debugPrint('📦 Data: ${response['data']}');
      _todayData = ProfitModel.fromJson(response['data']);
      debugPrint('✅ Dashboard loaded: ${_todayData?.totalProfit}');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error fetch dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
