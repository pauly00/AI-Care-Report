import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class RecentCard2 extends StatelessWidget {
  final String title;
  final int count;
  final String subtitle;
  final String iconEmoji;

  const RecentCard2({
    super.key,
    required this.title,
    required this.count,
    required this.subtitle,
    required this.iconEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      width: responsive.cardWidth,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD8DA).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 상단 텍스트 부분
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.fontBase,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFB5457),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFB5457),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: responsive.fontSmall,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: responsive.fontSmall,
              color: const Color(0xFFB3A5A5),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              iconEmoji,
              style: TextStyle(
                fontSize: responsive.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
