import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 추가
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view_model/user_view_model.dart'; // UserViewModel 추가
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';

class CareReportDetail extends StatelessWidget {
  final String name; // name 매개변수 추가
  final int count; // count 매개변수 추가

  const CareReportDetail({
    super.key,
    required this.name, // 필수 매개변수로 설정
    required this.count, // 필수 매개변수로 설정
  });

  @override
  Widget build(BuildContext context) {
    final rs = Responsive(context);
    
    // UserViewModel에서 사용자 이름 가져오기
    final userVM = context.watch<UserViewModel>();
    final username = userVM.user?.name ?? '김안심'; // 기본값을 '김안심'으로 설정

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            const DefaultBackAppBar(title: '돌봄 일지'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rs.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 돌봄 결과 타이틀
                    Text(
                      '$name님의 ${count}회차 방문돌봄 결과',
                      style: TextStyle(
                        fontSize: rs.fontBase + 6,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$username 매니저    오전 11:14 ~ 오전 11:55', // 시간은 더미값, 추후 백엔드 연동 필요
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 상담 완료 상태 버튼
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green, width: 1.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        '상담 완료', // 상태값 - 백엔드 연동 필요
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 신체 상태 카드
                    _detailCard(
                      rs,
                      title: '신체 상태',
                      content:
                      '최근 들어 식사량이 줄어 하루 한 끼만 먹는 경우가 잦음. 허리 통증이 지난주보다 심해짐에 따라 이에 대한 조치가 필요해 보임', // 더미값 - 백엔드 연동 필요
                    ),
                    const SizedBox(height: 14),

                    // 생활 환경 카드
                    _detailCard(
                      rs,
                      title: '생활 환경',
                      content:
                      '외출이 줄어들어 주로 집 안에 머무르고 있으며, 운동이나 산책은 거의 하지 않는 상황임. 집안 정리와 청소 상태가 전보다 미흡함', // 더미값 - 백엔드 연동 필요
                    ),
                    const SizedBox(height: 14),

                    // 정서 상태 카드
                    _detailCard(
                      rs,
                      title: '정서 상태',
                      content:
                      '전반적으로 기분은 안정적이지만 대화 중 외로움과 무료함을 자주 표현함', // 더미값 - 백엔드 연동 필요
                    ),
                    const SizedBox(height: 20),

                    // 생활상태 평가
                    _statusRow(),
                    const SizedBox(height: 20),

                    // 메모 카드
                    _detailCard(
                      rs,
                      title: '',
                      content:
                      '대화 중 같은 질문을 반복하는 등 기억력에 어려움이 관찰되어 지속적인 확인이 필요함', // 더미값 - 백엔드 연동 필요
                    ),
                    SizedBox(height: rs.sectionSpacing * 1.5),
                  ],
                ),
              ),
            ),

            // 하단 돌아가기 버튼
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: rs.paddingHorizontal, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB5457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '리스트로 돌아가기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상세 카드 위젯
  Widget _detailCard(Responsive rs,
      {required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(rs.cardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black54,
              ),
            ),
          if (title.isNotEmpty) const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 생활상태 평가 (정상/양호/불량)
  Widget _statusRow() {
    Widget item(String label, String value, Color color) {
      return Expanded(
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: color, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [ // 더미값 - 백엔드 연동 필요
          item('건강상태', '정상', Colors.green),
          item('식사기능', '양호', Colors.green),
          item('인지기능', '불량', Colors.red),
          item('의사소통', '불량', Colors.red),
        ],
      ),
    );
  }
}
