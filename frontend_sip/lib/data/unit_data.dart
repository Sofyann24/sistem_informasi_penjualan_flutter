import 'package:sistem_informasi_penjualan/models/models.dart';

class UnitData {
  static final List<UnitModel> units = [
    // BERAT
    UnitModel(
      value: 'kg',
      label: 'Kilogram',
      symbol: 'kg',
      base: 'gram',
      multiplier: 1000,
      categoryUnit: 'Berat',
    ),
    UnitModel(
      value: 'gram',
      label: 'Gram',
      symbol: 'g',
      base: 'gram',
      multiplier: 1,
      categoryUnit: 'Berat',
    ),
    UnitModel(
      value: 'ons',
      label: 'Ons',
      symbol: 'ons',
      base: 'gram',
      multiplier: 100,
      categoryUnit: 'Berat',
    ),

    // KUANTITAS
    UnitModel(
      value: 'pcs',
      label: 'Pieces',
      symbol: 'pcs',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kuantitas',
    ),
    UnitModel(
      value: 'lusin',
      label: 'Lusin',
      symbol: 'lusin',
      base: 'pcs',
      multiplier: 12,
      categoryUnit: 'Kuantitas',
    ),
    UnitModel(
      value: 'kodi',
      label: 'Kodi',
      symbol: 'kodi',
      base: 'pcs',
      multiplier: 20,
      categoryUnit: 'Kuantitas',
    ),
    UnitModel(
      value: 'gross',
      label: 'Gross',
      symbol: 'gross',
      base: 'pcs',
      multiplier: 144,
      categoryUnit: 'Kuantitas',
    ),
    UnitModel(
      value: 'rim',
      label: 'Rim',
      symbol: 'rim',
      base: 'pcs',
      multiplier: 500,
      categoryUnit: 'Kuantitas',
    ),

    // KEMASAN
    UnitModel(
      value: 'pack',
      label: 'Pack',
      symbol: 'pack',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'box',
      label: 'Box',
      symbol: 'box',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'dus',
      label: 'Dus',
      symbol: 'dus',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'karton',
      label: 'Karton',
      symbol: 'karton',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'bungkus',
      label: 'Bungkus',
      symbol: 'bks',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'sachet',
      label: 'Sachet',
      symbol: 'sachet',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'renceng',
      label: 'Renceng',
      symbol: 'renceng',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'botol',
      label: 'Botol',
      symbol: 'btl',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
    UnitModel(
      value: 'kaleng',
      label: 'Kaleng',
      symbol: 'klg',
      base: 'pcs',
      multiplier: 1,
      categoryUnit: 'Kemasan',
    ),
  ];

  // KELOMPOKKAN BERDASARKAN KATEGORI
  static Map<String, List<UnitModel>> get groupedUnits {
    final Map<String, List<UnitModel>> grouped = {};

    for (final unit in units) {
      if (!grouped.containsKey(unit.categoryUnit)) {
        grouped[unit.categoryUnit] = [];
      }
      grouped[unit.categoryUnit]!.add(unit);
    }

    return grouped;
  }

  // DAFTAR KATEGORI UNIK
  static List<String> get categories {
    return groupedUnits.keys.toList();
  }

  // GET UNIT BY VALUE
  static UnitModel? getByValue(String value) {
    try {
      return units.firstWhere((u) => u.value == value);
    } catch (e) {
      return null;
    }
  }

  // GET UNIT BY KATEGORI
  static String? getCategory(String unitValue) {
    try {
      final unit = units.firstWhere(
        (u) => u.value.toLowerCase() == unitValue.toLowerCase().trim(),
      );
      return unit.categoryUnit;
    } catch (e) {
      return null;
    }
  }
}
