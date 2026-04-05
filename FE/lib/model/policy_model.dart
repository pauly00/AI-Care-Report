class PolicyModel {
  final int policyId;
  final int age;
  final String region;

  PolicyModel({
    required this.policyId,
    required this.age,
    required this.region,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      policyId: json['policyId'] ?? json['id'] ?? 0,
      age: json['age'] ?? 0,
      region: json['region'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'region': region,
    };
  }
}
