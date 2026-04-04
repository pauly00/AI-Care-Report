import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class CommonLoading extends StatelessWidget {
  final String message;

  const CommonLoading({
    super.key,
    this.message = '데이터를 불러오고 있습니다!',
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFFB5457),
            ),
          ),
          SizedBox(height: responsive.itemSpacing),
          Text(
            '잠시만 기다려주세요.\n$message',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.fontBase,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
