class UserModel {
  final int userId;
  final String name;
  final String phoneNumber;
  final String email;
  final String birthDate;
  final int gender;
  final String etc;
  final int? role;

  UserModel({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.etc,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthdate'] ?? '',
      gender: int.tryParse(json['gender'].toString()) ?? 0,
      etc: json['etc'] ?? '',
      role: json['role'] != null ? int.tryParse(json['role'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'birthdate': birthDate,
      'gender': gender,
      'etc': etc,
      'role': role,
    };
  }
}
