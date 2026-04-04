import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/home/widget/recent_card2.dart';
import 'package:safe_hi/view/report/report_list_page.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
import 'package:safe_hi/widget/card/visit_list_card.dart';

// 미사용 코드

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitViewModel>().fetchTodayVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final visitVM = context.watch<VisitViewModel>();
    final visits = visitVM.visits;
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DefaultAppBar(title: '안심하이'),
                RichText(
                  text: TextSpan(
                    // 공통 스타일 (기본 크기/두께, 기본 색)
                    style: TextStyle(
                      fontSize: responsive.fontBase,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.3, // 줄간격 옵션
                    ),
                    children: [
                      // 이모지 + "안녕하세요"만 빨간색
                      const TextSpan(
                        text: '✌️안녕하세요',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: ', $username 매니저님',
                      ),
                      // 줄바꿈 후 더 작고 얇게
                      TextSpan(
                        text: '\n오늘 처리해야 할 업무는 아래와 같습니다.',
                        style: TextStyle(
                          fontSize: responsive.fontSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsive.sectionSpacing),

                // 상단 빨간 카드
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB5457),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        '오늘의 업무 핵심 요약',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.fontLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // "오늘은 총 [배지] 방문 예정입니다."
                      Row(
                        children: [
                          Text(
                            '오늘은 총 ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontBase,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // 배지 (테두리 흰색, 내부는 배경색과 동일)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFB5457), // 내부 배경색 동일
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1.5), // 흰색 테두리
                            ),
                            child: Text(
                              visitVM.isLoading ? '…' : '${visits.length}곳',
                              style: TextStyle(
                                color: Colors.white, // 글씨 흰색
                                fontSize: responsive.fontBase,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            ' 방문 예정입니다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontBase,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 하단 2칸 카드
                      Row(
                        children: [
                          // ────────────── 카드 1 ──────────────
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 아이콘 크게
                                  Text(
                                    '📋',
                                    style: TextStyle(fontSize: responsive.fontLarge * 1.6), // 글씨 크기보다 크게
                                  ),
                                  const SizedBox(width: 10),
                                  // 기존 글씨 영역
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '미작성 리포트',
                                        style: TextStyle(
                                          color: const Color(0xFFFB5457),
                                          fontSize: responsive.fontBase,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${visits.length}건',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: responsive.fontSmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // ────────────── 카드 2 ──────────────
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '📥',
                                    style: TextStyle(fontSize: responsive.fontLarge * 1.6),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '정책 제안됨',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: const Color(0xFFFB5457),
                                          fontSize: responsive.fontBase,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${visits.length}건',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: Colors.grey[600],
                                          fontSize: responsive.fontSmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),


                SizedBox(height: 16),


                // 오늘의 방문 일정
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF), // 배경
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Column(
                    children: [
                      // 헤더 줄 (아이콘 + 제목, 우측 '일정 수정')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Text(
                              '🗓  오늘의 방문 일정',
                              style: TextStyle(
                                fontSize: responsive.fontLarge,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF000000), // 이미지처럼 약간 브라운 톤
                              ),
                            ),
                            const Spacer(),
                            // 우측 '일정 수정' (붉은 아웃라인 버튼)
                            OutlinedButton(
                              onPressed: () {
                                // TODO: 일정 수정 페이지로 이동 혹은 BottomSheet 열기
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFB5457), width: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                foregroundColor: const Color(0xFFFB5457),
                                textStyle: TextStyle(
                                  fontSize: responsive.fontBase,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('일정 수정'),
                            ),
                          ],
                        ),
                      ),

                      // 상단 구분선
                      Container(height: 1, color: const Color(0xFF2A2A2A)),

                      // 리스트
                      if (visitVM.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      else
                        ...List.generate(visits.length, (index) {
                          final v = visits[index];
                          final isLast = index == visits.length - 1;

                          // 첫 번째 항목만 '진행 완료'로 표시 (이미지 그대로)
                          final isDone = index == 0;

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 시간
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        v.time, // 예: '10:00'
                                        style: TextStyle(
                                          fontSize: responsive.fontLarge,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFE6DFDD),
                                        ),
                                      ),
                                    ),

                                    // 타임라인 세로줄
                                    SizedBox(
                                      width: 24,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 4),
                                          // 위·아래 이어지는 라인 느낌
                                          Container(
                                            width: 2,
                                            height: 44,
                                            color: const Color(0xFF2A2A2A),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 이름/지역
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 이름
                                          Text(
                                            v.name, // 예: '오하이' / '홍길동' / '김안심'
                                            style: TextStyle(
                                              fontSize: responsive.fontLarge,
                                              fontWeight: FontWeight.w900,
                                              color: const Color(0xFFE6DFDD),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          // 지역(회색)
                                          Text(
                                            v.address, // 예: '대전 서구'
                                            style: TextStyle(
                                              fontSize: responsive.fontBase,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF8B8B8B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // 우측 영역: 진행완료 or 버튼 2개
                                    if (isDone)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '진행 완료',
                                          style: TextStyle(
                                            fontSize: responsive.fontLarge,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF8B8B8B),
                                          ),
                                        ),
                                      )
                                    else
                                      Row(
                                        children: [
                                          // 전화하기(아웃라인)
                                          OutlinedButton(
                                            onPressed: () {
                                              // TODO: 전화 플로우 연결

                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Color(0xFFFB5457), width: 2),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                              foregroundColor: const Color(0xFFFB5457),
                                              textStyle: TextStyle(
                                                fontSize: responsive.fontLarge,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            child: const Text('전화하기'),
                                          ),
                                          const SizedBox(width: 12),
                                          // 기록하기(채움)
                                          TextButton(
                                            onPressed: () {
                                              // TODO: 기록 화면으로 이동 (reportId 전달 등)
                                              // Navigator.push(...);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(0xFFFB5457),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                              foregroundColor: Colors.white,
                                              textStyle: TextStyle(
                                                fontSize: responsive.fontLarge,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            child: const Text('기록하기'),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),

                              // 항목 사이 구분선 (마지막은 생략)
                              if (!isLast) Container(height: 1, color: const Color(0xFF2A2A2A)),
                            ],
                          );
                        }),
                    ],
                  ),
                ),




                SizedBox(height: responsive.itemSpacing),
                if (visitVM.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ...visits.map((v) => VisitCard(
                        id: v.reportId,
                        time: v.time,
                        name: v.name,
                        address: v.address,
                        addressDetails: v.addressDetails,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

