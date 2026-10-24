import 'package:intl/intl.dart';
import 'package:sistem_informasi_penjualan/data/data.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';

class AppFormatters {
  // FORMAT QUANTITY
  static String formatQuantity(double quantity, UnitModel unit) {
    final categoryUnit = UnitData.getCategory(unit.categoryUnit);
    final decimal = categoryUnit == 'Berat';

    if (decimal) {
      if (quantity % 1 == 0) {
        return '${quantity.toInt()} ${unit.value}';
      }
      return '${quantity.toStringAsFixed(1)} ${unit.value}';
    } else {
      return '${quantity.toInt()} ${unit.value}';
    }
  }

  // FORMAT CURRENCY
  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }
}
