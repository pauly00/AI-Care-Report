class ReportTarget {
  final int reportId;
  final int reportStatus;
  final String visitTime;
  final int targetId;
  final String targetName;
  final String address1;
  final String address2;
  final String phone;
  final int gender;
  final int age;

  ReportTarget({
    required this.reportId,
    required this.reportStatus,
    required this.visitTime,
    required this.targetId,
    required this.targetName,
    required this.address1,
    required this.address2,
    required this.phone,
    required this.gender,
    required this.age,
  });

  ReportTarget copyWith({
    int? reportId,
    int? reportStatus,
    String? visitTime,
    int? targetId,
    String? targetName,
    String? address1,
    String? address2,
    String? phone,
    int? gender,
    int? age,
  }) {
    return ReportTarget(
      reportId: reportId ?? this.reportId,
      reportStatus: reportStatus ?? this.reportStatus,
      visitTime: visitTime ?? this.visitTime,
      targetId: targetId ?? this.targetId,
      targetName: targetName ?? this.targetName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  factory ReportTarget.fromJson(Map<String, dynamic> json) {
    final target = json['targetInfo'] ?? {};

    return ReportTarget(
      reportId: json['reportid'] ?? 0,
      reportStatus: json['reportstatus'] ?? 0,
      visitTime: json['visittime'] ?? '',
      targetId: target['targetid'] ?? 0,
      targetName: target['targetname'] ?? '',
      address1: target['address1'] ?? '',
      address2: target['address2'] ?? '',
      phone: target['targetcallnum'] ?? '',
      gender: target['gender'] ?? 0,
      age: target['age'] ?? 0,
    );
  }
}
