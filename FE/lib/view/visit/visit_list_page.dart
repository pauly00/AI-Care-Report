import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/visit/visit_confirm_check.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
import 'package:safe_hi/widget/card/visit_list_card.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart'; // 전화 기능을 위한 import 추가

class VisitListPage extends StatefulWidget {
  const VisitListPage({super.key});

  @override
  State<VisitListPage> createState() => _VisitListPageState();
}

/// 필터 버튼 선택 상태 관리용 enum
enum SelectedButton { all, phone, field }

class _VisitListPageState extends State<VisitListPage> {
  final _calController = CalendarWeekController();
  final ValueNotifier<DateTime> _selectedDateNotifier = ValueNotifier(DateTime.now());
  final ValueNotifier<SelectedButton> _selectedButtonNotifier = ValueNotifier(SelectedButton.all);

  /// 한국어 로케일 초기화
  Future<void> _initializeLocale() async {
    await initializeDateFormatting('ko_KR', null);
    Intl.defaultLocale = 'ko_KR';
  }

  @override
  void initState() {
    super.initState();
    /// 페이지 로드 시 오늘 방문자 데이터 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitViewModel>().fetchTodayVisits();
    });
  }

  @override
  void dispose() {
    _selectedButtonNotifier.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeLocale(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            body: Column(
              children: [
                const DefaultAppBar(title: '방문 리스트'),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: [
                        /// 주간 캘린더 위젯
                        ValueListenableBuilder<DateTime>(
                          valueListenable: _selectedDateNotifier,
                          builder: (context, selectedDate, child) {
                            return CalendarWeek(
                              controller: _calController,
                              backgroundColor: Colors.white,
                              height: 120,
                              showMonth: true,
                              minDate: DateTime.now().add(const Duration(days: -365)),
                              maxDate: DateTime.now().add(const Duration(days: 365)),

                              /// 선택된 날짜 스타일링
                              pressedDateBackgroundColor: const Color(0xFFFB5457),
                              pressedDateStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

                              /// 캘린더 텍스트 스타일
                              dayOfWeekStyle: const TextStyle(color: Color(0xFF433A3A)),
                              todayDateStyle: const TextStyle(color: Color(0xFFFB5457)),
                              dateStyle: const TextStyle(color: Color(0xFF433A3A)),
                              monthViewBuilder: (DateTime time) => Align(
                                alignment: FractionalOffset.center,
                                child: Text(DateFormat.yMMMM('ko_KR').format(time)),
                              ),

                              /// 요일 설정 (일요일부터 시작)
                              dayOfWeek: const ['월', '화', '수', '목', '금', '토', '일'],
                              weekendsIndexes: const [5, 6],

                              /// 날짜 선택 시 해당 날짜의 방문자 데이터 조회
                              onDatePressed: (DateTime datetime) {
                                _selectedDateNotifier.value = datetime;
                                final dateStr = DateFormat('yyyy-MM-dd').format(datetime);
                                context.read<VisitViewModel>().fetchVisitsByDate(dateStr);
                              },

                              /// 선택된 날짜 표시용 장식
                              decorations: [
                                DecorationItem(
                                  date: selectedDate,
                                  decoration: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        /// 방문 유형 필터 버튼 (전체보기/전화돌봄/현장돌봄)
                        ValueListenableBuilder<SelectedButton>(
                          valueListenable: _selectedButtonNotifier,
                          builder: (context, selectedButton, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  /// 전체보기 버튼
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _selectedButtonNotifier.value = SelectedButton.all;
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: selectedButton == SelectedButton.all
                                              ? const Color(0xFFFB5457)
                                              : const Color(0xFFE1E1E1),
                                        ),
                                        foregroundColor: selectedButton == SelectedButton.all
                                            ? const Color(0xFFFB5457)
                                            : const Color(0xFF8E8E8E),
                                        backgroundColor: selectedButton == SelectedButton.all
                                            ? const Color(0xFFFFF1F1)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text('전체 보기'),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// 전화돌봄 버튼
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _selectedButtonNotifier.value = SelectedButton.phone;
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: selectedButton == SelectedButton.phone
                                              ? const Color(0xFFFB5457)
                                              : const Color(0xFFE1E1E1),
                                        ),
                                        foregroundColor: selectedButton == SelectedButton.phone
                                            ? const Color(0xFFFB5457)
                                            : const Color(0xFF8E8E8E),
                                        backgroundColor: selectedButton == SelectedButton.phone
                                            ? const Color(0xFFFFF1F1)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text('전화 돌봄'),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// 현장돌봄 버튼
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _selectedButtonNotifier.value = SelectedButton.field;
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: selectedButton == SelectedButton.field
                                              ? const Color(0xFFFB5457)
                                              : const Color(0xFFE1E1E1),
                                        ),
                                        foregroundColor: selectedButton == SelectedButton.field
                                            ? const Color(0xFFFB5457)
                                            : const Color(0xFF8E8E8E),
                                        backgroundColor: selectedButton == SelectedButton.field
                                            ? const Color(0xFFFFF1F1)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text('현장 돌봄'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        /// 방문자 리스트 영역
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            children: [
                              /// 더미 데이터로 방문자 리스트 생성 - 추후 API 연동 필요
                              ...List.generate(3, (index) {
                                // 더미 데이터 - 추후 백엔드 연동 필요
                                final names = ['오하이', '홍길동', '김영희'];
                                final times = ['오전 10:00', '오전 11:00', '오후 1:00'];
                                final phones = ['010-9999-8765', '010-1234-5678', '010-8888-5678'];
                                final addresses = [
                                  '서울특별시 중구 필동로 1길 30 동국대학교 본관 4층 4142호',
                                  '대전서구 대덕대로 150 경성큰마을아파트 102동 103호',
                                  '서울특별시 강북구 노해로 27길 14-14 202호'
                                ];
                                final types = ['전화돌봄', '현장돌봄', '전화돌봄']; // 더미 데이터
                                final isPhoneCare = types[index] == '전화돌봄';

                                return GestureDetector(
                                  onTap: () async {
                                    if (isPhoneCare) {
                                      // 전화돌봄일 때 전화 걸기
                                      final phoneUrl = Uri.parse('tel:${phones[index]}');
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
                                            name: names[index],
                                            address: addresses[index],
                                            phone: phones[index],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              /// 방문자 정보 영역
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    /// 방문 유형 라벨 (전화돌봄/현장돌봄)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: isPhoneCare 
                                                            ? const Color(0xFFFFF3CD) // 전화돌봄 - 개나리색 배경
                                                            : const Color(0xFFFFEBEE), // 현장돌봄 - 빨간색 배경
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: isPhoneCare
                                                              ? const Color(0xFFE65100) // 전화돌봄 - 진한 주황색 테두리
                                                              : const Color(0xFFD32F2F), // 현장돌봄 - 빨간색 테두리
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        types[index],
                                                        style: TextStyle(
                                                          color: isPhoneCare
                                                              ? const Color(0xFFE65100) // 전화돌봄 - 진한 주황색 텍스트
                                                              : const Color(0xFFD32F2F), // 현장돌봄 - 빨간색 텍스트
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    /// 이름과 시간을 같은 줄에 배치
                                                    Row(
                                                      children: [
                                                        /// 방문자 이름 (bold체)
                                                        Text(
                                                          names[index],
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                                        /// 방문 시간 (회색)
                                                        Text(
                                                          times[index],
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    /// 주소 또는 전화번호 정보
                                                    Text(
                                                      isPhoneCare 
                                                          ? phones[index]    // 전화돌봄일 때 전화번호 표시
                                                          : addresses[index], // 현장돌봄일 때 주소 표시
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              /// 전화돌봄일 때 전화 아이콘, 현장돌봄일 때 화살표 아이콘
                                              Icon(
                                                isPhoneCare ? Icons.phone : Icons.arrow_forward_ios,
                                                color: const Color(0xFFFB5457),
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              /// 새 방문 추가 버튼
                              Container(
                                margin: const EdgeInsets.only(bottom: 12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO: 새로운 방문 추가
                                        print('새로운 방문 추가 버튼 클릭');
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFB5457),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }
}