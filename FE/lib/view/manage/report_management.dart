import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

import 'package:safe_hi/view/report/widget/summary_strip.dart';
import 'package:safe_hi/view/report/widget/report_search_bar.dart';


import '../../widget/appbar/default_appbar.dart';
import '../report/target_card.dart';
import '../report/widget/target_card_data.dart';

class ReportManagementPage extends StatefulWidget {
  const ReportManagementPage({super.key});

  @override
  State<ReportManagementPage> createState() => _ReportManagementPageState();
}

class _ReportManagementPageState extends State<ReportManagementPage> {
  // 더미 대상자 데이터 - 추후 API 연동 필요
  final List<TargetCardData> _allTargets = [
    const TargetCardData(name: '김민수', address: '제주시 연동 1274,\n푸른섬아파트 101동 803호', status: '3건', emoji: '🧓'),
    const TargetCardData(name: '오하이', address: '제주시 삼도이동 45-7, \n은하주택 1동 201호', status: '2건', emoji: '👵'),
    const TargetCardData(name: '이유진', address: '제주시 오라삼동 321-8, \n해송주택 2동 101호', status: '3건', emoji: '👩‍🦳'),
    const TargetCardData(name: '김예빈', address: '제주시 아라동 432-5, \n돌담주택 201호', status: '3건', emoji: '👩‍🦳'),
    const TargetCardData(name: '홍길동', address: '제주시 노형로 12,\n한별아파트 304동 1201호', status: '3건', emoji: '🧑‍🦳'),
    const TargetCardData(name: '박철수', address: '제주시 중앙로 55,\n한라오피스텔 902호', status: '1건', emoji: '👨‍🦳'),
  ];

  // 필터링된 대상자 리스트
  List<TargetCardData> _filteredTargets = [];

  @override
  void initState() {
    super.initState();
    _filteredTargets = _allTargets; // 초기에는 전체 목록 표시
  }

  /// 검색 결과 업데이트
  void _updateSearchResults(List<TargetCardData> results) {
    setState(() {
      _filteredTargets = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 앱바
              const DefaultAppBar(title: '통합 리포트'),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.itemSpacing),

                    // 통계 요약 스트립
                    SummaryStrip(
                      r: r,
                      totalTarget: 7, // 더미값 - 백엔드 연동 필요
                      totalReport: 12, // 더미값 - 백엔드 연동 필요
                      items: const [
                        SummaryItem(icon: Icons.call,           label: '전화돌봄', count: 5), // 더미값
                        SummaryItem(icon: Icons.home_rounded,   label: '방문돌봄', count: 6), // 더미값
                        SummaryItem(icon: Icons.local_taxi_rounded, label: '긴급출동', count: 1), // 더미값
                      ],
                    ),

                    SizedBox(height: r.itemSpacing),

                    // 검색창
                    ReportSearchBar(
                      r: r,
                      onSearch: _updateSearchResults,  // 검색 콜백 함수
                      allTargets: _allTargets,         // 전체 대상자 리스트
                    ),

                    SizedBox(height: r.sectionSpacing / 1.5),

                    // 대상자 카드 그리드
                    Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredTargets.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: r.itemSpacing,
                          crossAxisSpacing: r.itemSpacing,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (_, i) => TargetCard(r: r, data: _filteredTargets[i]),
                      ),
                    ),

                    SizedBox(height: r.sectionSpacing * 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
