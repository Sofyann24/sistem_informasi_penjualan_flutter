import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class ProductQuantityControl extends StatelessWidget {
  final ProductModel product;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final bool showCloseButton;
  final VoidCallback? onWeightTap;

  const ProductQuantityControl({
    super.key,
    required this.product,
    this.height,
    this.fontSize = 14,
    this.iconSize = 24,
    this.borderRadius = 10,
    this.showCloseButton = true,
    this.onWeightTap,
    this.width,
  });

  // CEK STOK HABIS
  bool get _isOutOfStock => product.stock <= 0;

  @override
  Widget build(BuildContext context) {
    // KALO STOK HABIS, TAMPILIN ALERT
    if (_isOutOfStock) {
      return _buildOutOfStockButton(context);
    }

    final cartProvider = context.watch<CartProvider>();
    final qtyCart = cartProvider.getQuantity(product);
    final qtyCartDouble = qtyCart.toDouble();

    // CEK KATEGORI UNIT
    final categoryUnit = UnitData.getCategory(product.unit.value);
    final isWeight = categoryUnit == 'Berat' || categoryUnit == 'Volume';

    // TEXT CONTROLLER
    final controller = TextEditingController(
      text: qtyCartDouble > 0
          ? qtyCartDouble.toStringAsFixed(qtyCartDouble % 1 == 0 ? 0 : 1)
          : '',
    );

    // KONDISI 1: BERAT/VOLUME
    if (isWeight) {
      return qtyCartDouble == 0
          ? _buildAddButton(
              onTap: () => _handleWeightTap(context, cartProvider),
            )
          : Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(borderRadius!),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: TextField(
                        readOnly: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*[\.,]?\d*'),
                          ),
                        ],
                        controller: controller,
                        onTap: () => _handleWeightTap(context, cartProvider),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showCloseButton)
                  GestureDetector(
                    onTap: () => cartProvider.setQuantity(product, 0),
                    child: Icon(
                      Icons.close,
                      size: iconSize,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            );
    }

    // KONDISI 2: KUANTITAS/KEMASAN
    return qtyCart == 0
        ? _buildAddButton(onTap: () => cartProvider.addItems(product))
        : SizedBox(
          height: height,
          width: width,
          child: PickQty(
              initValue: qtyCart.toInt(),
              minValue: 0,
              maxValue: product.stock,
              onChanged: (newQuantity) {
                cartProvider.setQuantity(product, newQuantity.toDouble());
              },
            ),
        );
  }

  // TOMBOL TAMBAH (REUSABLE)
  Widget _buildAddButton({required VoidCallback onTap}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
        child: Text(
          'Tambah',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // TOMBOL STOK HABIS (DISABLED + ALERT)
  Widget _buildOutOfStockButton(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          // TAMPILIN ALERT
          _showOutOfStockAlert(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade400, // WARNA ABU
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
        child: Text(
          'Stok Habis',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ALERT STOK HABIS
  void _showOutOfStockAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Stok Habis'),
          ],
        ),
        content: Text(
          'Stok ${product.nameProduct} sudah habis. Segera restok!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleWeightTap(BuildContext context, CartProvider cartProvider) {
    if (onWeightTap != null) {
      onWeightTap!();
    } else {
      _showWeightDialog(context, product, cartProvider);
    }
  }

  Future<void> _showWeightDialog(
    BuildContext context,
    ProductModel product,
    CartProvider cartProvider,
  ) async {
    final currentQty = cartProvider.getQuantity(product);
    final controller = TextEditingController(
      text: currentQty > 0 ? currentQty.toString() : '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Jumlah ${product.nameProduct}'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Jumlah (${product.unit})',
            hintText: '0.0',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final weightStr = controller.text.replaceAll(',', '.');
              final weight = double.tryParse(weightStr) ?? 0;

              if (weight > 0) {
                // CEK STOK
                if (weight > product.stock) {
                  Navigator.pop(context);
                  _showStockLimitAlert(context, weight);
                  return;
                }
                cartProvider.setQuantity(product, weight);
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ALERT MELEBIHI STOK
  void _showStockLimitAlert(BuildContext context, double requested) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Stok Tidak Cukup'),
          ],
        ),
        content: Text(
          'Stok tersedia hanya ${product.stock} ${product.unit}. '
          'Anda meminta $requested ${product.unit}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
