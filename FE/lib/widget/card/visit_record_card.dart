import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

/// 방문 기록을 표시하는 카드 위젯
/// 사용자가 탭하면 상세 페이지로 이동할 수 있음
class VisitRecordCard extends StatelessWidget {
  final int id; // 방문 기록 고유 ID (백엔드 연동 필요)
  final String name; // 방문지 이름
  final String address; // 방문지 주소
  final bool isTablet; // 태블릿 여부에 따른 UI 조정
  final VoidCallback? onTap; // 카드 클릭 시 실행될 콜백 함수

  const VisitRecordCard({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    this.isTablet = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // 반응형 디자인을 위한 크기 조정
    final cardPadding =
        isTablet ? responsive.cardSpacing * 1.2 : responsive.cardSpacing;
    final fontSizeTitle =
        isTablet ? responsive.fontBase + 2 : responsive.fontBase;
    final fontSizeSub =
        isTablet ? responsive.fontSmall + 1 : responsive.fontSmall;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 방문지 이름 표시
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: responsive.itemSpacing * 0.5),
                  // 방문지 주소 표시
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: fontSizeSub,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            // 오른쪽 화살표 아이콘 (클릭 가능함을 시각적으로 표현)
            Icon(
              Icons.chevron_right,
              size: isTablet ? 50 : 28,
              color: Colors.red.shade300,
            ),
          ],
        ),
      ),
    );
  }
}