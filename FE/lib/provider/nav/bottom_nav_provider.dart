import 'package:flutter/material.dart';
import 'package:safe_hi/view/home/home_page.dart';
import 'package:safe_hi/view/record/care_report_page.dart';
import 'package:safe_hi/view/visit/visit_list_page.dart';
// import 'package:safe_hi/view/record/previous_record_page.dart';
// import 'package:safe_hi/view/mypage/mypage.dart';
import 'package:safe_hi/view/manage/report_management.dart';

class BottomNavProvider extends ChangeNotifier {
  // 다음 생성 시 한 번만 사용할 부팅 인덱스
  static int? startupIndex;
  // 현재 탭 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // 🔹 생성 시 startupIndex가 지정되어 있으면 그걸로 시작
  BottomNavProvider() {
    if (startupIndex != null) {
      _currentIndex = startupIndex!;
      startupIndex = null; // 한 번 쓰고 비움(다음 생성에는 영향 X)
    }
  }

  // 탭별로 보여줄 페이지
  final List<Widget> pages = [
    const HomePage(),
    const VisitListPage(),
    // const PreviousRecordsPage(),
    // const MyPage(),
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
