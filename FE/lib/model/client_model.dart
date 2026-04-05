class ClientModel {
  final int clientId;
  final String name;
  final String address;
  final String phoneNumber;

  ClientModel({
    required this.clientId,
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientId: json['clientId'] ?? json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}
