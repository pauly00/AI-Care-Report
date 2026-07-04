import 'package:flutter/material.dart';
import 'package:safe_hi/view/home/home_page.dart';
import 'package:safe_hi/view/manage/report_management.dart';
import 'package:safe_hi/view/record/care_report_page.dart';
import 'package:safe_hi/view/visit/visit_list_page.dart';

// 하단 탭 전역 상태 제공자
class BottomNavProvider extends ChangeNotifier {
  // 초기 탭 인덱스
  static int? startupIndex;

  // 현재 탭 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  BottomNavProvider() {
    if (startupIndex != null) {
      _currentIndex = startupIndex!;
      startupIndex = null;
    }
  }

  // 탭별 화면 목록
  final List<Widget> pages = [
    const HomePage(),
    const VisitListPage(),
    const CareReportPage(),
    const ReportManagementPage(),
  ];

  // 탭 변경 함수
  void setIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < pages.length) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}
