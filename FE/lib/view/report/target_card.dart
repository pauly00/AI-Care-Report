import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/monthly_target_page.dart';
import 'package:safe_hi/view/report/widget/target_card_data.dart';

import '../../widget/card/monthly_target.dart';

/// 대상자 카드 위젯 - 리포트 대상자 정보 표시
class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.r, required this.data});
  final Responsive r;
  final TargetCardData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 카드 클릭 시 월별 대상자 페이지로 이동 - data.name과 data.address 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonthlyTargetPage(
              name: data.name, // data.name 전달
              address: data.address, // data.address 전달
            ),
          ),
        );
      },
      child: Container(
        // 카드 스타일링
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))],
          border: Border.all(color: const Color(0x1AFB5457)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 190;
            final avatarSize = compact ? 64.0 : 92.0;
            final emojiSize = compact ? 30.0 : 42.0;
            final badgeVPad = compact ? 4.0 : 6.0;
            final contentPad = compact ? 12.0 : 16.0;
            final nameFont = compact ? r.fontBase : r.fontM;
            final addressMaxLines = compact ? 1 : 2;

            return Stack(
              children: [
                // 상태 뱃지 (좌측 상단)
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: badgeVPad),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7B80),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      data.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 11 : 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // 카드 메인 콘텐츠
                Padding(
                  padding: EdgeInsets.all(contentPad),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 프로필 이미지 (이모지)
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFF7B80), width: compact ? 3 : 4),
                          ),
                          alignment: Alignment.center,
                          child: Text(data.emoji, style: TextStyle(fontSize: emojiSize)),
                        ),
                        SizedBox(height: compact ? 6 : 10),

                        // 대상자 이름
                        Text(
                          data.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: nameFont,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFB5457),
                          ),
                        ),
                        SizedBox(height: compact ? 4 : 6),

                        // 주소 정보
                        Text(
                          data.address,
                          textAlign: TextAlign.center,
                          maxLines: addressMaxLines,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: r.fontSmall,
                            color: const Color(0xFF8B8B8B),
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
