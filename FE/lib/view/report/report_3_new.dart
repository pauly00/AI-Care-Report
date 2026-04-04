import 'package:flutter/material.dart';

import 'package:safe_hi/view/report/report_4_new.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

/// 돌봄 리포트 3단계 화면 - 전력 및 LED 정보 표시
class Report3New extends StatefulWidget {
  const Report3New({super.key});

  @override
  State<Report3New> createState() => _Report3NewState();
}

class _Report3NewState extends State<Report3New> {
  /// 공통 색상
  static const Color _primaryRed = Color(0xFFFB5457);
  static const Color _borderPink = Color(0xFFF5CED1);
  static const Color _shadowPink = Color(0x33F5CED1);
  static const Color _labelGray  = Color(0xFF9E9E9E);
  static const Color _titleGray  = Color(0xFF4A4A4A);

  // LED 이상탐지 통계 더미 데이터 - 추후 API 연동 필요
  final int _cntInterest = 3; // 더미값
  final int _cntCaution  = 4; // 더미값
  final int _cntSevere   = 2; // 더미값

  // LED 이벤트 리스트 더미 데이터 - 추후 API 연동 필요
  final List<_LedEvent> _events = const [
    _LedEvent(round: '1차', date: '2025.08.11', level: _Level.caution), // 더미값
    _LedEvent(round: '2차', date: '2025.08.16', level: _Level.severe), // 더미값
    _LedEvent(round: '3차', date: '2025.08.19', level: _Level.severe), // 더미값
    _LedEvent(round: '4차', date: '2025.08.28', level: _Level.caution), // 더미값
  ];

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
                      currentStep: 3,
                      totalSteps: 5,
                      stepTitle: 'step 3',
                      stepSubtitle: '전력 · LED 정보',
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 전력사용량 섹션
                    _sectionTitle('전력사용량'),
                    const SizedBox(height: 8),
                    _pinkCard(
                      rs,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // 전력 차트 영역 - 추후 차트 위젯 연동 필요
                      ),
                    ),

                    SizedBox(height: rs.sectionSpacing),

                    // LED 이상탐지 현황 섹션
                    _sectionTitle('LED 이상탐지 현황'),
                    const SizedBox(height: 8),
                    _pinkCard(
                      rs,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 위험도별 분포 막대 그래프
                          _segmentedRiskBarWithLabels(
                            interest: _cntInterest, // 더미값 - API 연동 필요
                            caution: _cntCaution, // 더미값 - API 연동 필요
                            severe: _cntSevere, // 더미값 - API 연동 필요
                          ),
                          SizedBox(height: rs.itemSpacing * 1.2),

                          // 이벤트 리스트
                          Column(
                            children: _events
                                .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _eventTile(e),
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

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
              MaterialPageRoute(builder: (_) => const Report4New()),
            );
          },
        ),
      ),
    );
  }

  /// 섹션 제목 위젯
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _primaryRed,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  /// 핑크 카드 컨테이너 위젯
  Widget _pinkCard(Responsive rs, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(rs.cardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderPink, width: 1.2),
        boxShadow: const [
          BoxShadow(color: _shadowPink, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  /// 위험도별 분포 막대 그래프와 라벨
  Widget _segmentedRiskBarWithLabels({
    required int interest,
    required int caution,
    required int severe,
  }) {
    return Column(
      children: [
        // 동일한 비율의 막대 그래프 (1:1:1)
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 32,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(color: const Color(0xFF9E9E9E)), // 관심(회색)
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: const Color(0xFFF6B81A)), // 주의(노랑)
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: _primaryRed), // 심각(빨강)
                ),
              ],
            ),
          ),
        ),
        
        // 라벨 배치
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '관심',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '주의',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF6B81A),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '심각',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _primaryRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 위험도별 색상 매핑
  static const Map<_Level, Color> _chipBg = {
    _Level.interest: Color(0xFFE0E0E0), // 회색 연톤
    _Level.caution: Color(0xFFF6B81A),  // 노랑
    _Level.severe: _primaryRed,         // 빨강
  };

  static const Map<_Level, Color> _chipText = {
    _Level.interest: Colors.black87,
    _Level.caution: Colors.white,
    _Level.severe: Colors.white,
  };

  static const Map<_Level, String> _chipLabel = {
    _Level.interest: '관심',
    _Level.caution: '주의',
    _Level.severe: '심각',
  };

  /// 이벤트 타일 위젯 - 3등분 레이아웃
  static Widget _eventTile(_LedEvent e) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 회차 표시
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                e.round,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // 날짜 표시
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                e.date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _titleGray,
                ),
              ),
            ),
          ),
          // 위험도 표시
          Expanded(
            flex: 1,
            child: Center(
              child: _levelChip(e.level),
            ),
          ),
        ],
      ),
    );
  }

  /// 위험도 칩 위젯
  static Widget _levelChip(_Level level) {
    final bg = _chipBg[level]!;
    final fg = _chipText[level]!;
    final label = _chipLabel[level]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// 위험도 레벨 열거형
enum _Level { interest, caution, severe }

/// LED 이벤트 모델 클래스
class _LedEvent {
  final String round; // 회차 (ex: 1차)
  final String date;  // 날짜 (ex: 2025.08.11)
  final _Level level; // 위험도 (관심/주의/심각)

  const _LedEvent({
    required this.round,
    required this.date,
    required this.level,
  });
}