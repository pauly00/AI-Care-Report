import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/repository/visit_summary_repository.dart';
import 'package:safe_hi/service/visit_summary_service.dart';
import 'package:safe_hi/view/report/report_1_1.dart';
import 'package:safe_hi/view/report/report_2.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/view_model/visit_summary_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/model/report_model.dart'; // 더미 모델 가져오기
import 'package:safe_hi/model/user_model.dart'; // 더미 유저 가져오기

// 돌봄 리포트 1단계 화면 - 기본 정보 입력 및 수정(미사용)
class Report1 extends StatefulWidget {
  const Report1({super.key});

  @override
  State<Report1> createState() => _Report1State();
}

class _Report1State extends State<Report1> {
  // 편집 모드 활성화 여부
  bool _isEditing = false;
  // 방문 시작 시간
  DateTime? _visitDateTime;
  // 방문 종료 시간
  DateTime? _endDateTime;
  // 돌봄 유형 (정기방문, 긴급방문 등)
  String _careType = '정기 방문';

  @override
  void initState() {
    super.initState();
    _endDateTime = DateTime.now(); // 초기 endTime 값 설정
  }

  // 날짜/시간 선택 위젯 빌더
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
          label, // "시작시간" 또는 "종료시간" 라벨 표시
          style: TextStyle(
            fontSize: responsive.fontBase, // 라벨 폰트 크기
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 6), // 라벨과 박스 사이 간격
        GestureDetector(
          onTap: () async {
            // 날짜 선택 다이얼로그
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: dateTime,
              firstDate: DateTime(2023),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              // 시간 선택 다이얼로그
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
                fontSize: responsive.fontBase, // 날짜/시간 폰트 크기
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

    // 더미값 설정 (개발용)
    if (report == null) { // 더미값 추가
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 동행 매니저 더미 데이터
        final dummyUser = UserModel(
          userId: 9999,
          name: '홍길동',
          email: 'test@example.com',
          phoneNumber: '010-1234-5678',
          birthDate: '1950-01-01',
          gender: 1,
          etc: '',
          role: 1,
        );

        Provider.of<UserViewModel>(context, listen: false).setUser(dummyUser);

        // 어르신 프로필 더미 데이터
        final dummyTarget = ReportTarget(
          reportId: 9999,
          reportStatus: 9999,
          visitTime: '2025-08-01 10:00',
          targetId: 9999,
          targetName: '테스트',
          address1: '대전광역시 유성구 OO동',
          address2: '경로당 1층',
          phone: '010-1234-5678',
          age: 77,
          gender: 1,
        );
        Provider.of<ReportViewModel>(context, listen: false).setSelectedTarget(dummyTarget);
      });
    }

    debugPrint("Report1에서 읽은 selectedTarget: $report");

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
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
                      // 단계 헤더와 수정 버튼
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const ReportStepHeader(
                            currentStep: 1,
                            totalSteps: 6,
                            stepTitle: 'step 1',
                            stepSubtitle: '기본 정보',
                          ),
                          // 수정 버튼
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: responsive.modifyButton,
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsive.cardSpacing),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4F4),
                                borderRadius: BorderRadius.circular(6),
                                border:
                                Border.all(color: Color(0xFFFB5457)),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(
                                          () => _isEditing = !_isEditing);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: AnimatedSwitcher(
                                  duration:
                                  const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                          opacity: animation,
                                          child: child),
                                  child: Row(
                                    key: ValueKey(_isEditing),
                                    children: [
                                      Icon(Icons.edit_note_rounded,
                                          size: responsive.iconSize * 0.6,
                                          color: Color(0xFFFB5457)),
                                      SizedBox(width: 4),
                                      Text(
                                        '수정',
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontSmall,
                                            color: Color(0xFFFB5457)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.sectionSpacing),

                      // 메인 정보 카드
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(responsive.cardSpacing),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFDD8DA),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 어르신 프로필 섹션
                            Text('어르신 프로필',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: responsive.fontLarge)),
                            SizedBox(height: responsive.itemSpacing),
                            Text(
                              '${report.targetName}(${report.gender == 1 ? '남' : '여'}, 만 ${report.age}세)',
                              style: TextStyle(
                                  fontSize: responsive.fontBase),
                            ),
                            SizedBox(height: responsive.itemSpacing / 2),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 120,
                                    child: Text('주소',
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontBase))),
                                Expanded(
                                    child: Text(report.address1,
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontBase))),
                              ],
                            ),
                            SizedBox(height: responsive.itemSpacing / 2),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 120,
                                    child: Text('전화번호',
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontBase))),
                                Expanded(
                                    child: Text(report.phone,
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontBase))),
                              ],
                            ),
                            SizedBox(height: responsive.itemSpacing),

                            // 동행 매니저 프로필 섹션
                            Text('동행 매니저 프로필',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: responsive.fontLarge)),
                            SizedBox(height: responsive.itemSpacing),
                            Text(
                              '${Provider.of<UserViewModel>(context).user?.name ?? '이름없음'} 동행 매니저',
                              style: TextStyle(
                                  fontSize: responsive.fontBase),
                            ),
                            SizedBox(height: responsive.itemSpacing / 2),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text('대전 지부 OOO동 담당',
                                        style: TextStyle(
                                            fontSize:
                                            responsive.fontBase))),
                              ],
                            ),
                            SizedBox(height: responsive.itemSpacing),

                            // 돌봄 진행 일시 섹션
                            Text('돌봄 진행 일시',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: responsive.fontLarge)),
                            SizedBox(height: responsive.itemSpacing / 2),
                            // 편집 모드에 따른 UI 변경
                            _isEditing
                                ? Row(
                              children: [
                                Expanded(
                                    child: _buildDateTimePicker(
                                      label: "시작시간",
                                      dateTime: _visitDateTime ??
                                          DateTime.tryParse(report
                                              .visitTime
                                              .replaceAll(" ", "T")) ??
                                          DateTime.now(),
                                      onPicked: (picked) {
                                        setState(() =>
                                        _visitDateTime = picked);
                                        context
                                            .read<ReportViewModel>()
                                            .updateVisitTime(picked);
                                      },
                                      responsive: responsive,
                                    )),
                                SizedBox(width: 8),
                                Text("~",
                                    style: TextStyle(
                                        fontSize:
                                        responsive.fontBase)),
                                SizedBox(width: 8),
                                Expanded(
                                    child: _buildDateTimePicker(
                                      label: "종료시간",
                                      dateTime: _endDateTime!,
                                      onPicked: (picked) {
                                        setState(() =>
                                        _endDateTime = picked);
                                      },
                                      responsive: responsive,
                                    )),
                              ],
                            )
                                : Text(
                              '${_visitDateTime?.toString().substring(0, 16).replaceAll("T", " ") ?? report.visitTime} ~ ${_endDateTime?.toString().substring(0, 16).replaceAll("T", " ")}',
                              style: TextStyle(
                                  fontSize: responsive.fontBase),
                            ),
                            SizedBox(height: responsive.itemSpacing),

                            // 돌봄 유형 섹션
                            Text('돌봄 유형',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: responsive.fontLarge)),
                            SizedBox(height: responsive.itemSpacing / 2),
                            // 편집 모드에 따른 UI 변경 (드롭다운 또는 텍스트)
                            _isEditing
                                ? DropdownButton<String>(
                              value: _careType,
                              items: [
                                DropdownMenuItem(
                                  value: '정기 방문',
                                  child: Text('정기 방문',
                                      style: TextStyle(
                                          fontSize:
                                          responsive.fontBase)),
                                ),
                                DropdownMenuItem(
                                  value: '긴급 방문',
                                  child: Text('긴급 방문',
                                      style: TextStyle(
                                          fontSize:
                                          responsive.fontBase)),
                                ),
                                DropdownMenuItem(
                                  value: '전화 방문',
                                  child: Text('전화 방문',
                                      style: TextStyle(
                                          fontSize:
                                          responsive.fontBase)),
                                ),
                                DropdownMenuItem(
                                  value: '기타',
                                  child: Text('기타',
                                      style: TextStyle(
                                          fontSize:
                                          responsive.fontBase)),
                                ),
                              ],
                              onChanged: (value) => setState(
                                      () => _careType = value!),
                            )
                                : Text(_careType,
                                style: TextStyle(
                                    fontSize: responsive.fontBase)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // 하단 버튼 (저장/다음)
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: _isEditing ? '저장' : '다음',
          onButtonTap: () async {
            // 편집 모드일 때는 저장하고 편집 모드 종료
            if (_isEditing) {
              setState(() => _isEditing = false);
              return;
            }

            // ViewModel에서 데이터 가져오기
            final reportVM = context.read<ReportViewModel>();
            final userVM = context.read<UserViewModel>();
            final user = userVM.user;
            final target = reportVM.selectedTarget;

            // 서버 접속 시 사용할 유효성 검사 (현재 주석처리)
            // if (user == null || target == null) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text('유저 정보 또는 대상자가 없습니다.')),
            //   );
            //   return;
            // }

            try {
              // 업로드 요청 로그 출력 (더미 값 포함)
              debugPrint(
                  '[STEP1 업로드 요청] target: ${target?.targetName ?? '더미'}, user: ${user?.name ?? '더미'}, visitType: $_careType');

              // 서버 업로드 (현재 주석처리)
              // final result = await reportVM.submitReportStep1(
              //   endTime: _endDateTime!.toString().substring(0, 16),
              //   visitType: _careType,
              //   user: user!, // null값 임의로 지정
              // );
              //
              // debugPrint('[STEP1 업로드 결과] $result');

              // 다음 화면으로 강제 이동 (개발용)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => VisitSummaryViewModel(
                      repository: VisitSummaryRepository(service: VisitSummaryService()),
                    )..fetchSummary(report!.reportId),
                    child: const Report1_1(),
                  ),
                ),
              );

              // 서버 연동 시 사용할 정상 처리 로직 (현재 주석처리)
              // if (result['status'] == true) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => ChangeNotifierProvider(
              //         create: (_) => VisitSummaryViewModel(
              //           repository: VisitSummaryRepository(
              //               service: VisitSummaryService()),
              //         )..fetchSummary(report!.reportId),
              //         child: const Report2(),
              //       ),
              //     ),
              //   );
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text(result['msg'] ?? '업로드 실패')),
              //   );
              // }
            } catch (e) {
              // 에러 처리
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('업로드 중 오류 발생: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}
