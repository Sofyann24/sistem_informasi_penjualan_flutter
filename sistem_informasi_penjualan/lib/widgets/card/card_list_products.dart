// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/utils/extension.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

// CARD LIST VIEW
class ProductCardList extends StatefulWidget {
  const ProductCardList({
    super.key,
    required this.products,
    required this.onTap,
  });

  final List<ProductModel> products;
  final VoidCallback onTap;

  @override
  State<ProductCardList> createState() => _ProductCardListState();
}

class _ProductCardListState extends State<ProductCardList> {
  Future<void> _showWeightDialog(
    ProductModel product,
    CartProvider cartProvider,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => DynamicFormDialog(
        title: 'Jumlah ${product.nameProduct}',
        fields: [
          FormFieldConfig(
            key: 'Weight',
            label: 'Jumlah (${product.unit})',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            isRequired: true,
            initialValue: '',
          ),
        ],
        onSubmit: (Map<String, dynamic> values) async {
          final weightStr = values['Weight'] as String? ?? '0';
          final weight = double.tryParse(weightStr) ?? 0;

          if (weight <= 0) return false;

          cartProvider.setQuantity(product, weight);
          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return ListView.separated(
      padding: EdgeInsets.all(4),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 12, thickness: 0.8, color: Color(0xFFE0E0E0));
      },
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        final qtyCart = cartProvider.getQuantity(product).toInt();

        final categoryUnit = UnitData.getCategory(product.unit.value);
        final isWeight = categoryUnit == 'Berat';
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: ListTile(
            leading: SizedBox(
              height: 100,
              width: 60,
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
            title: Text(product.nameProduct),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${product.priceSell} / ${product.unit.value}'),
                Text(
                  'Stok: ${product.stock.toString()} ${product.unit.value}',
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
            trailing: ProductQuantityControl(
              width: 140,
              height: 30,
              product: product,
            ),
          ),
        );
      },
    );
  }
}
