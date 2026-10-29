class UserModel {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  // Factory untuk merubah JSON dari Laravel ke Object UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Merubah Object UserModel kembali ke JSON/Map (jika dibutuhkan)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': username,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
