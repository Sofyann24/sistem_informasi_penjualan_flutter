import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/services/api_services.dart';

class CustomersProvider extends ChangeNotifier {
  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;
  CustomerModel _selectedCustomer = CustomerModel.defaultCustomer;

  CustomerModel get selectedCustomer => _selectedCustomer;
  CustomerModel get defaultCustomer => CustomerModel.defaultCustomer;
  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // FETCH CUSTOMERS
  Future<void> fetchCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.get('/customers');
      final List<dynamic> data = response['data'] ?? response;

      _customers = data.map((items) {
        return CustomerModel.fromJson(items);
      }).toList();

      debugPrint('Fetch Customers: ${_customers.length}');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isCustomerExist(String nameCustomer, {int? excludeId}) {
    return _customers.any(
      (cust) => cust.nameCustomer.toLowerCase() == nameCustomer.toLowerCase(),
    );
  }

  // ADD CUSTOMERS
  Future<bool> addCustomer(
    String nameCustomer,
    String phoneNumber,
    String address,
  ) async {
    if (isCustomerExist(nameCustomer)) {
      _errorMessage = 'Data pelanggan sudah ada';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiServices.post(
        '/customers/store',
        data: {
          'name_customer': nameCustomer,
          'phone_number': phoneNumber,
          'address': address,
        },
      );

      await fetchCustomers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE CUSTOMER
  Future<bool> updateCustomer({
    required int id,
    required String nameCustomer,
    required String phoneNumber,
    String? address,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiServices.put(
        '/customers/update/$id',
        data: {
          'name': nameCustomer,
          'phone_number': phoneNumber,
          'address': address,
        },
      );
      debugPrint('📦 Update response: $response');

      await fetchCustomers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCustomer(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    debugPrint('🔍 2. ID: $id (tipe: ${id.runtimeType})');
    try {
      debugPrint('🗑️ Menghapus customer ID: $id');

      final response = await ApiServices.delete('/customers/delete/$id');
      debugPrint('📦 Response delete: $response');

      _customers.removeWhere((item) => item.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCustomer(CustomerModel? customer) {
    _selectedCustomer = customer ?? CustomerModel.defaultCustomer;
    notifyListeners();
  }

  void resetCustomer() {
    _selectedCustomer = CustomerModel.defaultCustomer;
    notifyListeners();
  }
}
