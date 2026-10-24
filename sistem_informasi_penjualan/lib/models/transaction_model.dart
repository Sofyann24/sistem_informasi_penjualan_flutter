class TransactionModel {
  final int id;
  final String invoiceNumber;
  final int? customerId;
  final String? customerName;
  final int totalPrice;
  // final int totalProfit;
  final double totalItems;
  final String paymentMethod;
  final String status;
  final String? notes;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.invoiceNumber,
    this.customerId,
    this.customerName,
    required this.totalPrice,
    // required this.totalProfit,
    required this.totalItems,
    required this.paymentMethod,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '',
      customerId: json['customer_id'],
      customerName: json['customer']?['name_customer'],
      totalPrice: json['total_price'] ?? 0,
      // totalProfit: json['total_profit'] ?? 0,
      totalItems: (json['total_items'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? 'Cash',
      status: json['status'] ?? 'Lunas',
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
