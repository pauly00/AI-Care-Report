import 'package:flutter/material.dart';
import 'package:safe_hi/model/monthly_report_item.dart';
import 'package:safe_hi/widget/card/monthly_target_card.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';

/// 월간 통합 리포트 메인 화면
/// - 헤더(뒤로가기, 로고+"통합 리포트"), 서브타이틀, 카드 리스트, 하단 버튼으로 구성
class MonthlyTarget extends StatelessWidget {
  const MonthlyTarget({
    super.key,
    required this.name, // userName을 name으로 변경
    required this.items,
    required this.loadingItems,
    required this.onBack,
    required this.onSeeTargets,
    required this.onGenerate,
    required this.onViewReport,
  });

  final String name; // userName을 name으로 변경
  final List<MonthlyReportItem> items;
  final Set<String> loadingItems; // 현재 생성 중인 리포트들의 년-월 정보
  final VoidCallback onBack;
  final VoidCallback onSeeTargets;
  final void Function(MonthlyReportItem) onGenerate; // 리포트 생성 요청
  final VoidCallback onViewReport; // 생성완료된 리포트 조회

  static const Color _primaryRed = Color(0xFFFB5457);
  static const Color _titleGray  = Color(0xFF4A4A4A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            const DefaultBackAppBar(title: '통합 리포트'),

            // 메인 콘텐츠
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사용자별 서브타이틀
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Text(
                      '$name님의 월간 통합 리포트', // userName을 name으로 변경
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _titleGray,
                      ),
                    ),
                  ),

                  // 월별 리포트 카드 리스트
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isFirst = index == 0 && !item.generated; // 최상단 미생성 항목 강조

                        return MonthlyTargetCard(
                          item: item,
                          userName: name, // userName을 name으로 변경
                          isHighlighted: isFirst,
                          isLoading: loadingItems.contains('${item.year}-${item.month}'),
                          onGenerate: () => onGenerate(item),
                          onViewReport: onViewReport,
                        );
                      },
                    ),
                  ),

                  // 하단 대상자 목록 보기 버튼
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onBack, // 뒤로가기와 동일한 동작
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          '대상자 목록 보기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}