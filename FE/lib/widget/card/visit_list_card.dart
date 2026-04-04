import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/id/report_id.dart';
import 'package:safe_hi/util/format_time.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/visit/visit_detail_page.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';

/// 방문 목록 카드 위젯
/// 방문 기록의 기본 정보(시간, 이름, 주소)를 표시하고 상세 페이지로 이동
class VisitCard extends StatelessWidget {
  final int id;
  final String time; // 방문 시간 - API 연동 필요
  final String name; // 방문자/장소 이름 - API 연동 필요
  final String address; // 기본 주소 - API 연동 필요
  final String addressDetails; // 상세 주소 - API 연동 필요

  const VisitCard({
    super.key,
    required this.id,
    required this.time,
    required this.name,
    required this.address,
    required this.addressDetails,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return GestureDetector(
      onTap: () {
        // 선택된 리포트 ID를 전역 상태로 저장
        context.read<ReportIdProvider>().setReportId(id);

        // 방문 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VisitDetailPage(
              reportId: id,
              viewModel: context.read<VisitViewModel>(),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(responsive.sectionSpacing),
        margin: EdgeInsets.only(bottom: responsive.sectionSpacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFFFFF).withAlpha(80),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이름과 시간을 양쪽 끝에 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: responsive.fontBase,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatTime(time), // 시간 포맷팅 유틸 사용
                  style: TextStyle(
                    fontSize: responsive.fontBase - 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // 기본 주소
            Text(
              address,
              style: TextStyle(
                fontSize: responsive.fontSmall,
                color: const Color(0xFFB3A5A5),
              ),
            ),
            // 상세 주소
            Text(
              addressDetails,
              style: TextStyle(
                fontSize: responsive.fontSmall,
                color: const Color(0xFFB3A5A5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}