import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';

import 'package:safe_hi/main_screen.dart';

import '../manage/report_management.dart';
import '../record/care_report_page.dart';

/// 돌봄 상담 완료 후 보여지는 페이지
class VisitReportPage extends StatelessWidget {
  const VisitReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const DefaultBackAppBar(title: '돌봄 완료'),
      ),

      body: Padding(
        padding: EdgeInsets.all(responsive.paddingHorizontal),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 완료 체크 아이콘
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F5E8),
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: responsive.sectionSpacing),

              // 완료 메시지 제목
              Text(
                "상담이 종료되었습니다",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontXL,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF433A3A),
                ),
              ),
              SizedBox(height: responsive.itemSpacing),

              // 완료 메시지 내용
              Text(
                "저장된 내용을 바탕으로\n돌봄 일지를 확인하거나 홈으로 이동해주세요",
                // TODO: API 연동 필요 - 상담 내용 기반 돌봄 일지 생성 결과에 따라 메시지 분기 처리
                // 성공: "상담 내용을 바탕으로 돌봄 일지를 생성 완료하였습니다"
                // 실패: "돌봄 일지 생성에 실패했습니다. 다시 시도해주세요"
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontBase,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 돌봄 기록 확인하기 버튼 (기록 탭으로 이동)
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // 메인 앱 시작 시 기록 탭(인덱스 2)으로 설정
                      BottomNavProvider.startupIndex = 2;

                      // 메인 화면으로 이동하며 네비게이션 스택 초기화
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFB5457),
                      side: const BorderSide(
                        color: Color(0xFFFB5457),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "돌봄 기록 확인하기",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 홈으로 가기 버튼 (홈 탭으로 이동)
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // 홈 탭(인덱스 0)으로 설정
                      final navProvider = context.read<BottomNavProvider>();
                      navProvider.setIndex(0);

                      // 메인 화면으로 이동하며 네비게이션 스택 초기화
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB5457),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "홈으로 가기",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}