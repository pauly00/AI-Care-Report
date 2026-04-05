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
      reportId: json['reportid'] is int ? json['reportid'] : 0,
      reportStatus: json['reportstatus'] is int ? json['reportstatus'] : 0,
      time: json['visittime'] ?? '',
      visitType: parsedVisitType,
      targetId: target['targetid'] is int ? target['targetid'] : 0,
      name: target['targetname'] ?? '',
      address: target['address1'] ?? '',
      addressDetails: target['address2'] ?? '',
      phone: target['targetcallnum'] ?? target['callnum'] ?? '',
      age: target['age'] is int ? target['age'] : 0,
      gender: target['gender'] is int ? target['gender'] : 0,
    );
  }
}
