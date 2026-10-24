import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  bool isGrid = true;
  bool isLoading = false;
  int? _selectedCategoryIndex;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  // GETTER: FILTER PRODUK BERDASARKAN KATEGORI
  List<ProductModel> get _filteredProducts {
    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();

    return productProvider.products.where((element) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          element.nameProduct.toLowerCase().contains(
            _searchQuery.toLowerCase().trim(),
          );
      final matchesCategory =
          _selectedCategoryIndex == null ||
          element.categoryId ==
              categoryProvider.category[_selectedCategoryIndex!].id;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CartProvider>();
    context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // SEARCH BAR DAN KATEGORI
          HeadingCashierScreen(
            onCategorySelected: (index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            onSearchChanged: (String p1) {
              setState(() {
                _searchQuery = p1;
              });
            },
          ),
          // TOGGLE VIEW
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: ToggleViewWidget(
              isGrid: isGrid,
              onToggle: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
            ),
          ),

          Expanded(
            child: productProvider.products.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Produk Kosong',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Silakan pilih kategori lain',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  )
                : isGrid
                ? SingleChildScrollView(
                    child: _filteredProducts.isEmpty
                        ? const Center(child: Text('Produk Kosong'))
                        : ProductCardGrid(products: _filteredProducts),
                  )
                : ProductCardList(
                    products: _filteredProducts,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Beli produk'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemsCount == 0) {
            return const SizedBox.shrink();
          }
          return Badge(
            label: Text('${cart.itemsCount}'),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () {
                showCartBottomSheet(context);
              },
              child: Icon(Icons.shopping_basket, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
