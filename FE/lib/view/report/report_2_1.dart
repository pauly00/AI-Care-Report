import 'package:flutter/material.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view/report/report_2.dart';
import 'package:safe_hi/util/responsive.dart';

// 미사용 코드

class Report2_1 extends StatefulWidget {
  const Report2_1({super.key});

  @override
  State<Report2_1> createState() => _Report2_1State();
}

class _Report2_1State extends State<Report2_1> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 상단 뒤로가기 + 타이틀
            const DefaultBackAppBar(title: '돌봄 리포트'),

            // ✅ 페이지 본문
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ 단계 헤더
                    const ReportStepHeader(
                      currentStep: 1,
                      totalSteps: 6,
                      stepTitle: 'step 1.1',
                      stepSubtitle: '기본 정보 확인',
                    ),

                    const SizedBox(height: 20),

                    // ... (중간 내용 생략)
                  ],
                ),
              ),
            ),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
              child: BottomOneButton(
                buttonText: '다음(테스트 버튼 -> 2로 이동)',
                onButtonTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Report2()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}