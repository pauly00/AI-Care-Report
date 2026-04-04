import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class BottomTwoButton extends StatelessWidget {
  final String buttonText1;
  final String buttonText2;
  final VoidCallback? onButtonTap1;
  final VoidCallback? onButtonTap2;

  const BottomTwoButton({
    super.key,
    required this.buttonText1,
    required this.buttonText2,
    this.onButtonTap1,
    this.onButtonTap2,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      color: const Color(0xFFFFFFFF),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.paddingHorizontal,
        vertical: responsive.itemSpacing,
      ),
      child: Row(
        children: [
          // 첫 번째 버튼 - 화면의 절반 차지
          Expanded(
            child: ElevatedButton(
              onPressed: onButtonTap1,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFFFB5457),
                  width: 2,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: responsive.isTablet ? 22 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                buttonText1,
                style: TextStyle(
                  color: const Color(0xFFFB5457),
                  fontSize: responsive.fontBase,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // 버튼 사이 간격 15px
          const SizedBox(width: 15),
          
          // 두 번째 버튼 - 화면의 절반 차지
          Expanded(
            child: ElevatedButton(
              onPressed: onButtonTap2,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB5457),
                padding: EdgeInsets.symmetric(
                  vertical: responsive.isTablet ? 22 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                buttonText2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.fontBase,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
