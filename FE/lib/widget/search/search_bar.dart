import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class VisitSearchBar extends StatelessWidget {
  const VisitSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.itemSpacing,
        vertical: responsive.itemSpacing * 0.6,
      ),
      margin: EdgeInsets.only(bottom: responsive.itemSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFFFFF).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: responsive.iconSize * 0.8,
          ),
          SizedBox(width: responsive.itemSpacing),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: responsive.fontBase),
              decoration: InputDecoration(
                hintText: '검색',
                hintStyle: TextStyle(
                  color: const Color(0xFFB3A5A5),
                  fontSize: responsive.fontSmall + 1,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
