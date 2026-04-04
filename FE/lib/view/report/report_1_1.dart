import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/report_1_2.dart';
import 'package:safe_hi/view/report/report_1_3.dart';
import 'package:safe_hi/view/report/report_2_1.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view/report/report_2.dart';

// 미사용 코드
class Report1_1 extends StatefulWidget {
  const Report1_1({super.key});

  @override
  State<Report1_1> createState() => _Report1_1State();
}

class _Report1_1State extends State<Report1_1> {
  String selectedChip = '상담일지';
  bool _isExpanded = true;

  String selectedRound = '1회차';
  String selectedVisitRound = '1회차';

  // 스크롤 컨트롤러 및 GlobalKey 추가
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _consultingInfoKey = GlobalKey(); // 최근 상담정보
  final GlobalKey _phoneKey = GlobalKey(); // 전화돌봄
  final GlobalKey _visitKey = GlobalKey(); // 방문상담

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 특정 위젯으로 스크롤 이동하는 함수
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // 기본 정보 위치 정렬 위젯
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72, // 라벨 고정 너비 (예: 대상자 ~ 복지센터 정도 길이 고려)
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  // 상세 정보(빌드 상태) 위젯
  Widget buildStatusRow(String label, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // 추천 복제 서비스 위젯
  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // 캘린더 설정
  Widget _buildCalendarDay(String day, String? type, VoidCallback onTap) {
    Color bgColor;
    Color textColor = Colors.white;

    if (type == '전화') {
      bgColor = const Color(0xFFFEC84B);
    } else if (type == '방문') {
      bgColor = const Color(0xFFFDA29B);
    } else {
      bgColor = const Color(0xFFE0E0E0);
      textColor = Colors.black;
    }

    return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8), // ✅ 둥근 사각형
        ),
        alignment: Alignment.center,
        child: Text(
          '$day일',
          style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }

  // 박스 설정
  Widget _buildLegendBox(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // 상태 바 위젯
  Widget buildStatusBar({
    required String title,
    required String status,
    required int? levelIndex, // nullable 처리
    required List<String> labels,
  }) {
    final int sections = labels.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 상태
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                levelIndex == null ? '-' : status,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 상태 바 - Stack
          Stack(
            children: [
              Row(
                children: List.generate(sections, (i) {
                  return Expanded(
                    child: Container(
                      height: 10,
                      margin: EdgeInsets.only(right: i < sections - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: i == 0
                            ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))
                            : i == sections - 1
                            ? const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))
                            : BorderRadius.zero,
                      ),
                    ),
                  );
                }),
              ),
              Row(
                children: List.generate(sections, (i) {
                  return Expanded(
                    child: Container(
                      height: 10,
                      margin: EdgeInsets.only(right: i < sections - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: (levelIndex != null && i == levelIndex)
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: i == 0
                            ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))
                            : i == sections - 1
                            ? const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))
                            : BorderRadius.zero,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 레이블
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) =>
                Text(label, style: const TextStyle(fontSize: 12))).toList(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    const Color red = Color(0xFFFB5457);
    const Color lightRed = Color(0x1AFF5C6A);

    List<String> chips = ['상담일지', '건강일지', '전력일지'];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, // 스크롤 컨트롤러 연결
                padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportStepHeader(
                      currentStep: 1,
                      totalSteps: 6,
                      stepTitle: 'step 1.1',
                      stepSubtitle: '기본 정보 확인',
                    ),
                    const SizedBox(height: 20),

                    // 제목
                    Text(
                      '김민수님의\n7월 상담분석 결과',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.fontXL,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8),

                    // 날짜 박스
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: lightRed,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        '2025/07/01(목) ~ 2025/07/31(목)',
                        style: TextStyle(color: red),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 일지 선택 (스크롤 이동 기능 추가)
                    Row(
                      children: chips.map((chip) {
                        final isSelected = selectedChip == chip;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(chip),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedChip = chip;
                              });

                              // 클릭된 칩에 따라 해당 위치로 스크롤 이동
                              if (chip == '상담일지') {
                                _scrollToSection(_consultingInfoKey);
                              } else if (chip == '건강일지') {
                                _scrollToSection(_phoneKey);
                              } else if (chip == '전력일지') {
                                _scrollToSection(_visitKey);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            selectedColor: Colors.red[100],
                            backgroundColor: Colors.grey[200],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // 기본 정보 카드
                    Text('기본정보',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.fontLarge)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoRow('대상자', '김민수'),
                          buildInfoRow('생년월일', '2000.02.13'),
                          buildInfoRow('성별', '남'),
                          buildInfoRow('연락처', '010-1234-5678'),
                          buildInfoRow('주소', '울산광역시 중구'),
                          buildInfoRow('복지센터', '삼도1동 행정복지센터'),
                          buildInfoRow('담당자', '한민우'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 월 전체 일정(기본정보 아래로 이동)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16), // 외곽 테두리
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('과거 안부 안내', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              _buildLegendBox('전화', const Color(0xFFFEC84B)),
                              const SizedBox(width: 8),
                              _buildLegendBox('방문', const Color(0xFFFDA29B)),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // 날짜 (7개씩 행 구성)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(31, (index) {
                              final day = index + 1;
                              String? type;

                              if (day == 1) type = '전화';
                              if (day == 2) type = '방문';

                              return _buildCalendarDay(
                                '$day',
                                type,
                                    () {},
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 최근 상담정보 (GlobalKey 추가)
                    Container(
                      key: _consultingInfoKey, // 상담일지 버튼 클릭시 이동할 위치
                      child: Text('최근 상담정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.fontLarge)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('최근 상담정보 요약'),
                          Divider(),
                          Text('요약\n'),
                          Text('\n\n\n'),
                          Text('상세 정보', style: TextStyle(fontWeight: FontWeight.bold)),
                          Divider(),
                          buildStatusRow('건강상태', '정상', valueColor: Colors.green),
                          buildStatusRow('식사기능', '정상', valueColor: Colors.green),
                          buildStatusRow('인지기능', '불량', valueColor: Colors.red),
                          buildStatusRow('의사소통', '불량', valueColor: Colors.red),

                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 추천 복지 서비스
                    Text('추천 복지 서비스',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.fontLarge)),
                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제목 + 아이콘 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('1. 정책명', style: TextStyle(color: red, fontSize: 20, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(
                                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),


                          // 펼쳐질 내용
                          if (_isExpanded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('정책 개요', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                bulletText('내용'),
                                bulletText('내용'),

                                const SizedBox(height: 12),
                                const Text('세부 설명', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                bulletText('내용'),
                                bulletText('내용'),

                                const SizedBox(height: 12),
                                const Text('추천 이유', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                bulletText('내용'),
                                bulletText(''),
                              ],
                            )
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 전화돌봄 + 드롭다운 (GlobalKey 추가)
                    Container(
                      key: _phoneKey, // 건강일지 버튼 클릭시 이동할 위치
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              '전화돌봄', style: TextStyle(fontWeight: FontWeight
                              .bold)),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedRound,
                                isDense: true,
                                // isExpanded: true, // 텍스트 잘림 방지
                                style: const TextStyle(fontSize: 14),
                                items: const [
                                  DropdownMenuItem(
                                      value: '1회차', child: Text('1회차')),
                                  DropdownMenuItem(
                                      value: '2회차', child: Text('2회차')),
                                  DropdownMenuItem(
                                      value: '3회차', child: Text('3회차')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedRound = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    buildStatusBar(
                      title: '건강상태',
                      status: '정상',
                      levelIndex: 0,
                      labels: ['정상', '위험'],
                    ),
                    buildStatusBar(
                      title: '식사기능',
                      status: '양호',
                      levelIndex: 0,
                      labels: ['양호', '보통', '불량'],
                    ),
                    buildStatusBar(
                      title: '인지기능',
                      status: '양호',
                      levelIndex: 0,
                      labels: ['양호', '보통', '불량'],
                    ),
                    buildStatusBar(
                      title: '의사소통',
                      status: '양호',
                      levelIndex: 0,
                      labels: ['양호', '보통', '불량'],
                    ),

                    const SizedBox(height: 24),

                    // 활동내용
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('활동내용', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('고장난 TV수리 했다고 함.\n식사는 잘하시 무릎이 아파 걷기 불편하다고 하심'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 방문상담 타이틀 + 드롭다운 (GlobalKey 추가)
                    Container(
                      key: _visitKey, // 전력일지 버튼 클릭시 이동할 위치
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('방문상담', style: TextStyle(
                              fontWeight: FontWeight.bold)),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey.shade400),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedVisitRound,
                                isDense: true,
                                style: const TextStyle(fontSize: 14),
                                items: const [
                                  DropdownMenuItem(
                                      value: '1회차', child: Text('1회차')),
                                  DropdownMenuItem(
                                      value: '2회차', child: Text('2회차')),
                                  DropdownMenuItem(
                                      value: '3회차', child: Text('3회차')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedVisitRound = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 상담요약
                    Container(
                      width: double.infinity, // ✅ 상태바와 동일하게 끝까지
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('상담요약', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('고장난 TV수리 했다고 함.\n식사는 잘하시 무릎이 아파 걷기 불편하다고 하심\n\n\n\n\n\n'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('특이사항', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('고장난 TV수리 했다고 함.\n식사는 잘하시 무릎이 아파 걷기 불편하다고 하심'),
                        ],
                      ),
                    ),


                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ),

            // 다음 버튼
            Padding(
              padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
              child: BottomOneButton(
                buttonText: '다음(테스트 버튼 -> 1_3로 이동)',
                onButtonTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Report1_3()),
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
