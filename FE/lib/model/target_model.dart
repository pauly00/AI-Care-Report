class Target {
  final int targetId;
  final String targetName;
  final String address1;
  final String address2;
  final String callNum;
  final int gender;
  final int age;

  Target({
    required this.targetId,
    required this.targetName,
    required this.address1,
    required this.address2,
    required this.callNum,
    required this.gender,
    required this.age,
  });

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      targetId: json['targetid'] ?? 0,
      targetName: json['targetname'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      callNum: json['targetcallnum'] ?? json['callnum'] ?? '',
      gender: json['gender'] ?? 0,
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetname': targetName,
      'address1': address1,
      'address2': address2,
      'callnum': callNum,
      'gender': gender,
      'age': age,
    };
  }
}
