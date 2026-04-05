import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/visit/visit_confirm_check.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/view_model/today_visit_view_model.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main_screen.dart';
import '../../provider/nav/bottom_nav_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 위젯 빌드 완료 후 API 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final token = context.read<UserViewModel>().token;

      // 토큰이 있을 경우 오늘 방문 일정 가져오기
      if (token != null) {
        context.read<TodayVisitViewModel>().fetchTodayVisits(
          todayDate: today,
          token: token,
        );
        context.read<ReportViewModel>().fetchTargets();
      } else {
        debugPrint('토큰이 null입니다. 로그인 실패 또는 저장 실패일 수 있음.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // Provider를 통한 상태 관리
    final todayVisitVM = context.watch<TodayVisitViewModel>();
    final todayVisits = todayVisitVM.todayVisits;
    final sortedTodayVisits = [...todayVisits]
      ..sort((a, b) => _toSortableDateTime(a.visitTime).compareTo(_toSortableDateTime(b.visitTime)));
    final reportVM = context.watch<ReportViewModel>();
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO'; // 사용자 이름 가져오기
    final pendingReports = reportVM.targets.length;
    final recommendedWelfareCount = reportVM.targets
        .where((target) => target.reportStatus <= 1)
        .length;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultAppBar(title: '안심하이'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 환영 메시지
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: responsive.fontBase,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        children: [
                          // 인사말 - 빨간색 강조
                          const TextSpan(
                            text: '👋 안녕하세요',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: ', $username 매니저님',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),

                    // 부연 설명 - 이모지와 정렬 맞춤
                    Padding(
                      padding: EdgeInsets.only(left: responsive.fontBase * 1.5),
                      child: Text(
                        '오늘 처리해야 할 업무는 아래와 같습니다.',
                        style: TextStyle(
                          fontSize: responsive.fontSmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: responsive.sectionSpacing),

                    // 업무 요약 카드
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFB5457),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 카드 제목
                          Text(
                            '오늘의 업무 핵심 요약',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1), // 업무와 방문 예정 사이 공간

                          // 방문 예정 건수 표시
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
                              // 건수 배지
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), // 3곳 관련 공백
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB5457),
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(color: Colors.white, width: 2.0), // 테두리 제거
                                ),
                                child: Text(
                                  todayVisitVM.isLoading
                                      ? '…'
                                      : '${todayVisits.length}곳',
                                  style: TextStyle(
                                    color: Colors.white,
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
                          const SizedBox(height: 6), // 방문 예정과 리포트,추천 사이의 공백

                          // 업무 통계 카드들
                          Row(
                            children: [
                              // 미작성 리포트 카드
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    // 메인 앱 시작 시 기록 탭(인덱스 2)으로 설정
                                    BottomNavProvider.startupIndex = 2;

                                    // 메인 화면으로 이동하며 네비게이션 스택 초기화
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => const MainScreen()),
                                      (route) => false,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/report.png',
                                          width: MediaQuery.of(context).size.width * 0.08,
                                          height: MediaQuery.of(context).size.width * 0.08,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            // padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.00), // 오른쪽 여백
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    '미작성 리포트',
                                                    style: TextStyle(
                                                      color: const Color(0xFFFB5457),
                                                      fontSize: responsive.fontLarge,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${pendingReports}건',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: responsive.fontBase, // 기존: responsive.fontSmall
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // 복지서비스 추천 카드
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    // 메인 앱 시작 시 기록 탭(인덱스 2)으로 설정
                                    BottomNavProvider.startupIndex = 2;

                                    // 메인 화면으로 이동하며 네비게이션 스택 초기화
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => const MainScreen()),
                                      (route) => false,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/policy.png',
                                          width: MediaQuery.of(context).size.width * 0.08,
                                          height: MediaQuery.of(context).size.width * 0.08,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    '복지서비스 추천',
                                                    style: TextStyle(
                                                      color: const Color(0xFFFB5457),
                                                      fontSize: responsive.fontLarge,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${recommendedWelfareCount}건',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: responsive.fontBase,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 오늘의 일정 섹션
                    Column(
                      children: [
                        // 헤더 - 제목과 버튼들
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 달력 아이콘
                              Image.asset(
                                'assets/images/calendar.png',
                                width: MediaQuery.of(context).size.width * 0.04,
                                height: MediaQuery.of(context).size.width * 0.04,
                              ),

                              // 제목
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '오늘의 일정',
                                    style: TextStyle(
                                      fontSize: responsive.fontLarge,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),


                              const SizedBox(width: 8),

                              // 일정 추가 버튼
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB5457),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // TODO: 일정 추가/수정 페이지로 이동
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 로딩 상태 표시
                        if (todayVisitVM.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        // API 오류 시 메시지 표시 (주석처리)
                        // else if (todayVisitVM.errorMessage != null)
                        //   Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(20.0),
                        //       child: Column(
                        //         children: [
                        //           Text(
                        //             'API 연결 실패. 더미 데이터를 표시합니다.',
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(color: Colors.orange),
                        //           ),
                        //           const SizedBox(height: 10),
                        //           Text(
                        //             '오류: ${todayVisitVM.errorMessage}',
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(color: Colors.red, fontSize: 12),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        // 일정이 없을 때
                        else if (sortedTodayVisits.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('오늘 예정된 방문이 없습니다.'),
                              ),
                            ),

                        // API 데이터로 일정 카드 생성
                        if (sortedTodayVisits.isNotEmpty)
                          ...sortedTodayVisits.map((visit) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300, width: 1),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  if (visit.visitType == 0) {
                                    // 전화돌봄일 때 전화 걸기
                                    final phoneUrl = Uri.parse('tel:${visit.callNum}');
                                    if (await canLaunchUrl(phoneUrl)) {
                                      await launchUrl(phoneUrl);
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('전화를 걸 수 없습니다.')),
                                        );
                                      }
                                    }
                                  } else {
                                    // 현장돌봄일 때 방문 확인 페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VisitCheckConfirmPage(
                                          name: visit.name,
                                          address: visit.address,
                                          phone: visit.callNum,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 방문 시간
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        visit.visitTime,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // 이름과 주소/전화번호 정보
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                visit.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // 방문 유형 배지
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: visit.visitType == 0
                                                      ? const Color(0xFFFFF3CD) // 전화돌봄 - 개나리색 배경
                                                      : const Color(0xFFFFEBEE), // 현장돌봄 - 빨간색 배경
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  visit.visitType == 0 ? '전화돌봄' : '현장돌봄',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: visit.visitType == 0
                                                        ? const Color(0xFFE65100) // 전화돌봄 - 진한 주황색 텍스트
                                                        : const Color(0xFFD32F2F), // 현장돌봄 - 빨간색 텍스트
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            visit.visitType == 0
                                                ? visit.callNum  // 전화돌봄일 때 전화번호 표시
                                                : visit.address, // 현장돌봄일 때 주소 표시
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 전화돌봄일 때 전화 아이콘, 현장돌봄일 때 화살표 아이콘
                                    Icon(
                                      visit.visitType == 0 ? Icons.phone : Icons.arrow_forward_ios,
                                      color: const Color(0xFFFB5457),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),


                    SizedBox(height: responsive.itemSpacing),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _toSortableDateTime(String raw) {
    final normalized = raw.replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed != null) return parsed;

    // HH:mm 또는 H:mm 형식 fallback
    final parts = raw.split(':');
    if (parts.length >= 2) {
      final h = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
      final m = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), ''));
      if (h != null && m != null) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, h, m);
      }
    }

    return DateTime(1970);
  }
}