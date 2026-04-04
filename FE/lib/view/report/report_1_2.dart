import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/report_1_1.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/view/report/report_2.dart';

// 미사용 코드

class Report1_2 extends StatefulWidget {
  const Report1_2({super.key});

  @override
  State<Report1_2> createState() => _Report1_2State();
}

class _Report1_2State extends State<Report1_2> {
  String selectedRound = '1회차';
  String selectedVisitRound = '1회차';

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
                    const SizedBox(height: 16),

                    // 전화돌봄 + 드롭다운
                    Row(
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

                    // 방문상담 타이틀 + 드롭다운
                    Row(
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
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
              child: BottomOneButton(
                buttonText: '이전',
                onButtonTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Report1_1()),
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