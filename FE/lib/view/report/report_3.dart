import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/model/welfare_policy_model.dart';
import 'package:safe_hi/view/report/report_4.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

// 미사용 코드

class Report3 extends StatefulWidget {
  const Report3({super.key});

  @override
  State<Report3> createState() => _Report3State();
}

class _Report3State extends State<Report3> {
  List<bool> _isSelected = [true, true];

  List<WelfarePolicy> _policies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // 실제 서버에서 report 가져오기(임시로 주석처리)
      // final reportId = context.read<ReportViewModel>().selectedTarget?.reportId;
      //
      // if (reportId == null) {
      //   debugPrint('❌ reportId가 null입니다.');
      //   return;
      // }
      //
      // // ✅ Provider에서 ViewModel 가져오기
      // final policyVM = context.read<VisitPolicyViewModel>();
      // final fetched = await policyVM.fetchWelfarePolicies(reportId);

      final reportId = context.read<ReportViewModel>().selectedTarget?.reportId ?? 9999;

      final policyVM = context.read<VisitPolicyViewModel>();

      // ✅ 강제로 더미 삽입
      _policies = [
        WelfarePolicy(
          id: 1,
          policyName: '노인 무릎 인공관절 지원',
          shortDescription: '무릎 수술비 최대 120만원 지원',
          detailedConditions: ['60세 이상', '저소득층'],
          link: '',
          checkStatus: 0,
        ),
        WelfarePolicy(
          id: 2,
          policyName: '독거노인 식사지원 사업',
          shortDescription: '도시락 주 3회 지원',
          detailedConditions: ['독거노인', '기초수급자'],
          link: '',
          checkStatus: 0,
        ),
      ];

      // setState(() => _policies = fetched);
      setState(() {});
    });
  }

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
                      currentStep: 3,
                      totalSteps: 6,
                      stepTitle: 'step 3',
                      stepSubtitle: '정책 추천',
                    ),
                    SizedBox(height: responsive.sectionSpacing),
                    Column(
                      children: List.generate(_policies.length, (index) {
                        final policy = _policies[index];
                        return Container(
                          margin:
                              EdgeInsets.only(bottom: responsive.cardSpacing),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '추천 정책 ${index + 1}. ${policy.policyName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: responsive.fontBase,
                                ),
                              ),
                              SizedBox(height: responsive.itemSpacing),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(responsive.itemSpacing),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFEBE7E7)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('정책 개요',
                                        style: TextStyle(
                                          fontSize: responsive.fontBase,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text('• ${policy.shortDescription}',
                                        style: TextStyle(
                                            fontSize: responsive.fontSmall)),
                                    SizedBox(height: responsive.itemSpacing),
                                    Text('세부 설명',
                                        style: TextStyle(
                                          fontSize: responsive.fontBase,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    ...policy.detailedConditions
                                        .map((condition) => Text(
                                              '• $condition',
                                              style: TextStyle(
                                                  fontSize:
                                                      responsive.fontSmall),
                                            ))
                                        .toList(),
                                    SizedBox(height: responsive.itemSpacing),
                                  ],
                                ),
                              ),
                              SizedBox(height: responsive.itemSpacing),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFB5457),
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                responsive.itemSpacing * 0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text('자세히 보기',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsive.fontSmall)),
                                    ),
                                  ),
                                  SizedBox(width: responsive.itemSpacing),
                                  Checkbox(
                                    value: policy.checkStatus == 1,
                                    onChanged: (val) {
                                      setState(() {
                                        policy.checkStatus = val! ? 1 : 0;
                                      });
                                    },
                                    activeColor: const Color(0xFFFB5457),
                                  ),
                                  Text('선택',
                                      style: TextStyle(
                                          fontSize: responsive.fontSmall,
                                          fontWeight: FontWeight.w500)),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                    ),
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
              Navigator.pop(context);
            },
            onButtonTap2: () async {
              final reportId =
                  context.read<ReportViewModel>().selectedTarget?.reportId ?? 9999;

              final selectedPolicies =
              _policies.where((e) => e.checkStatus == 1).toList();

              if (selectedPolicies.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('최소 하나 이상의 정책을 선택해주세요.')),
                );
                return;
              }

              try {
                final policyVM = context.read<VisitPolicyViewModel>();
                await policyVM.uploadPolicyCheckStatus(
                  reportId: reportId,
                  policies: selectedPolicies,
                );
              } catch (e) {
                debugPrint('❌ 정책 전송 실패: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('정책 전송 실패: $e')),
                );
              }

              // ✅ try-catch 밖에 두어 무조건 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Report4()),
              );
            }),
            // 서버 통해서 이동(임시 주석처리)
            // onButtonTap2: () async {
            //   final reportId =
            //       context.read<ReportViewModel>().selectedTarget?.reportId;
            //   if (reportId == null) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('리포트 ID를 찾을 수 없습니다.')),
            //     );
            //     return;
            //   }
            //
            //   try {
            //     final policyVM = context.read<VisitPolicyViewModel>();
            //     await policyVM.uploadPolicyCheckStatus(
            //       reportId: reportId,
            //       policies: _policies,
            //     );
            //
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Report4()),
            //     );
            //   } catch (e) {
            //     debugPrint('❌ 정책 전송 실패: $e');
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('정책 전송 실패: $e')),
            //     );
            //   }
            // }),
      ),
    );
  }
}
