import 'package:flutter/material.dart';

class RecentCard extends StatelessWidget {
  final String title;
  final int count;
  final String subtitle;

  const RecentCard({
    super.key,
    required this.title,
    required this.count,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 75,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFDD8DA).withValues(alpha: 0.5), // 그림자
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0), // 그림자 위치
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFB5457),
                    ),
                  ),
                  const SizedBox(width: 5), // 제목과 숫자 간격
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFB5457),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFFB3A5A5)),
          ),
        ],
      ),
    );
  }
}
