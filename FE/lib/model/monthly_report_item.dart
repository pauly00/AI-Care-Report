// 월/연도/생성여부를 담는 데이터 모델
class MonthlyReportItem {
  final int year;
  final int month;
  final bool generated; // 생성 완료 여부

  const MonthlyReportItem({
    required this.year,
    required this.month,
    required this.generated,
  });
}
