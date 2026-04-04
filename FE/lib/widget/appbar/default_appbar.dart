import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/mypage/mypage.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing; // 오른쪽 위젯 추가

  const DefaultAppBar({super.key, required this.title,
  this.trailing}); // 선택 파라미터 추가

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      color: const Color(0xFFFFFFFF),
      padding: EdgeInsets.symmetric(vertical: responsive.itemSpacing),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment:
              title == "안심하이" ? Alignment.centerLeft : Alignment.center,
        child: Padding(
          padding: title == "안심하이"
              ? const EdgeInsets.only(left: 20.0)
              : EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logoicon.png',
                    width: responsive.iconSize,
                    height: responsive.iconSize,
                  ),
                  SizedBox(width: responsive.itemSpacing / 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: title == "안심하이"
                          ? const Color(0xFFFB5457)
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontLarge,
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),

          // 오른쪽 빨간 동그라미 (Flutter 내장) - 클릭 가능하도록 수정
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // 2번 문제 해결을 위한 일관된 여백
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyPage()),
                  );
                },
                borderRadius: BorderRadius.circular(20), // 원형 터치 영역
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // 이미지의 배경색과 유사한 색상
                    color: const Color(0xFFFEEEEE),
                    shape: BoxShape.circle,
                    // 빨간색 테두리 추가
                    border: Border.all(
                      color: const Color(0xFFFB5457), // 테두리 색상
                      width: 2.0,                      // 테두리 두께
                    ),
                  ),
                  // 이미지가 원형 테두리를 벗어나지 않도록 ClipOval 사용
                  child: ClipOval(
                    child: Padding(
                      // 아이콘이 꽉 차지 않도록 약간의 내부 여백 적용
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(
                        'assets/images/profile.png', // 사람 아이콘 PNG 경로
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.itemSpacing), // 오른쪽 여백
        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}