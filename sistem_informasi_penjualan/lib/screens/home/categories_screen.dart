import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController nameCategoryController = TextEditingController();
  final TextEditingController descripCategoryController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // FETCH DATA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    return Scaffold(
      appBar: CustomAppbar(title: 'Kategori'),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(''),
            categoryProvider.isLoading
                ? const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 40,
                      duration: Durations.long1,
                    ),
                  )
                : categoryProvider.category.isEmpty
                ? Center(child: Text('Belum ada Kategori'))
                : Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(height: 0, thickness: 1);
                      },
                      itemCount: categoryProvider.category.length,
                      itemBuilder: (BuildContext context, index) {
                        final categoryItems = categoryProvider.category[index];
                        return InkWell(
                          onLongPress: () {
                            CustomShowDialogBottomSheet.customShowModalBottomSheet(
                              context: context,
                              title: 'Kategori',
                              onEdit: () => _showCategoryForm(),
                              onDelete: () async {
                                final confirm = await DeleteConfirmDialog.show(
                                  context: context,
                                  title: 'Hapus Kategori',
                                  message: 'Apakah anda yakin ingin menghapus kategori ini?',
                                );
                                if (!confirm) return;

                                final success = await context
                                    .read<CategoryProvider>()
                                    .deleteCategory(categoryItems.id);

                                if (!mounted) return;

                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${categoryItems.name} berhasil dihapus!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                                debugPrint(
                                  'Kategori ${categoryItems.name} berhasil dihapus',
                                );
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              categoryItems.name,
                              style: context.textTheme.bodyLarge,
                            ),
                            subtitle: Text(categoryItems.description ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
            CustomButtonLarge(
              label: 'Tambah Kategori',
              onKlick: () => _showCategoryForm(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCategoryForm({CategoryModel? category}) async {
    final isEdit = category != null;
    final provider = context.read<CategoryProvider>();

    final result = await showDialog<bool>(
      context: context,
      // barrierDismissible = false,
      builder: (BuildContext context) => DynamicFormDialog(
        title: isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan',
        submitLabel: isEdit ? 'Ubah' : 'Tambah',
        // initialValues: isEdit ? {''} : null,
        fields: [
          FormFieldConfig(
            key: 'name_category',
            label: 'Nama Kategori',
            isRequired: true,
            validator: (p0) {
              if (provider.isCategoryExist(p0 ?? '', excludeId: category?.id)) {
                return 'Kategori Sudah Ada';
              }
              return null;
            },
          ),
          FormFieldConfig(key: 'description', label: 'Deskripsi'),
        ],
        onSubmit: (Map<String, dynamic> values) async {
          if (isEdit) {
            return await provider.updateCategory(category.id);
          } else {
            return await provider.addCategory(
              values['name_category'],
              values['description'] ?? '',
            );
          }
        },
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Kategori berhasil diupdate!'
                : 'Kategori berhasil ditambahkan!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
