import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';
import 'package:safe_hi/widget/card/visit_record_card.dart';
import 'package:safe_hi/widget/search/search_bar.dart';
import 'package:safe_hi/view/report/report_1.dart'; // report1 추가

// 미사용, 돌봄 기록 페이지로 대체
class PreviousRecordsPage extends StatelessWidget {
  const PreviousRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final visits = [
      {
        'id': 1,
        'time': '10:00 AM',
        'name': '이유진',
        'address': '대전 서구 대덕대로 150',
        'addressDetails': '경성큰마을아파트 102동 103호',
      },
      {
        'id': 2,
        'time': '11:00 AM',
        'name': '김연우',
        'address': '대전 유성구 테크노 3로 23',
        'addressDetails': '테크노 파크 501호',
      },
      {
        'id': 3,
        'time': '1:00 PM',
        'name': '오민석',
        'address': '대전 중구 계룡로 15',
        'addressDetails': '대전 아파트 202호',
      },
      {
        'id': 4,
        'time': '3:00 PM',
        'name': '한민우',
        'address': '대전 서구 둔산로 123',
        'addressDetails': '푸른숲아파트 102동 1202호',
      },
      {
        'id': 5,
        'tag': '고위험군',
        'time': '3:00 PM',
        'name': '이정선',
        'address': '대전 동구 둔산로 455',
        'addressDetails': '푸른숲아파트 102동 1202호',
      },
      {
        'id': 6,
        'time': '3:00 PM',
        'name': '남예준',
        'address': '대전 서구 둔산로 123',
        'addressDetails': '푸른숲아파트 102동 1202호',
      },
      {
        'id': 7,
        'time': '3:00 PM',
        'name': '이준학',
        'address': '대전 서구 둔산로 123',
        'addressDetails': '푸른숲아파트 102동 1202호',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. AppBar를 Column의 첫 자식으로 두어 전체 너비를 차지하게 함
              const DefaultAppBar(title: '이전 기록'),

              // 2. AppBar를 제외한 나머지 모든 위젯을 새로운 Padding으로 감쌈
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // todo: 임시조치
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
                      child: Text(
                        '안쓰는 페이지(임시조치)',
                        style: TextStyle(
                          fontSize: responsive.fontXL,
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    // 주석 처리된 기존 헤더 부분
                    Padding(
                      padding: EdgeInsets.only(
                        top: responsive.itemSpacing,
                        bottom: responsive.itemSpacing,
                        left: 10.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // children: [ ... ],
                      ),
                    ),
                    SizedBox(height: responsive.sectionSpacing),
                    const VisitSearchBar(),
                    SizedBox(height: responsive.sectionSpacing),
                    Column(
                      children: visits.map((visit) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: responsive.cardSpacing),
                          child: GestureDetector(
                            onTap: () {
                              // todo: 위치 리포트1에서 다른 페이지로 수정 예정
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Report1()),
                              );
                            },
                            child: VisitRecordCard(
                              id: visit['id']! as int,
                              name: visit['name']! as String,
                              address: visit['address']! as String,
                              isTablet: responsive.isTablet,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 이전 방식의 패딩(이전 기록 란도 들어가있음)
          // child: Padding(
          //   padding:
          //       EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const DefaultAppBar(title: '이전 기록'),
          //       // 커스텀 헤더 (DefaultAppBar 대신 사용)
          //       Padding(
          //         padding: EdgeInsets.only(
          //           top: responsive.itemSpacing,
          //           bottom: responsive.itemSpacing,
          //           left: 10.0, // 10px 오른쪽 이동
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           // children: [
          //           //   Image.asset(
          //           //     'assets/images/logoicon.png',
          //           //     width: responsive.iconSize,
          //           //     height: responsive.iconSize,
          //           //   ),
          //           //   SizedBox(width: responsive.itemSpacing / 2),
          //           //   Text(
          //           //     '이전 기록',
          //           //     style: TextStyle(
          //           //       color: const Color(0xFFFB5457),
          //           //       fontWeight: FontWeight.bold,
          //           //       fontSize: responsive.fontLarge,
          //           //     ),
          //           //   ),
          //           // ],
          //         ),
          //       ),
          //       SizedBox(height: responsive.sectionSpacing),
          //       const VisitSearchBar(),
          //       SizedBox(height: responsive.sectionSpacing),
          //       Column(
          //         children: visits.map((visit) {
          //           return Padding(
          //             padding: EdgeInsets.only(bottom: responsive.cardSpacing),
          //             child: GestureDetector( // report1으로 이동하는 로직 추가
          //               onTap: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(builder: (context) => Report1()),
          //                 );
          //               },
          //               child: VisitRecordCard(
          //                 id: visit['id']! as int,
          //                 name: visit['name']! as String,
          //                 address: visit['address']! as String,
          //                 isTablet: responsive.isTablet,
          //               ),
          //             ),
          //           );
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
