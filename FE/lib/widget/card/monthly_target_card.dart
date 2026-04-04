import 'package:flutter/material.dart';
import 'package:safe_hi/model/monthly_report_item.dart';

/// 월별 리포트 생성 상태를 표시하는 카드 위젯
/// - 생성 완료: 클릭 시 리포트 보기 가능
/// - 생성 중: 로딩 스피너 표시
/// - 미생성: 생성하기 버튼 표시
class MonthlyTargetCard extends StatelessWidget {
  const MonthlyTargetCard({
    super.key,
    required this.item,
    required this.userName,
    required this.isHighlighted,
    required this.isLoading,
    required this.onGenerate,
    required this.onViewReport,
  });

  final MonthlyReportItem item;
  final String userName; // TODO: 백엔드 연동 - 실제 사용자명으로 대체 필요
  final bool isHighlighted;
  final bool isLoading;
  final VoidCallback onGenerate; // 리포트 생성 콜백
  final VoidCallback onViewReport; // 리포트 보기 콜백

  // 색상 상수
  static const Color _primaryRed = Color(0xFFFB5457);
  static const Color _titleGray  = Color(0xFF4A4A4A);
  static const Color _borderGray = Color(0xFFE9E9E9);
  static const Color _doneGreen  = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final borderColor = isHighlighted ? _primaryRed : _borderGray;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isHighlighted
            ? [
          BoxShadow(
            color: _primaryRed.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 연/월 표시 영역
            SizedBox(
              width: 68,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.year}년',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 2),
                  Text(
                    '${item.month}월',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // 리포트 제목
            Expanded(
              child: Text(
                '$userName님의 ${item.month}월 통합 리포트', // TODO: API 연동 필요
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _titleGray,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 상태별 액션 버튼 (우선순위: 생성완료 > 로딩중 > 생성하기)
            item.generated
                ? InkWell(
                    onTap: onViewReport,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _doneGreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '생성 완료',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : isLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(_primaryRed),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '생성 중...',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: onGenerate,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(Icons.refresh, color: _primaryRed, size: 22),
                              SizedBox(width: 6),
                              Text(
                                '생성하기',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: _primaryRed,
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
}
