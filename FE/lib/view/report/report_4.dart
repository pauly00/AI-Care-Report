import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/report/report_5.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

// 미사용 코드

class Report4 extends StatefulWidget {
  const Report4({super.key});

  @override
  State<Report4> createState() => _Report4State();
}

class _Report4State extends State<Report4> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportStepHeader(
                      currentStep: 4,
                      totalSteps: 6,
                      stepTitle: 'step 4',
                      stepSubtitle: '특이사항 작성',
                    ),
                    SizedBox(height: responsive.sectionSpacing * 1.5),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      padding: EdgeInsets.all(responsive.cardSpacing),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFDD8DA),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _controller,
                        maxLines: null,
                        style: TextStyle(fontSize: responsive.fontBase),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '특이사항을 작성해주세요.',
                          hintStyle: TextStyle(fontSize: responsive.fontSmall),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.sectionSpacing * 1.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomTwoButton(
            buttonText1: '이전',
            buttonText2: '다음'.padLeft(14).padRight(28),
            onButtonTap1: () {
              Navigator.pop(context); // 이전 화면으로 돌아가기
            },
            onButtonTap2: () async {
              final reportId =
                  context.read<ReportViewModel>().selectedTarget?.reportId;
              String detailText = _controller.text.trim();

              if (reportId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('리포트 ID가 없습니다.')),
                );
                return;
              }

              // ✅ 빈 값이면 '-'으로 설정
              if (detailText.isEmpty) {
                detailText = '-';
              }

              try {
                await context.read<ReportViewModel>().uploadVisitDetail(
                      reportId,
                      detailText,
                    );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Report5()),
                );
              } catch (e) {
                debugPrint('❌ 특이사항 전송 실패: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('전송 실패: $e')),
                );
              }
            }),
      ),
    );
  }
}
