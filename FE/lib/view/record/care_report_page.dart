import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/care_report_detail.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';

class CareReportPage extends StatefulWidget {
  const CareReportPage({super.key});

  @override
  State<CareReportPage> createState() => _CareReportPageState();
}

class _CareReportPageState extends State<CareReportPage> {
  // 선택된 필터 버튼 상태 (0: 모두 선택, 1: 방문돌봄, 2: 전화돌봄)
  int _selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);
    final reportVM = context.watch<ReportViewModel>();

    // DB 리포트 목록
    final visits = _filteredReports(reportVM.targets);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 앱바
            const DefaultAppBar(title: '돌봄 기록'),

            // 메인 콘텐츠 영역
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: rs.sectionSpacing),

                    // 검색창과 정렬 버튼
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '대상자 이름 검색',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: const Center(
                            child: Text(
                              '최신순',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 돌봄 유형 필터 버튼
                    Row(
                      children: [
                        // 모두 선택 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '모두 선택',
                            index: 0,
                            isSelected: _selectedButton == 0,
                            onPressed: () => setState(() => _selectedButton = 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 방문돌봄 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '방문돌봄',
                            index: 1,
                            isSelected: _selectedButton == 1,
                            onPressed: () => setState(() => _selectedButton = 1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 전화돌봄 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '전화돌봄',
                            index: 2,
                            isSelected: _selectedButton == 2,
                            onPressed: () => setState(() => _selectedButton = 2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 돌봄 기록 리스트
                    Expanded(
                      child: reportVM.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : visits.isEmpty
                              ? const Center(child: Text('표시할 돌봄 기록이 없습니다.'))
                              : ListView.separated(
                                  itemCount: visits.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final report = visits[index];
                                    final type = _visitTypeLabel(report);
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<ReportViewModel>().setSelectedTarget(report);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CareReportDetail(
                                              name: report.targetName,
                                              count: index + 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: const Color(0xFFE0E0E0)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _displayDate(report.visitTime),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${report.targetName} 돌봄일지',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: type == '방문'
                                                    ? const Color(0xFFD32F2F)
                                                    : const Color(0xFFE65100),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                type,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.chevron_right,
                                                color: Colors.black54),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ReportTarget> _filteredReports(List<ReportTarget> reports) {
    final filtered = reports.where((report) {
      if (_selectedButton == 1) return report.visitType == 1;
      if (_selectedButton == 2) return report.visitType == 0;
      return true;
    }).toList();

    filtered.sort((a, b) => b.visitTime.compareTo(a.visitTime));
    return filtered;
  }

  String _visitTypeLabel(ReportTarget report) {
    if (report.visitType == 0) return '전화';
    return '방문';
  }

  String _displayDate(String visitTime) {
    if (visitTime.length >= 10) {
      return visitTime.substring(0, 10).replaceAll('-', '.');
    }
    return visitTime.isEmpty ? '일정 미정' : visitTime;
  }

  // 필터 토글 버튼 위젯
  Widget _buildToggleButton({
    required String text,
    required int index,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return isSelected
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB5457),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFB5457),
              side: const BorderSide(color: Color(0xFFFB5457), width: 1.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
          );
  }
}
