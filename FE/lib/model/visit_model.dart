class Visit {
  final int reportId;
  final int reportStatus;
  final String time;
  final int? visitType;
  final int targetId;
  final String name;
  final String address;
  final String addressDetails;
  final String phone;
  final int gender;
  final int age;

  Visit({
    required this.reportId,
    required this.reportStatus,
    required this.time,
    required this.visitType,
    required this.targetId,
    required this.name,
    required this.address,
    required this.addressDetails,
    required this.phone,
    required this.gender,
    required this.age,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    final target = json['targetInfo'] ?? {};
    final dynamic rawVisitType = json['visitType'] ?? json['visittype'];
    int? parsedVisitType;
    if (rawVisitType is int) {
      parsedVisitType = rawVisitType;
    } else if (rawVisitType is String) {
      parsedVisitType = int.tryParse(rawVisitType);
    }

    return Visit(
      reportId: _readInt(json['reportid']),
      reportStatus: _readInt(json['reportstatus']),
      time: json['visittime'] ?? '',
      visitType: parsedVisitType,
      targetId: _readInt(target['targetid']),
      name: target['targetname'] ?? json['name'] ?? json['targetname'] ?? '',
      address: target['address1'] ?? json['address'] ?? json['address1'] ?? '',
      addressDetails: target['address2'] ?? json['address2'] ?? '',
      phone: target['targetcallnum'] ??
          target['callnum'] ??
          json['callNum'] ??
          json['targetcallnum'] ??
          json['callnum'] ??
          '',
      age: _readInt(target['age']),
      gender: _readInt(target['gender']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
