class CustomerModel {
  final int id;
  final String nameCustomer;
  final String phoneNumber;
  final String? address;

  CustomerModel({
    required this.id,
    required this.nameCustomer,
    required this.phoneNumber,
    required this.address,
  });

  static CustomerModel get defaultCustomer => CustomerModel(
    id: 0,
    nameCustomer: 'Pelanggan Umum',
    phoneNumber: '-',
    address: '-',
  );

  factory CustomerModel.empty() {
    return CustomerModel(
      id: 0,
      nameCustomer: 'Pelanggan Umum',
      phoneNumber: '-',
      address: '-',
    );
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      nameCustomer: json['name_customer'] ?? '',
      phoneNumber: json['phone_number'],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_customer': nameCustomer,
      'phone_number': phoneNumber,
      'address': address,
    };
  }

  bool get isDefault => id == 0;
}
