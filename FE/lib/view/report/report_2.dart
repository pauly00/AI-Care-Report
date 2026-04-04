import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/report/report_3.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/view_model/visit_summary_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/model/visit_summary_model.dart'; // 추가(더미값)

// 미사용 코드

class Report2 extends StatefulWidget {
  const Report2({super.key});

  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  bool _isEditing = false;
  List<bool> _isExpandedList = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    // 서버 호출 부분(추후 주석 해제)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final reportId = context.read<ReportViewModel>().selectedTarget?.reportId;
    //   if (reportId != null) {
    //     context.read<VisitSummaryViewModel>().fetchSummary(reportId);
    //
    //     debugPrint('📄 Report2 > 전역 상태에서 가져온 reportId: $reportId');
    //   }
    // });

    // 🧪 서버 없는 상황에서만 임시로 세팅
    final vm = context.read<VisitSummaryViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.summaries.isEmpty) {
        vm.summaries = [
          VisitSummary(subject: '건강', abstract: '소화 관련 불편 지속적 호소', detail: '외출 일주일 정도 안함\n누워 있는 것을 매우 선호'),
          VisitSummary(subject: '경제', abstract: '공과금 부담, 경제적 스트레스 존재', detail: '전기세 부담 많음\n절약을 위해 방 불을 잘 안 킴'),
          VisitSummary(subject: '생활', abstract: '외출 빈도 급감, 활동량 저하 및 무기력', detail: '외출 일주일 정도 안함\n누워 있는 것을 매우 선호'),
          VisitSummary(subject: '기타', abstract: '가족과의 거리감, 사회활동 회피', detail: '사회 활동 의욕 저하\n가족과 대화 부족'),
        ];
        vm.isLoading = false; // ✅ setter 사용
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final visitSummaryVM = context.watch<VisitSummaryViewModel>();
    final summaries = visitSummaryVM.summaries;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: visitSummaryVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.paddingHorizontal),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const ReportStepHeader(
                                currentStep: 2,
                                totalSteps: 6,
                                stepTitle: 'step 2',
                                stepSubtitle: '대화 내용 요약',
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: responsive.modifyButton,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: responsive.cardSpacing),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF4F4),
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: Color(0xFFFB5457)),
                                  ),
                                  child: TextButton(
                                    onPressed: () => setState(
                                        () => _isEditing = !_isEditing),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_note_rounded,
                                          size: responsive.iconSize * 0.6,
                                          color: const Color(0xFFFB5457),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '수정',
                                          style: TextStyle(
                                              fontSize: responsive.fontSmall,
                                              color: const Color(0xFFFB5457)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: responsive.sectionSpacing),
                          Container(
                            padding: EdgeInsets.all(responsive.cardSpacing),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xFFFDD8DA),
                                    blurRadius: 4,
                                    offset: Offset(0, 0)),
                              ],
                            ),
                            child: Column(
                              children:
                                  List.generate(summaries.length, (index) {
                                final summary = summaries[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('[${summary.subject}]',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: responsive.fontBase)),
                                    SizedBox(
                                        height: responsive.itemSpacing / 2),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isExpandedList[index] =
                                              !_isExpandedList[index];
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(
                                            responsive.itemSpacing * 1.2),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFEBE7E7)),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: _isEditing
                                                      ? TextFormField(
                                                          initialValue:
                                                              summary.abstract,
                                                          onChanged: (value) =>
                                                              summary.abstract =
                                                                  value,
                                                          decoration:
                                                              const InputDecoration
                                                                  .collapsed(
                                                                  hintText:
                                                                      '요약 내용을 입력하세요'),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  responsive
                                                                      .fontSmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(
                                                          summary.abstract,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  responsive
                                                                      .fontSmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _isExpandedList[index]
                                                          ? '접기'
                                                          : '자세히',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .fontSmall,
                                                          color: Colors.grey),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Transform.rotate(
                                                      angle:
                                                          _isExpandedList[index]
                                                              ? 3.14
                                                              : 0,
                                                      child: const Icon(
                                                          Icons.arrow_drop_down,
                                                          size: 18,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            if (_isExpandedList[index])
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        responsive.itemSpacing),
                                                child: _isEditing
                                                    ? TextFormField(
                                                        initialValue:
                                                            summary.detail,
                                                        onChanged: (value) =>
                                                            summary.detail =
                                                                value,
                                                        maxLines: null,
                                                        decoration:
                                                            const InputDecoration
                                                                .collapsed(
                                                                hintText:
                                                                    '세부 내용을 입력하세요'),
                                                      )
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: summary.detail
                                                            .split('\n')
                                                            .map((e) => Text(
                                                                '\u2022 $e',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        responsive
                                                                            .fontSmall)))
                                                            .toList(),
                                                      ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: responsive.itemSpacing),
                                  ],
                                );
                              }),
                            ),
                          )
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
          buttonText2: _isEditing
              ? '저장'.padLeft(14).padRight(28)
              : '다음'.padLeft(14).padRight(28),
          onButtonTap1: () {
            Navigator.pop(context);
          },
          onButtonTap2: () async {
            if (_isEditing) {
              setState(() => _isEditing = false);
              return;
            }

            // 서버 호출 부분(추후 주석 해제)
            // final reportId =
            //     context.read<ReportViewModel>().selectedTarget?.reportId;
            // if (reportId == null) return;
            //
            // try {
            //   await context
            //       .read<VisitSummaryViewModel>()
            //       .uploadAllSummaries(reportId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => VisitPolicyViewModel(),
                    child: const Report3(),
                  ),
                ),
              );
            // } catch (e) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('업로드 실패: $e')),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
