import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/repository/visit_summary_repository.dart';
import 'package:safe_hi/service/visit_summary_service.dart';
import 'package:safe_hi/view/report/report_2_new.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/view_model/visit_summary_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/model/user_model.dart';

/// 돌봄 리포트 1단계 화면 - 기본 정보 입력 및 수정
class Report1New extends StatefulWidget {
  const Report1New({
    super.key,
    required this.targetName, // TargetCard에서 전달받을 이름
    required this.address, // TargetCard에서 전달받을 주소
  });

  final String targetName; // 이름
  final String address; // 주소

  @override
  State<Report1New> createState() => _Report1NewState();
}

class _Report1NewState extends State<Report1New> {
  DateTime? _visitDateTime;
  DateTime? _endDateTime;
  String _careType = '정기 방문';

  /// 공통 색상
  static const Color _primaryRed = Color(0xFFFB5457);
  static const Color _borderPink = Color(0xFFF5CED1);
  static const Color _labelGray = Color(0xFF9E9E9E);
  static const Color _titleGray = Color(0xFF4A4A4A);

  @override
  void initState() {
    super.initState();
    _endDateTime = DateTime.now();
  }

  /// 어르신 프로필 섹션
  Widget elderProfileSection({
    required String name,
    required String address,
    required String phone,
    required String birth,
    required String gender,
    EdgeInsetsGeometry margin = const EdgeInsets.only(top: 0),
  }) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '어르신 프로필',
            style: TextStyle(
              color: _primaryRed,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _infoRow('주소', address),
                const SizedBox(height: 8),
                _infoRow('전화번호', phone),
                const SizedBox(height: 8),
                _infoRow('생년월일', birth),
                const SizedBox(height: 8),
                _infoRow('성별', gender),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 돌봄 매니저 프로필 섹션
  Widget managerProfileSection({
    required String managerName,
    required String affiliation,
    required String phone,
    EdgeInsetsGeometry margin = const EdgeInsets.only(top: 24),
  }) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '돌봄 매니저 프로필',
            style: TextStyle(
              color: _primaryRed,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  managerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _infoRow('소속', affiliation),
                const SizedBox(height: 8),
                _infoRow('전화번호', phone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 돌봄 횟수 섹션
  Widget careCountSection({
    required int visitCount,
    required int callCount,
    EdgeInsetsGeometry margin = const EdgeInsets.only(top: 24),
  }) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '돌봄 횟수',
            style: TextStyle(
              color: _primaryRed,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _whiteCard(
            child: Row(
              children: [
                Expanded(
                  child: _countPill(label: '방문돌봄', countText: '${visitCount}회'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _countPill(label: '전화돌봄', countText: '${callCount}회'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 라벨/값 2열 행 위젯
  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _labelGray,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _titleGray,
            ),
          ),
        ),
      ],
    );
  }

  /// 흰색 카드 위젯
  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderPink, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33F5CED1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// 돌봄 횟수 Pill 위젯
  Widget _countPill({required String label, required String countText}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFE9E2E2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _titleGray,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            countText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// 날짜/시간 선택 위젯 빌더
  Widget _buildDateTimePicker({
    required String label,
    required DateTime dateTime,
    required void Function(DateTime) onPicked,
    required Responsive responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.fontBase,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: dateTime,
              firstDate: DateTime(2023),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(dateTime),
              );
              if (pickedTime != null) {
                final result = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                onPicked(result);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F6F6),
              border: Border.all(color: const Color(0xFFEBE7E7)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              dateTime.toString().substring(0, 16).replaceAll("T", " "),
              style: TextStyle(
                color: Colors.black,
                fontSize: responsive.fontBase,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final report = Provider.of<ReportViewModel>(context).selectedTarget;

    // Provider를 통한 상태 관리
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? 'OOO'; // 사용자 이름 가져오기

    // report가 null인 경우에만 더미값 설정
    if (report == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // TargetCard에서 전달받은 이름과 주소 사용, 나머지는 더미값
        final dummyTarget = ReportTarget( // 더미값 - 백엔드 연동 필요
          reportId: 9999,
          reportStatus: 9999,
          visitTime: '2025-08-01 10:00',
          targetId: 9999,
          targetName: widget.targetName, // TargetCard에서 전달받은 이름 사용
          address1: widget.address, // TargetCard에서 전달받은 주소를 address1에 모두 넣기
          address2: '', // address2는 빈 문자열로 처리(추후 정리 필요)
          phone: '010-1234-5678', // 더미값
          age: 77, // 더미값
          gender: 1, // 더미값
        );
        Provider.of<ReportViewModel>(context, listen: false).setSelectedTarget(dummyTarget);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: report == null
                  ? Center(
                child: Text(
                  "대상이 없습니다.",
                  style: TextStyle(
                      fontSize: responsive.fontBase,
                      color: Colors.black54),
                ),
              )
                  : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 단계 헤더
                      const ReportStepHeader(
                        currentStep: 1,
                        totalSteps: 5,
                        stepTitle: 'step 1',
                        stepSubtitle: '기본 정보',
                      ),

                      SizedBox(height: responsive.sectionSpacing),

                      // 프로필 및 정보 섹션들
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          elderProfileSection(
                            name: report.targetName, // TargetCard에서 전달받은 이름 사용
                            address: report.address1, // address1만 사용 (address2는 null이므로)
                            phone: report.phone,
                            birth: '1955.04.02', // 더미값 - 백엔드 연동 필요
                            gender: report.gender == 1 ? '남' : '여',
                          ),
                          managerProfileSection(
                            managerName: '$username 돌봄 매니저', // Provider에서 가져온 실제 사용자명
                            affiliation: '제주 이도 2동 담당', // 더미값 - 백엔드 연동 필요
                            phone: userVM.user?.phoneNumber ?? '010-1234-5678', // Provider에서 가져온 실제 전화번호
                          ),
                          careCountSection(
                            visitCount: 2, // 더미값 - 백엔드 연동 필요
                            callCount: 2, // 더미값 - 백엔드 연동 필요
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '다음',
          onButtonTap: () async {
            // 실제 사용자 정보 확인
            debugPrint("현재 사용자: ${userVM.user?.name}");
            debugPrint("현재 선택된 타겟: ${report?.targetName}");
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => VisitSummaryViewModel(
                    repository: VisitSummaryRepository(service: VisitSummaryService()),
                  )..fetchSummary(report!.reportId),
                  child: const Report2New(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}