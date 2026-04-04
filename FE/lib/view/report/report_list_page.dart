import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/report/widget/report_list_card.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/loading/common_loading.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/util/responsive.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: Consumer<ReportViewModel>(
                builder: (context, reportVM, _) {
                  final targets = reportVM.targets;

                  if (reportVM.isLoading) {
                    return const CommonLoading(message: "리포트 대상자 정보를 찾고 있습니다!");
                  } else if (targets.isEmpty) {
                    return Center(
                      child: Text(
                        "작성할 리포트가 없습니다.",
                        style: TextStyle(fontSize: responsive.fontBase),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.paddingHorizontal),
                      itemCount: targets.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: responsive.itemSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '📝 아직 제출되지 않은 리포트 목록입니다.',
                                  style: TextStyle(
                                    fontSize: responsive.fontBase,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: responsive.itemSpacing / 2),
                                Text(
                                  '방문을 완료하셨다면, 리포트를 꼭 제출해주세요!',
                                  style: TextStyle(
                                    fontSize: responsive.fontSmall,
                                    color: const Color(0xFFB3A5A5),
                                  ),
                                ),
                                SizedBox(height: responsive.itemSpacing),
                              ],
                            ),
                          );
                        }

                        final target = targets[index - 1];
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: responsive.itemSpacing),
                          child: ReportListCard(target: target),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
