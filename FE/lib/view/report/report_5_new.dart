import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:safe_hi/main_screen.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart'; // BottomOneButton을 BottomTwoButton으로 변경
import 'package:safe_hi/util/responsive.dart';

/// 돌봄 리포트 5단계 화면 - 리포트 다운로드 및 공유
class Report5New extends StatelessWidget {
  const Report5New({super.key});

  /// 리포트 공유 - 파일 다운로드 후 공유 기능
  Future<void> _shareReport(BuildContext context, int reportId) async {
    try {
      final file = await context.read<ReportViewModel>().downloadReport(reportId); // PDF를 반환해야 함 - 추후 백엔드 연동 필요
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: '돌봄 리포트를 공유합니다.',
      );
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공유가 완료되었습니다!')),
        );
      }
    } catch (e) {
      debugPrint('❌ 공유 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공유 실패: $e')),
      );
    }
  }

  /// 리포트 다운로드 후 열기
  Future<void> _downloadAndOpen(BuildContext context, int reportId) async {
    try {
      final file = await context.read<ReportViewModel>().downloadReport(reportId); // PDF 파일 경로 - 추후 백엔드 연동 필요
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('다운로드 완료: ${file.path}')),
      );
      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint('❌ 다운로드 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('다운로드 실패: $e')),
      );
    }
  }

  /// 완료 확인 다이얼로그 - 메인 페이지로 이동
  Future<void> _showCompleteConfirmDialog(BuildContext context) async {
    const primaryRed = Color(0xFFFB5457);
    const lightPink  = Color(0xFFFFF3F3); // 아주 연한 핑크 배경

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor: lightPink,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: primaryRed, width: 1.5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목
              const Text(
                '메인 페이지로 돌아가시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 22),

              // 버튼 2개 (취소 / 확인)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context), // 취소: 닫기만
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryRed, width: 1.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 다이얼로그 닫기

                        // 메인 화면으로 이동 - 추후 네비게이션 상태 관리 필요
                        // Provider.of<BottomNavProvider>(context, listen: false).setIndex(3);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);
    final reportId = context.watch<ReportViewModel>().selectedTarget?.reportId;
    
    // 표기용 타이틀 더미값 - 추후 실제 데이터로 교체 필요
    const titleText = '오하이님의 8월 통합 리포트'; // 더미값
    const subtitleText = '완성된 파일을 다운받아 확인해보세요!'; // 더미값

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 단계 헤더
                    const ReportStepHeader(
                      currentStep: 5,
                      totalSteps: 5,
                      stepTitle: 'step 5',
                      stepSubtitle: '리포트 다운로드',
                    ),
                    SizedBox(height: rs.sectionSpacing * 2),

                    // 리포트 완성 타이틀/부제
                    Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: rs.fontBase + 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: rs.fontSmall + 1,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: rs.sectionSpacing * 2),

                    // 액션 카드 버튼 (공유/다운로드)
                    Row(
                      children: [
                        Expanded(
                          child: _pinkActionCard(
                            rs: rs,
                            icon: Icons.upload, // 공유 아이콘
                            label: '공유하기',
                            onTap: reportId == null
                                ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('리포트 ID가 없습니다.')),
                            )
                                : () => _shareReport(context, reportId),
                          ),
                        ),
                        SizedBox(width: rs.itemSpacing),
                        Expanded(
                          child: _pinkActionCard(
                            rs: rs,
                            icon: Icons.download_rounded, // 다운로드 아이콘
                            label: '다운로드',
                            onTap: reportId == null
                                ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('리포트 ID가 없습니다.')),
                            )
                                : () => _downloadAndOpen(context, reportId),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rs.sectionSpacing * 2.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 하단 버튼 - 이전과 완료 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: rs.paddingHorizontal),
        child: BottomTwoButton(
          buttonText1: '이전',
          buttonText2: '완료',
          onButtonTap1: () => Navigator.pop(context),
          onButtonTap2: () => _showCompleteConfirmDialog(context),
        ),
      ),
    );
  }
}

/// 핑크 액션 카드 위젯 - 공유/다운로드 버튼
Widget _pinkActionCard({
  required Responsive rs,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Ink(
      padding: EdgeInsets.symmetric(vertical: rs.buttonHeight * 1.25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA), // 연핑크
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: rs.iconSize + 4, color: Colors.black87),
          SizedBox(height: rs.itemSpacing * 0.6),
          Text(
            label,
            style: TextStyle(
              fontSize: rs.fontBase + 2,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}