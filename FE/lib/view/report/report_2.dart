import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:safe_hi/view/report/report_3.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/view_model/visit_summary_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

/// 돌봄 리포트 2단계 화면 - 상담 정보 표시
class Report2 extends StatefulWidget {
  const Report2({super.key});

  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  // 방문/전화 돌봄 선택 상태 (0: 방문돌봄, 1: 전화돌봄)
  int _careType = 0;

  // 생활상태 평가 더미 데이터 - 추후 백엔드 연동 필요
  final Map<String, String> _status = const {
    '건강상태': '정상',
    '식사기능': '양호',
    '인지기능': '불량',
    '의사소통': '불량',
  };

  // 담당자 메모 더미 데이터 - 추후 백엔드 연동 필요
  final String _memo = '대화 중 같은 질문을 반복하는 등 기억력 문제 의심. 복약 알림과 보호자 연락 주기를 조정할 필요가 있음. '
      '다음 방문 전까지 실내 스트레칭 루틴을 1일 2회 권장.';

  /// 공통 색상
  static const Color _primaryRed = Color(0xFFFB5457);
  static const Color _borderPink = Color(0xFFF5CED1);
  static const Color _shadowPink = Color(0x33F5CED1);
  static const Color _labelGray  = Color(0xFF9E9E9E);
  static const Color _titleGray  = Color(0xFF4A4A4A);
  static const Color _okGreen    = Color(0xFF22C55E);
  static const Color _badRed     = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);
    final summaryVM = context.watch<VisitSummaryViewModel>();
    final summaries = summaryVM.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: summaryVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 단계 헤더
                    const ReportStepHeader(
                      currentStep: 2,
                      totalSteps: 5,
                      stepTitle: 'step 2',
                      stepSubtitle: '상담 정보',
                    ),
                    SizedBox(height: rs.sectionSpacing * 0.8),

                    // 방문돌봄 / 전화돌봄 토글
                    Row(
                      children: [
                        Expanded(
                          child: _segButton(
                            text: '방문돌봄',
                            selected: _careType == 0,
                            onTap: () => setState(() => _careType = 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _segButton(
                            text: '전화돌봄',
                            selected: _careType == 1,
                            onTap: () => setState(() => _careType = 1),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: rs.sectionSpacing),

                    // 상담정보 AI 요약 섹션 (BE 실데이터)
                    _sectionTitle('상담정보 AI 요약'),
                    const SizedBox(height: 10),
                    summaries.isEmpty
                        ? _pinkCard(rs,
                            child: Text(
                              'AI 요약 데이터가 없습니다.',
                              style: TextStyle(
                                fontSize: rs.fontBase,
                                color: _labelGray,
                              ),
                            ))
                        : _pinkCard(
                            rs,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < summaries.length; i++) ...[
                                  if (i > 0) SizedBox(height: rs.itemSpacing * 0.9),
                                  _smallLabel(summaries[i].subject),
                                  const SizedBox(height: 6),
                                  _paraText(summaries[i].abstract, rs),
                                ],
                              ],
                            ),
                          ),

                    SizedBox(height: rs.sectionSpacing),

                    // 생활상태 평가 섹션 (추후 BE 연동 필요)
                    _sectionTitle('생활상태'),
                    const SizedBox(height: 10),
                    _pinkCard(
                      rs,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(child: _statusItem('건강상태', _status['건강상태']!, rs)),
                            _dotDivider(),
                            Expanded(child: _statusItem('식사기능', _status['식사기능']!, rs)),
                            _dotDivider(),
                            Expanded(child: _statusItem('인지기능', _status['인지기능']!, rs)),
                            _dotDivider(),
                            Expanded(child: _statusItem('의사소통', _status['의사소통']!, rs)),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: rs.sectionSpacing),

                    // 담당자 메모 섹션 (추후 BE 연동 필요)
                    _sectionTitle('담당자 메모'),
                    const SizedBox(height: 10),
                    _pinkCard(rs, child: _paraText(_memo, rs)),

                    SizedBox(height: rs.sectionSpacing * 1.2),
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
          onButtonTap2: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => VisitPolicyViewModel(),
                  child: const Report3(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 세그먼트 버튼 위젯
  Widget _segButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final bg = selected ? _primaryRed : Colors.white;
    final fg = selected ? Colors.white : _primaryRed;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _primaryRed, width: 1.6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w900, color: fg, fontSize: 16),
          ),
        ),
      ),
    );
  }

  /// 섹션 제목 위젯
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(color: _primaryRed, fontSize: 22, fontWeight: FontWeight.w900),
    );
  }

  /// 핑크 카드 컨테이너 위젯
  Widget _pinkCard(Responsive rs, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(rs.cardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _borderPink, width: 1.0),
        boxShadow: const [
          BoxShadow(color: _shadowPink, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: child,
    );
  }

  /// 소제목 라벨 위젯
  Widget _smallLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _labelGray),
    );
  }

  /// 본문 텍스트 위젯
  Widget _paraText(String text, Responsive rs) {
    return Text(
      text,
      style: TextStyle(fontSize: rs.fontBase, fontWeight: FontWeight.w700, color: _titleGray, height: 1.2),
    );
  }

  /// 생활상태 아이템 위젯
  Widget _statusItem(String label, String value, Responsive rs) {
    final isGood = value.contains('정상') || value.contains('양호');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _labelGray)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isGood ? _okGreen : _badRed)),
      ],
    );
  }

  /// 점선 구분선 위젯
  Widget _dotDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 36,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE7DEDE), width: 1)),
        ),
      ),
    );
  }
}
