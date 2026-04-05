import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/report/report_5.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:safe_hi/model/welfare_policy_model.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

/// 돌봄 리포트 4단계 화면 - 복지정책 추천
class Report4 extends StatefulWidget {
  const Report4({super.key});

  @override
  State<Report4> createState() => _Report4State();
}

class _Report4State extends State<Report4> {
  // 추천 정책 목록 - 추후 API 연동 필요
  List<WelfarePolicy> _policies = [];

  /// 공통 색상
  static const Color _primaryRed  = Color(0xFFFB5457);
  static const Color _borderPink  = Color(0xFFF5CED1);
  static const Color _shadowPink  = Color(0x33F5CED1);
  static const Color _labelGray   = Color(0xFF9E9E9E);
  static const Color _titleGray   = Color(0xFF4A4A4A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final targetId = context.read<ReportViewModel>().selectedTarget?.targetId;
      if (targetId == null) return;

      try {
        final fetched = await context.read<VisitPolicyViewModel>().fetchWelfarePolicies(targetId);
        setState(() => _policies = fetched);
      } catch (e) {
        debugPrint('❌ 복지정책 로드 실패: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 단계 헤더
                    const ReportStepHeader(
                      currentStep: 4,
                      totalSteps: 5,
                      stepTitle: 'step 4',
                      stepSubtitle: '정책 추천',
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 추천 정책 카드 리스트
                    Column(
                      children: List.generate(_policies.length, (i) {
                        final p = _policies[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: rs.cardSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 정책 제목 (번호 포함)
                              Text(
                                '${i + 1}. ${p.policyName}',
                                style: TextStyle(
                                  color: _primaryRed,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 정책 상세 카드
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(rs.cardSpacing),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: _borderPink, width: 1.2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: _shadowPink,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 정책 개요
                                    _sectionLabel('정책 개요'),
                                    const SizedBox(height: 6),
                                    _bullet('• ${p.shortDescription}', rs),

                                    SizedBox(height: rs.itemSpacing),

                                    // 세부 설명
                                    _sectionLabel('세부 설명'),
                                    const SizedBox(height: 6),
                                    ...p.detailedConditions.map(
                                          (c) => _bullet('• $c', rs),
                                    ),

                                    SizedBox(height: rs.itemSpacing),

                                    // AI추천 이유 - 더미값
                                    _sectionLabel('AI추천 이유'),
                                    const SizedBox(height: 6),
                                    _bullet(
                                      '• 최근 상담 내용에서 외출 어려움과 의료 접근성 문제 반복 언급됨', // 더미값 - 백엔드 연동 필요
                                      rs,
                                    ),

                                    SizedBox(height: rs.itemSpacing * 1.2),

                                    // 액션 버튼
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => _openDetail(p),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _primaryRed,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: rs.itemSpacing * 0.9,
                                              ),
                                            ),
                                            child: Text(
                                              '자세히 보기',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: rs.fontSmall,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        OutlinedButton.icon(
                                          onPressed: () => _removePolicy(i),
                                          icon: const Icon(Icons.delete_outline, color: _primaryRed),
                                          label: Text(
                                            '지우기',
                                            style: TextStyle(
                                              color: _primaryRed,
                                              fontWeight: FontWeight.w800,
                                              fontSize: rs.fontSmall,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: _primaryRed, width: 1.6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: rs.itemSpacing * 0.9,
                                              horizontal: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
      // 하단 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: rs.paddingHorizontal),
        child: BottomTwoButton(
          buttonText1: '이전',
          buttonText2: '다음'.padLeft(14).padRight(28),
          onButtonTap1: () => Navigator.pop(context),
          onButtonTap2: () async {
            final reportId = context.read<ReportViewModel>().selectedTarget?.reportId ?? 9999; // 더미값 - 백엔드 연동 필요
            final selected = _policies; // 지우지 않은 항목을 전송
            if (selected.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('최소 하나 이상의 정책을 유지해 주세요.')),
              );
              return;
            }

            try {
              final policyVM = context.read<VisitPolicyViewModel>();
              await policyVM.uploadPolicyCheckStatus(
                reportId: reportId,
                policies: selected,
              );
            } catch (e) {
              debugPrint('❌ 정책 전송 실패: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('정책 전송 실패: $e')),
              );
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Report5()),
            );
          },
        ),
      ),
    );
  }

  /// 섹션 라벨 위젯
  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w900,
    ),
  );

  /// 불릿 포인트 텍스트 위젯
  Widget _bullet(String text, Responsive rs) => Text(
    text,
    style: TextStyle(
      color: _titleGray,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.42,
    ),
  );

  /// 정책 상세 링크 열기
  Future<void> _openDetail(WelfarePolicy p) async {
    if (p.link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('연결된 상세 링크가 없습니다.')),
      );
      return;
    }
    final uri = Uri.tryParse(p.link);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('링크를 열 수 없습니다.')),
      );
    }
  }

  /// 정책 삭제 확인 다이얼로그
  Future<void> _removePolicy(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('정책 삭제'),
        content: const Text('이 추천 정책을 목록에서 지울까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('지우기', style: TextStyle(color: _primaryRed, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _policies.removeAt(index));
    }
  }
}
