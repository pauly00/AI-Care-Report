// 오늘 방문 기록을 담는 데이터 모델
class TodayVisit {
  final int reportid;
  final String visitTime;
  final int visitType; // 0: 전화돌봄 1: 현장돌봄
  final String address;
  final String name;
  final String callNum;

  TodayVisit({
    required this.reportid,
    required this.visitTime,
    required this.visitType,
    required this.address,
    required this.name,
    required this.callNum,
  });

  factory TodayVisit.fromJson(Map<String, dynamic> json) {
    return TodayVisit(
      reportid: json['reportid'],
      visitTime: json['visitTime'],
      visitType: json['visitType'],
      address: json['address'],
      name: json['name'],
      callNum: json['callNum'],
    );
  }
}