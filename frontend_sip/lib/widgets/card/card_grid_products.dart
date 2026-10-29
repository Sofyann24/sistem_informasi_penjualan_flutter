// CARD GRID VIEW
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class ProductCardGrid extends StatefulWidget {
  final List<ProductModel> products;
  final VoidCallback? onTap;

  const ProductCardGrid({super.key, required this.products, this.onTap});

  @override
  State<ProductCardGrid> createState() => _ProductCardGridState();
}

class _ProductCardGridState extends State<ProductCardGrid> {
  final Map<String, TextEditingController> _weightControllers = {};

  @override
  void dispose() {
    for (final controller in _weightControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = widget.products[index];
        final double qtyCartDouble = cartProvider.getQuantity(product);
        qtyCartDouble.toInt();
        final categoryUnit = UnitData.getCategory(product.unit.value);
        final isWeight = categoryUnit == 'Berat';
        final controller = _weightControllers.putIfAbsent(
          product.id.toString(),
          () => TextEditingController(),
        );
        if (isWeight) {
          controller.text = qtyCartDouble > 0
              ? qtyCartDouble.toStringAsFixed(1)
              : '0.0';
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Images
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6CF7).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: widget.products.isEmpty
                      ? Icon(
                          Icons.inventory_2_outlined,
                          size: 40,
                          color: const Color(0xFF4A6CF7).withValues(alpha: 0.3),
                        )
                      : Image.network(
                          product.imageUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              // Description Products
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nameProduct,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppFormatters.formatCurrency(product.priceSell)} / ${product.unit.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 18),
                        product.isOutOfStock
                            ? Text(
                                '${product.stock.toString()} ${product.unit.value} (perlu restok)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : product.isLowStock
                            ? Text(
                                '${product.stock.toString()} ${product.unit.value} (segera restok)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                '${product.stock.toString()} ${product.unit.value}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // BUTTON "TAMBAH"
                    ProductQuantityControl(
                      width: double.infinity,
                      height: 30,
                      product: product,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
