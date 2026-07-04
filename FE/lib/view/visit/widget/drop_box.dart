import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class DropdownCard extends StatefulWidget {
  final String title;
  final Widget content;

  const DropdownCard({super.key, required this.title, required this.content});

  @override
  State<DropdownCard> createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
  bool isExpanded = false;

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
              widget.title,
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
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: widget.content,
            ),
        ],
      ),
    );
  }
}
