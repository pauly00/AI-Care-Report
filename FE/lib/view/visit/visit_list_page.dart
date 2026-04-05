import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/visit/visit_confirm_check.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
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
                          child: Consumer<VisitViewModel>(
                            builder: (context, visitVM, _) {
                              if (visitVM.isLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              return ValueListenableBuilder<SelectedButton>(
                                valueListenable: _selectedButtonNotifier,
                                builder: (context, selectedButton, _) {
                                  final filteredVisits = visitVM.visits.where((visit) {
                                    if (selectedButton == SelectedButton.all) return true;
                                    if (visit.visitType == null) return selectedButton == SelectedButton.field;
                                    if (selectedButton == SelectedButton.phone) return visit.visitType == 0;
                                    return visit.visitType == 1;
                                  }).toList();

                                  if (filteredVisits.isEmpty) {
                                    return const Center(
                                      child: Text('선택한 조건의 방문 일정이 없습니다.'),
                                    );
                                  }

                                  return ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                    itemCount: filteredVisits.length,
                                    itemBuilder: (context, index) {
                                      final visit = filteredVisits[index];
                                      final isPhoneCare = (visit.visitType ?? 1) == 0;
                                      final address =
                                          '${visit.address} ${visit.addressDetails}'.trim();
                                        final rawTime = visit.time;
                                        final candidateTime = rawTime.contains(' ')
                                          ? rawTime.split(' ').last
                                          : rawTime;
                                        final displayTime = candidateTime.length >= 5
                                          ? candidateTime.substring(0, 5)
                                          : candidateTime;

                                      return GestureDetector(
                                        onTap: () async {
                                          if (isPhoneCare) {
                                            final phoneUrl = Uri.parse('tel:${visit.phone}');
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => VisitCheckConfirmPage(
                                                  name: visit.name,
                                                  address: address,
                                                  phone: visit.phone,
                                                  address1: visit.address,
                                                  address2: visit.addressDetails,
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
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: isPhoneCare
                                                              ? const Color(0xFFFFF3CD)
                                                              : const Color(0xFFFFEBEE),
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: isPhoneCare
                                                                ? const Color(0xFFE65100)
                                                                : const Color(0xFFD32F2F),
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          isPhoneCare ? '전화돌봄' : '현장돌봄',
                                                          style: TextStyle(
                                                            color: isPhoneCare
                                                                ? const Color(0xFFE65100)
                                                                : const Color(0xFFD32F2F),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              visit.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                                          Text(
                                                            displayTime,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey.shade500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        isPhoneCare ? visit.phone : address,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  isPhoneCare ? Icons.phone : Icons.arrow_forward_ios,
                                                  color: const Color(0xFFFB5457),
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
      },
    );
  }
}