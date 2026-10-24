// ignore_for_file: unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class HeadingCashierScreen extends StatefulWidget {
  final Function(int?) onCategorySelected;
  final Function(String) onSearchChanged;

  const HeadingCashierScreen({
    super.key,
    required this.onCategorySelected,
    required this.onSearchChanged,
  });

  @override
  State<HeadingCashierScreen> createState() => _HeadingCashierScreenState();
}

class _HeadingCashierScreenState extends State<HeadingCashierScreen> {
  int? selectedCategoryIndex;
  final TextEditingController _searchController = TextEditingController();
  final bool _isProcessingScan = false;

  @override
  void dispose() {
    _searchController.dispose(); // DISPOSE
    super.dispose();
  }

  // METHOD BARCODE SCANNER
  Future<void> _openScanner() async {
    debugPrint('📷 Buka scanner');

    // BUKA SCANNER + KIRIM CALLBACK
    final scannedBarcodes = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScanner(
          onBarcodeScanned: (barcode) {
            _addProductByBarcode(barcode);
          },
          autoClose: false,
        ),
      ),
    );

    debugPrint('📷 Selesai scan: ${scannedBarcodes?.length ?? 0} barcode');
  }

  void _addProductByBarcode(String barcode) {
    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    final product = productProvider.getProductByBarcode(barcode);

    if (product == null) {
      SoundHelper.playError();

      // TAMPILIN SNACKBAR (TAPI SCANNER TETEP KEBUKA)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Barcode $barcode tidak ditemukan'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }
    cartProvider.addItems(product);
    debugPrint('✅ ${product.nameProduct} ditambahkan ke cart');

    // TAMPILIN SNACKBAR SUKSES
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${product.nameProduct} ditambahkan'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );

    if (product.stock <= 0) {
      SoundHelper.playError();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Stok ${product.nameProduct} habis!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }
    cartProvider.addItems(product);

    // PLAY SUCCESS SOUND
    SoundHelper.playBeep();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${product.nameProduct} ditambahkan'),
        backgroundColor: Colors.green,
      ),
    );

    // HANDLE SCAN
    Future<void> _handleBarcodeScan(String barcode) async {
      if (_isProcessingScan) {
        debugPrint('⚠️ Skip, masih proses');
        return;
      }
      try {
        final productProvider = context.read<ProductProvider>();
        final cartProvider = context.read<CartProvider>();

        final product = productProvider.getProductByBarcode(barcode);
        if (product != null) {
          // TAMBAH ITEM (BUAT SCAN)
          cartProvider.addProductFromScan(product);
        }

        if (product == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '❌ Produk dengan barcode $barcode tidak ditemukan',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // CEK STOK
        if (product.stock <= 0) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Stok ${product.nameProduct} habis!'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${product.nameProduct} ditambahkan ke cart'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Error scan: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 243, 242, 242),
        padding: EdgeInsets.all(16),
        height: 130,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama produk...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                widget.onSearchChanged('');
                              },
                              icon: Icon(Icons.clear),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      widget.onSearchChanged(value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => _openScanner(),
                  icon: FaIcon(FontAwesomeIcons.barcode),
                  iconSize: 35,
                  color: Colors.black87,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryProvider.category.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemsCat = categoryProvider.category[index];
                  final isSelected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategoryIndex == index) {
                          selectedCategoryIndex = null;
                        } else {
                          selectedCategoryIndex = index;
                        }
                      });
                      widget.onCategorySelected(selectedCategoryIndex);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12, top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? Colors.lightBlue
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          itemsCat.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
