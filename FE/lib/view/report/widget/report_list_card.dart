import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/id/report_id.dart';
import 'package:safe_hi/view/report/report_1.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/util/responsive.dart';

class ReportListCard extends StatelessWidget {
  final ReportTarget target;

  const ReportListCard({
    super.key,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.cardSpacing),
      margin: EdgeInsets.only(bottom: responsive.itemSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD8DA).withAlpha(80),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽: 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target.targetName,
                  style: TextStyle(
                    fontSize: responsive.fontBase,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.itemSpacing / 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📍 주소: ',
                      style: TextStyle(
                        fontSize: responsive.fontSmall,
                        color: const Color(0xFFB3A5A5),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        target.address1,
                        style: TextStyle(
                          fontSize: responsive.fontSmall,
                          color: const Color(0xFFB3A5A5),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.itemSpacing / 2),
                Text(
                  '🕒 최근 방문: ${target.visitTime}',
                  style: TextStyle(
                    fontSize: responsive.fontSmall,
                    color: const Color(0xFFB3A5A5),
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽: 버튼
          ElevatedButton.icon(
            onPressed: () {
              context.read<ReportIdProvider>().setReportId(target.reportId);
              final reportVM = context.read<ReportViewModel>();
              reportVM.setSelectedTarget(target);

              debugPrint("ReportListCard > 설정할 대상: $target");
              debugPrint(
                  "현재 Provider에서 읽은 selectedTarget: ${reportVM.selectedTarget}");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Report1(),
                ),
              );
            },
            icon: Icon(Icons.edit_note, size: responsive.iconSize * 0.6),
            label: Text(
              "작성",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.fontSmall,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFFB5457),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.itemSpacing * 1.4,
                vertical: responsive.itemSpacing,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
