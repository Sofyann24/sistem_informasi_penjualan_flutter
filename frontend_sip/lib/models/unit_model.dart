class UnitModel {
  final String value;
  final String label;
  final String symbol;
  final String base;
  final double multiplier;
  final String categoryUnit;

  UnitModel({
    required this.value,
    required this.label,
    required this.symbol,
    required this.base,
    required this.multiplier,
    required this.categoryUnit,
  });

  double? convertTo(double value, UnitModel target) {
    if (base != target.base) return null;
    final baseValue = value * multiplier;
    return baseValue / target.multiplier;
  }

  // FORMAT: "1 kg = 1000 gram"
  String get conversionInfo {
    if (base == value) return '$symbol (satuan dasar)';
    return '1 $symbol = ${multiplier.toStringAsFixed(0)} $base';
  }
}
