import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/formatters.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/utils/extension.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final currentProduct = productProvider.products.firstWhere(
      (p) => p.id == widget.product.id,
      orElse: () => widget.product,
    );

    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.product.nameProduct), elevation: 2),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT IMAGE
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(bottom: BorderSide(width: 0.4)),
                  ),
                  child:
                      currentProduct.imageUrl != null &&
                          currentProduct.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.product.imageUrl.toString(),
                          fit: BoxFit.contain,
                        )
                      : Center(child: Text('Tidak ada gambar produk')),
                ),

                // NAME PRODUCT
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    currentProduct.nameProduct,
                    style: context.textTheme.headlineLarge,
                  ),
                ),

                // DETAIL PRODUCT
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ${AppFormatters.formatCurrency(currentProduct.priceSell)} / ${currentProduct.unit.value}',
                        style: context.textTheme.headlineSmall,
                      ),
                      Text(
                        'Untung: ${AppFormatters.formatCurrency(productProvider.profitPerItem(currentProduct))}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          currentProduct.barcode == null
                              ? Text('Kode: -')
                              : Text(
                                  'Kode: ${currentProduct.barcode}',
                                  style: context.textTheme.bodyLarge,
                                ),
                          Text(
                            'Stok: ${AppFormatters.formatQuantity(currentProduct.stock.toDouble(), currentProduct.unit)}',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: currentProduct.isLowStock
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Kategori: ${categoryProvider.getCatName(currentProduct.categoryId)}',
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                // ALERT LOW STOCK
                Container(
                  child: currentProduct.isOutOfStock
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 246, 207, 205),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            'Stok ${currentProduct.nameProduct} habis, segera lakukan restok!',
                          ),
                        )
                      : currentProduct.isLowStock
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 246, 207, 205),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            'Stok ${currentProduct.nameProduct} tersisa ${currentProduct.stock}, segera lakukan restok',
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
    );
  }
}
