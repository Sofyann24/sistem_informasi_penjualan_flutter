import 'package:sistem_informasi_penjualan/models/category_model.dart';

class DummyCategory {
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: 1, name: 'Makanan', description: ''),
      CategoryModel(id: 2, name: 'Minuman', description: ''),
      CategoryModel(id: 3, name: 'Bahan Segar', description: ''),
      CategoryModel(id: 4, name: 'Buah', description: ''),
      CategoryModel(id: 5, name: 'Es Kaya', description: ''),
      CategoryModel(id: 6, name: 'Kebutuhan Rumah', description: ''),
      CategoryModel(id: 7, name: 'Perawatan Diri', description: ''),
    ];
  }
}
