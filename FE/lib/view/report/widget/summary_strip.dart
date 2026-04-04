import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

// 요약 아이템 데이터 모델
class SummaryItem {
  const SummaryItem({required this.icon, required this.label, required this.count});
  final IconData icon;
  final String label;
  final int count;
}

// 요약 아이템 리스트
class SummaryStrip extends StatelessWidget {
  const SummaryStrip({
    super.key,
    required this.r,
    required this.totalTarget,
    required this.totalReport,
    required this.items,
  });

  final Responsive r;
  final int totalTarget;
  final int totalReport;
  final List<SummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.itemSpacing),
      decoration: BoxDecoration(
        color: const Color(0xFFFB5457),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              padding: EdgeInsets.all(r.itemSpacing * 0.9),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7B80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryLine('대상자', '$totalTarget명', r),
                  const SizedBox(height: 8),
                  Container(height: 1, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(height: 8),
                  _summaryLine('리포트', '$totalReport건', r),
                ],
              ),
            ),
          ),
          SizedBox(width: r.itemSpacing),
          for (int i = 0; i < items.length; i++)
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(left: i == 0 ? 0 : r.itemSpacing / 2),
                padding: EdgeInsets.symmetric(vertical: r.itemSpacing * 0.9),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i].icon, color: const Color(0xFFFB5457)),
                    const SizedBox(height: 6),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: r.fontSmall,
                        color: const Color(0xFFFB5457),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${items[i].count}건',
                      style: TextStyle(
                        fontSize: r.fontSmall,
                        color: const Color(0xFFB24A4C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 요약 라인 위젯
  Widget _summaryLine(String k, String v, Responsive r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: TextStyle(color: Colors.white, fontSize: r.fontSmall)),
        Text(
          v,
          style: TextStyle(
            color: Colors.white,
            fontSize: r.fontBase,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
