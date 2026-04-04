class VisitDetail {
  final int targetId;
  final String name;
  final String address;
  final String addressDetails;
  final String phone;
  final int gender;
  final int age;
  final List<LastVisit> lastVisits;

  VisitDetail({
    required this.targetId,
    required this.name,
    required this.address,
    required this.addressDetails,
    required this.phone,
    required this.gender,
    required this.age,
    required this.lastVisits,
  });

  factory VisitDetail.fromJson(Map<String, dynamic> json) {
    return VisitDetail(
      targetId: json['targetid'],
      name: json['targetname'],
      address: json['address1'],
      addressDetails: json['address2'],
      phone: json['targetcallnum'],
      gender: json['gender'],
      age: json['age'],
      lastVisits: (json['lastvisit'] as List)
          .map((v) => LastVisit.fromJson(v))
          .toList(),
    );
  }
}

class LastVisit {
  final String date;
  final String abstract;

  LastVisit({required this.date, required this.abstract});

  factory LastVisit.fromJson(Map<String, dynamic> json) {
    return LastVisit(
      date: json['date'],
      abstract: json['abstract'],
    );
  }
}
