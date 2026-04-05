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

  static int _parseVisitType(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    return 1;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return '';
  }

  factory TodayVisit.fromJson(Map<String, dynamic> json) {
    return TodayVisit(
      reportid: json['reportid'] is int
          ? json['reportid'] as int
          : int.tryParse('${json['reportid']}') ?? 0,
      visitTime: _readString(json, ['visitTime', 'visittime']),
      visitType: _parseVisitType(json['visitType'] ?? json['visittype']),
      address: _readString(json, ['address', 'address1']),
      name: _readString(json, ['name', 'targetname']),
      callNum: _readString(json, ['callNum', 'targetcallnum', 'callnum']),
    );
  }
}