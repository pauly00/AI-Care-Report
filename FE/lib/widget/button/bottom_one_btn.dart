import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class BottomOneButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonTap;
  final bool isEnabled;

  const BottomOneButton({
    super.key,
    required this.buttonText,
    required this.onButtonTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      color: const Color(0xFFFFFFFF),
      padding: EdgeInsets.symmetric(
        vertical: responsive.itemSpacing,
        horizontal: responsive.paddingHorizontal,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? onButtonTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? const Color(0xFFFB5457) : Colors.grey,
            padding: EdgeInsets.symmetric(
              vertical: responsive.isTablet ? 22 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontBase,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
