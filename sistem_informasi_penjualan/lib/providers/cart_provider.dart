import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';

class CartItem {
  final ProductModel product;
  double quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => (product.priceSell * quantity);
  int get subtotal => (quantity * product.priceSell).toInt();

  int get profit {
    final profitPerUnit = product.priceSell - product.priceBuy;
    return (quantity * profitPerUnit).toInt();
  }

  int get cost => (quantity * product.priceBuy).toInt();

  String get formattedTotalPrice {
    return 'Rp ${totalPrice.toStringAsFixed(0)}';
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  CustomerModel _selectedCustomer = CustomerModel.defaultCustomer;

  Map<String, CartItem> get items => _items;
  int get itemsCount => _items.length;
  CustomerModel get selectedCustomer => _selectedCustomer;

  // TAMBAH ITEMS DI KERANJANG
  void addItems(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id as String,
        (exist) => CartItem(product: product, quantity: exist.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        product.id.toString(),
        () => CartItem(product: product, quantity: 1.0),
      );
    }
    notifyListeners();
  }

  double getQuantity(ProductModel product) {
    if (_items.containsKey(product.id.toString())) {
      return _items[product.id.toString()]!.quantity;
    }
    return 0.0;
  }

  // KURANGI ITEMS DI KERANJANG
  void removeItems(ProductModel product) {
    final id = product.id.toString();
    if (_items.containsKey(id)) {
      final item = _items[id]!;
      if (item.quantity > 1) {
        _items.update(
          id,
          (exist) => CartItem(product: product, quantity: exist.quantity - 1),
        );
      } else {
        _items.remove(id);
      }
    }
    notifyListeners();
  }

  // RESET ITEMS DI KERANJANG
  void resetItems() {
    _items.clear();
    notifyListeners();
  }

  void setQuantity(ProductModel product, double quantity) {
    final String id = product.id.toString();
    if (quantity <= 0) {
      _items.remove(id);
    } else {
      _items[id] = CartItem(product: product, quantity: quantity);
    }

    notifyListeners();
  }

  void updateQuantity(String productId, double quantity) {
    if (quantity <= 0) {
      _items.remove(productId);
    } else if (_items.containsKey(productId)) {
      _items[productId]!.quantity = quantity;
    }
    notifyListeners();
  }

  double getTotalPriceItem(ProductModel product) {
    final id = product.id.toString();
    if (!_items.containsKey(id)) {
      return 0.0;
    }
    return _items[id]!.totalPrice;
  }

  double get finalTotalPrice {
    double total = 0.0;
    for (final item in items.values) {
      total += item.totalPrice;
    }
    return total;
  }

  // ADD PRODUCT BY BARCODE
  void addProductFromScan(ProductModel product) {
    final String id = product.id.toString();

    if (_items.containsKey(id)) {
      _items.update(
        id,
        (exist) => CartItem(product: product, quantity: exist.quantity + 1),
      );
    } else {
      _items.putIfAbsent(id, () => CartItem(product: product, quantity: 1));
    }

    debugPrint('🟢 Produk ditambahkan: ${product.nameProduct}');
    notifyListeners();
  }

  // GET CUSTOMER
  void setCustomer(CustomerModel? customer) {
    _selectedCustomer = customer ?? CustomerModel.defaultCustomer;
    notifyListeners();
  }

  void resetCustomer() {
    _selectedCustomer = CustomerModel.defaultCustomer;
    notifyListeners();
  }

  // PROFIT
   int get totalProfit {
    int total = 0;
    for (final item in _items.values) {
      total += item.profit;
    }
    return total;
  }

  // TOTAL HARGA JUAL
  int get totalPrice {
    int total = 0;
    for (final item in _items.values) {
      total += item.subtotal;
    }
    return total;
  }


  // TOTAL HARGA BELI (MODAL)
  int get totalCost {
    int total = 0;
    for (final item in _items.values) {
      total += (item.quantity * item.product.priceBuy).toInt();
    }
    return total;
  }
}
