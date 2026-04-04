import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view/report/report_2.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/repository/visit_summary_repository.dart';
import 'package:safe_hi/view_model/visit_summary_view_model.dart';
import 'package:safe_hi/service/visit_summary_service.dart';

// 미사용 코드

class Report1_3 extends StatefulWidget {
  const Report1_3({super.key});

  @override
  State<Report1_3> createState() => _Report1_3State();
}

class _Report1_3State extends State<Report1_3> {
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
                      stepTitle: 'step 1.3',
                      stepSubtitle: '기본 정보 확인',
                    ),

                    const SizedBox(height: 20),

                    // 종합정책 제목
                    Text('종합정책',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.fontLarge)),
                    const SizedBox(height: 32),

                    // 추천정책 1
                    Text(
                      '추천정책 1',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          SizedBox(height: 8),
                          Text(
                            '노인 무릎 인공관절 수술 지원사업',
                            style: TextStyle(color: Color(0xFFFB5457), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text('정책 개요', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 거동이 불편한 노인의 일상생활을 지원하기 위해 무릎관절 수술비를 지원'),
                          SizedBox(height: 12),
                          Text('세부 설명', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 대상: 만 60세 이상 저소득층'),
                          Text('- 지원내용: 인공관절 수술비 최대 120만원까지 지원'),
                          Text('- 병원비 부담 완화에 기여'),
                          SizedBox(height: 12),
                          Text('추천 이유', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 상담 시 무릎 통증과 보행 어려움을 언급함'),
                          Text('- 실제 생활에서의 불편함이 건강 악화로 이어질 가능성이 있음'),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // 추천정책 2
                    Text(
                      '추천정책 2',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          SizedBox(height: 8),
                          Text(
                            '노인 무릎 인공관절 수술 지원사업',
                            style: TextStyle(color: Color(0xFFFB5457), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text('정책 개요', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 거동이 불편한 노인의 일상생활을 지원하기 위해 무릎관절 수술비를 지원'),
                          SizedBox(height: 12),
                          Text('세부 설명', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 대상: 만 60세 이상 저소득층'),
                          Text('- 지원내용: 인공관절 수술비 최대 120만원까지 지원'),
                          Text('- 병원비 부담 완화에 기여'),
                          SizedBox(height: 12),
                          Text('추천 이유', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('- 상담 시 무릎 통증과 보행 어려움을 언급함'),
                          Text('- 실제 생활에서의 불편함이 건강 악화로 이어질 가능성이 있음'),
                        ],
                      ),
                    ),
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
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => VisitSummaryViewModel(
                          repository: VisitSummaryRepository(
                            service: VisitSummaryService(),
                          ),
                        ),
                        child: const Report2(),
                      ),
                    ),
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