import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/care_report_detail.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
import 'package:safe_hi/view/report/report_1.dart';

class CareReportPage extends StatefulWidget {
  const CareReportPage({super.key});

  @override
  State<CareReportPage> createState() => _CareReportPageState();
}

class _CareReportPageState extends State<CareReportPage> {
  // 선택된 필터 버튼 상태 (0: 모두 선택, 1: 방문돌봄, 2: 전화돌봄)
  int _selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);

    // 더미 데이터 - 추후 API 연동 필요
    final visits = [
      {'date': '2025.08.13', 'name': '오하이', 'count': 3, 'type': '방문'},
      {'date': '2025.08.13', 'name': '남영탁', 'count': 2, 'type': '전화'},
      {'date': '2025.08.13', 'name': '박정자', 'count': 1, 'type': '방문'},
      {'date': '2025.08.13', 'name': '오하이', 'count': 2, 'type': '전화'},
      {'date': '2025.08.13', 'name': '오하이', 'count': 1, 'type': '전화'},
      {'date': '2025.08.13', 'name': '강병수', 'count': 1, 'type': '방문'},
      {'date': '2025.08.12', 'name': '홍길동', 'count': 1, 'type': '방문'},
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 앱바
            const DefaultAppBar(title: '돌봄 기록'),

            // 메인 콘텐츠 영역
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: rs.sectionSpacing),

                    // 검색창과 정렬 버튼
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '대상자 이름 검색',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: const Center(
                            child: Text(
                              '최신순',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 돌봄 유형 필터 버튼
                    Row(
                      children: [
                        // 모두 선택 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '모두 선택',
                            index: 0,
                            isSelected: _selectedButton == 0,
                            onPressed: () => setState(() => _selectedButton = 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 방문돌봄 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '방문돌봄',
                            index: 1,
                            isSelected: _selectedButton == 1,
                            onPressed: () => setState(() => _selectedButton = 1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 전화돌봄 버튼
                        Expanded(
                          child: _buildToggleButton(
                            text: '전화돌봄',
                            index: 2,
                            isSelected: _selectedButton == 2,
                            onPressed: () => setState(() => _selectedButton = 2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rs.sectionSpacing),

                    // 돌봄 기록 리스트
                    Expanded(
                      child: ListView.separated(
                        itemCount: visits.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final v = visits[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CareReportDetail(
                                    name: v['name'] as String,
                                    count: v['count'] as int,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          v['date'] as String,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${v['name']} ${v['count']}회차 돌봄일지',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 돌봄 유형 태그
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: v['type'] == '방문'
                                          ? const Color(0xFFD32F2F)    // 현장돌봄은 빨간색
                                          : const Color(0xFFE65100),   // 전화돌봄은 진한 주황색(개나리색)
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      v['type'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.black54),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 필터 토글 버튼 위젯
  Widget _buildToggleButton({
    required String text,
    required int index,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return isSelected
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB5457),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFB5457),
              side: const BorderSide(color: Color(0xFFFB5457), width: 1.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
          );
  }
}