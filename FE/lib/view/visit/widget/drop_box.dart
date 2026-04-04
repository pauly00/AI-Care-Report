import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class DropdownCard extends StatefulWidget {
  final String title; // 드롭박스 제목
  final Widget content; // 드롭박스 내용 (다양한 디자인 가능)

  const DropdownCard({super.key, required this.title, required this.content});

  @override
  State<DropdownCard> createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
  bool isExpanded = false; // 드롭박스 열림/닫힘 상태 관리

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD8DA).withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title, // 제목 표시
              style: TextStyle(
                fontSize: responsive.fontBase,
                color: Color(0xFFB3A5A5),
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: responsive.fontXL,
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // 클릭 시 열림/닫힘 상태 전환
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: widget.content, // 각기 다른 디자인의 content 표시
            ),
        ],
      ),
    );
  }
}
