import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _barcodeController = TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _priceBuyController;
  late TextEditingController _priceSellController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late TextEditingController _descriptionController;

  File? _selectedImage;
  bool _isLoading = false;
  CategoryModel? _selectedCategory;
  String _selectedUnit = 'pcs';

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.nameProduct ?? '');
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _priceBuyController = TextEditingController(
      text: p?.priceBuy.toString() ?? '',
    );
    _priceSellController = TextEditingController(
      text: p?.priceSell.toString() ?? '',
    );
    _stockController = TextEditingController(text: p?.stock.toString() ?? '');
    _minStockController = TextEditingController(
      text: p?.minStock.toString() ?? '',
    );
    _descriptionController = TextEditingController(text: p?.description ?? '');
    final unit = widget.product?.unit;
    _selectedUnit = unit?.value ?? 'pcs';
    if (p?.categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final categoryProvider = context.read<CategoryProvider>();
        final category = categoryProvider.category.firstWhere(
          (cat) => cat.id == p!.categoryId,
          orElse: () => CategoryModel(id: 0, name: 'Tidak ada'),
        );
        setState(() {
          _selectedCategory = category;
        });
        debugPrint('🔍 Kategori terpilih: ${category.name}');
      });
    }
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSellController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori dulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final provider = context.read<ProductProvider>();

      final success = isEdit
          ? await provider.updateProduct(
              image: _selectedImage,
              id: widget.product!.id,
              barcode: _barcodeController.text.trim(),
              nameProduct: _nameController.text.trim(),
              priceBuy: int.tryParse(_priceBuyController.text) ?? 0,
              priceSell: int.tryParse(_priceSellController.text) ?? 0,
              stock: int.tryParse(_stockController.text) ?? 0,
              minStock: int.tryParse(_minStockController.text) ?? 0,
              categoryId: _selectedCategory!.id,
              unit: _selectedUnit,
              description: _descriptionController.text.trim(),
            )
          : await provider.addProduct(
              image: _selectedImage,
              barcode: _barcodeController.text.trim(),
              nameProduct: _nameController.text.trim(),
              priceBuy: int.tryParse(_priceBuyController.text) ?? 0,
              priceSell: int.tryParse(_priceSellController.text) ?? 0,
              stock: int.tryParse(_stockController.text) ?? 0,
              minStock: int.tryParse(_minStockController.text) ?? 0,
              categoryId: _selectedCategory!.id,
              unit: _selectedUnit,
              description: _descriptionController.text.trim(),
            );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Produk berhasil diupdate!'
                  : 'Produk berhasil ditambahkan!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // METHOD BARCODE SCANNER
  Future<void> _barcodeScanner() async {
    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScanner(autoClose: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 _selectedUnit: $_selectedUnit');

    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Stok Barang'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  IMAGE FIELD
                Center(
                  child: ImageFields(
                    initialImageUrl: widget.product?.imageUrl,
                    onImageChanged: (file) {
                      setState(() => _selectedImage = file);
                    },
                  ),
                ),

                // SCANNER BARCODE
                CustomTextForm(
                  keyboardType: TextInputType.text,
                  label: 'Scanner Barcode',
                  hint: 'Scan Barcode',
                  controller: _barcodeController,
                  suffixIcon: IconButton(
                    onPressed: () => _barcodeScanner(),
                    icon: FaIcon(FontAwesomeIcons.barcode),
                  ),
                  validator: (value) {
                    if (productProvider.isProductExist(
                      _barcodeController.text,
                    )) {
                      return 'Barcode produk sudah ada';
                    }
                    return null;
                  },
                ),

                // NAMA PRODUK
                CustomTextForm(
                  keyboardType: TextInputType.text,
                  label: 'Nama Produk',
                  hint: 'Nama Produk',
                  controller: _nameController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Masukkan nama produk!';
                    }
                    if (productProvider.isProductExist(
                      _nameController.text,
                      excludeId: widget.product?.id,
                    )) {
                      return 'Nama produk sudah ada';
                    }
                    return null;
                  },
                ),

                // KATEGORI DROPDOWN
                CustomDropdown<CategoryModel>(
                  titleDropdown: 'Kategori',
                  items: categoryProvider.category,
                  itemAsString: (category) => category.name,
                  onSelected: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  selectedItem: _selectedCategory,
                  compareFn: (a, b) => a.id == b.id,
                  validator: (v) =>
                      v == null ? 'Silahkan Pilih Kategori' : null,
                ),

                // FORM HARGA & STOK
                Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: CustomTextForm(
                            label: 'Modal Barang',
                            hint: 'Harga modal barang',
                            controller: _priceBuyController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Harga beli wajib diisi'
                                : null,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: CustomTextForm(
                            label: 'Harga Jual',
                            hint: 'Harga jual barang',
                            controller: _priceSellController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Harga jual wajib diisi'
                                : null,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: CustomTextForm(
                            label: 'Stok Barang',
                            hint: 'Tambahkan stok barang',
                            controller: _stockController,
                            maxLines: 1,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Masukkan jumlah stok barang'
                                : null,
                          ),
                        ),
                        Expanded(
                          child: CustomTextForm(
                            label: 'Stok Minimum',
                            hint: 'Jumlah stok minimum',
                            controller: _minStockController,
                            maxLines: 1,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Masukkan jumlah stok minimum'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // UNIT DROPDOWN
                CustomDropdown<UnitModel>(
                  titleDropdown: 'Unit (Satuan)',
                  items: UnitData.units,
                  selectedItem: UnitData.getByValue(_selectedUnit),
                  itemAsString: (unit) => unit.label,
                  onSelected: (UnitModel? val) {
                    setState(() {
                      _selectedUnit = val?.value ?? 'pcs'; // HARUS .value
                    });
                    debugPrint('Unit Terpilih: ${val?.value}'); // HARUS .value
                  },
                  compareFn: (p0, p1) => p0.label == p1.label,
                ),

                //  DESKRIPSI
                CustomTextForm(
                  label: 'Deskripsi',
                  hint: 'Deskripsi produk (opsional)',
                  controller: _descriptionController,
                  maxLines: 3,
                ),

                //  TOMBOL SIMPAN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
