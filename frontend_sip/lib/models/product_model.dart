import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';

class ProductModel {
  final int id;
  final String? barcode;
  final String nameProduct;
  final int priceBuy;
  final int priceSell;
  final int stock;
  final int minStock;
  final UnitModel unit;
  final int? categoryId;
  final String? description;
  final String? image;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    this.barcode,
    required this.nameProduct,
    required this.priceBuy,
    required this.priceSell,
    required this.stock,
    required this.minStock,
    required this.unit,
    this.categoryId,
    this.description,
    this.image,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      barcode: json['barcode'],
      nameProduct: json['name_product'] ?? '',
      priceBuy: json['price_buy'] ?? 0,
      priceSell: json['price_sell'] ?? 0,
      stock: json['stock'] ?? 0,
      minStock: json['min_stock'] ?? 0,
      categoryId: json['category_id'],
      description: json['description'],
      image: json['image'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      unit: UnitData.getByValue(json['unit'] ?? 'pcs') ?? UnitData.units.first,
    );
  }

  bool get isLowStock => stock > 0 && stock <= minStock;
  bool get isOutOfStock => stock <= 0;

  num get profitPerItem => priceSell - priceBuy;
  num get totalProfit => (stock * profitPerItem);

  double get profitMargin {
    if (priceBuy == 0) return 0;
    return (profitPerItem / priceBuy) * 100;
  }
}
