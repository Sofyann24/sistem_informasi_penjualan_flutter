import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/formatters.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/screens/screens.dart';
import 'package:sistem_informasi_penjualan/services/services.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  // BUKA FORM TAMBAH
  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );
  }

  // BUKA FORM EDIT
  void _editProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
  }

  // HAPUS PRODUCT
  Future<void> _deleteProduct(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus "${product.nameProduct}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await context.read<ProductProvider>().deleteProduct(
      product.id,
    );

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Barang'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              final allProducts = productProvider.products;
              final lowStockItems = allProducts
                  .where((item) => (item.stock) <= item.minStock)
                  .toList();

              PdfStockService.generateAndPrintPdf(lowStockItems);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: productProvider.isLoading
            ? const Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 40,
                  duration: Durations.long1,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: productProvider.products.isEmpty
                        ? const Center(child: Text('Stok barang masih kosong'))
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(thickness: 2, height: 20);
                            },
                            itemCount: productProvider.products.length,
                            itemBuilder: (BuildContext context, index) {
                              final product = productProvider.products[index];
                              return InkWell(
                                onLongPress: () {
                                  CustomShowDialogBottomSheet.customShowModalBottomSheet(
                                    context: context,
                                    title: 'Stock',
                                    onEdit: () => _editProduct(product),
                                    onDelete: () => _deleteProduct(product),
                                  );
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          DetailProductScreen(
                                            product: product,
                                          )),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 70,
                                    child: productProvider.products.isEmpty
                                        ? const Icon(Icons.inventory_2_outlined)
                                        : Image.network(product.imageUrl!),
                                  ),
                                  title: Text(product.nameProduct),
                                  subtitle: Row(
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        Icons.inventory,
                                        color: product.stock <= product.minStock
                                            ? Colors.redAccent
                                            : Colors.grey,
                                      ),
                                      Text(
                                        AppFormatters.formatQuantity(
                                          product.stock.toDouble(),
                                          product.unit,
                                        ),
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                              color:
                                                  product.stock <=
                                                      product.minStock
                                                  ? Colors.redAccent
                                                  : const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Harga: ${AppFormatters.formatCurrency(product.priceSell.toDouble())}',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        'Untung: ${AppFormatters.formatCurrency(productProvider.profitPerItem(product))} / ${product.unit.value}',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  CustomButtonLarge(label: 'Tambah Stok', onKlick: _addProduct),
                  //
                ],
              ),
      ),
    );
  }
}
