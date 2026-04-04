import 'package:flutter/material.dart';
import 'package:safe_hi/model/monthly_report_item.dart';
import 'package:safe_hi/view/report/report_1_new.dart';
import 'package:safe_hi/widget/card/monthly_target.dart';

class MonthlyTargetPage extends StatefulWidget {
  const MonthlyTargetPage({
    super.key,
    required this.name, // name 매개변수
    required this.address, // address 매개변수 추가
  });

  final String name; // name 필드
  final String address; // address 필드 추가

  @override
  State<MonthlyTargetPage> createState() => _MonthlyTargetPageState();
}

class _MonthlyTargetPageState extends State<MonthlyTargetPage> {
  // 더미 월간 리포트 데이터 - 추후 API 연동 필요
  List<MonthlyReportItem> items = [
    const MonthlyReportItem(year: 2025, month: 9, generated: false), // 상단 강조
    const MonthlyReportItem(year: 2025, month: 8, generated: true),
    const MonthlyReportItem(year: 2025, month: 7, generated: true),
    const MonthlyReportItem(year: 2025, month: 6, generated: true),
    const MonthlyReportItem(year: 2025, month: 5, generated: true),
  ];

  // 로딩 상태 추적
  Set<String> loadingItems = {};

  /// 리포트 생성 함수
  Future<void> _generateReport(MonthlyReportItem item) async {
    final itemKey = '${item.year}-${item.month}';

    // 로딩 시작
    setState(() {
      loadingItems.add(itemKey);
    });

    // 더미 지연 처리 - 추후 실제 API 호출로 교체 필요
    await Future.delayed(const Duration(seconds: 2));

    // 해당 아이템을 generated: true로 변경
    setState(() {
      final index = items.indexWhere(
          (i) => i.year == item.year && i.month == item.month);
      if (index != -1) {
        items[index] = MonthlyReportItem(
          year: item.year,
          month: item.month,
          generated: true, // 생성 완료로 변경
        );
      }
      loadingItems.remove(itemKey); // 로딩 상태 제거
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MonthlyTarget(
        name: widget.name, // 전달받은 name 사용
        items: items,
        loadingItems: loadingItems, // 로딩 상태 전달
        onBack: () => Navigator.of(context).maybePop(),
        onSeeTargets: () => Navigator.of(context).maybePop(), // 뒤로가기와 동일한 동작
        onGenerate: _generateReport, // 생성 함수 연결
        onViewReport: () {
          // 생성완료 클릭 시 상세 리포트로 이동 - name과 address 전달
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Report1New(
                targetName: widget.name, // MonthlyTargetPage에서 받은 name 전달
                address: widget.address, // MonthlyTargetPage에서 받은 address 전달
              ),
            ),
          );
        },
      ),
    );
  }
}