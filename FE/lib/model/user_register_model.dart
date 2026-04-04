class UserRegisterModel {
  final String name;
  final String phoneNumber;
  final String email;
  final String birthdate;
  final int gender;
  final String password;

  UserRegisterModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthdate,
    required this.gender,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "email": email,
      "birthdate": birthdate,
      "gender": gender,
      "password": password,
    };
  }
}
