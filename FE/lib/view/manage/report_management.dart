import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';

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
  List<TargetCardData> _allTargets = [];

  // 필터링된 대상자 리스트
  List<TargetCardData> _filteredTargets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().fetchTargets();
      context.read<VisitViewModel>().fetchTodayVisits();
    });
  }

  /// 검색 결과 업데이트
  void _updateSearchResults(List<TargetCardData> results) {
    setState(() {
      _filteredTargets = results;
    });
  }

  String _emojiByGender(int gender) {
    if (gender == 1) return '👨‍🦳';
    if (gender == 0) return '👩‍🦳';
    return '🧓';
  }

  void _syncTargetCards(ReportViewModel reportVM) {
    final grouped = <int, List<ReportTarget>>{};
    for (final target in reportVM.targets) {
      grouped.putIfAbsent(target.targetId, () => []).add(target);
    }

    final mapped = grouped.values.map((items) {
      final first = items.first;
      final fullAddress = '${first.address1} ${first.address2}'.trim();
      return TargetCardData(
        name: first.targetName,
        address: fullAddress,
        status: '${items.length}건',
        emoji: _emojiByGender(first.gender),
      );
    }).toList();

    final changed = mapped.length != _allTargets.length ||
      mapped.asMap().entries.any((entry) {
        final i = entry.key;
        if (i >= _allTargets.length) return true;
        final current = _allTargets[i];
        final next = entry.value;
        return current.name != next.name ||
          current.address != next.address ||
          current.status != next.status ||
          current.emoji != next.emoji;
      });
    if (changed) {
      _allTargets = mapped;
      _filteredTargets = mapped;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final reportVM = context.watch<ReportViewModel>();
    final visitVM = context.watch<VisitViewModel>();

    _syncTargetCards(reportVM);

    final allReports = reportVM.targets;
    final totalTarget = _allTargets.length;
    final totalReport = allReports.length;

    final hasTypeInReports = allReports.any((item) => item.visitType != null);
    final phoneCareCount = hasTypeInReports
        ? allReports.where((item) => item.visitType == 0).length
        : visitVM.visits.where((item) => item.visitType == 0).length;
    final fieldCareCount = hasTypeInReports
        ? allReports.where((item) => item.visitType == 1).length
        : visitVM.visits.where((item) => item.visitType == 1).length;
    final emergencyCount = allReports.where((item) => item.reportStatus >= 3).length;

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
                      totalTarget: totalTarget,
                      totalReport: totalReport,
                      items: [
                        SummaryItem(icon: Icons.call, label: '전화돌봄', count: phoneCareCount),
                        SummaryItem(icon: Icons.home_rounded, label: '방문돌봄', count: fieldCareCount),
                        SummaryItem(icon: Icons.local_taxi_rounded, label: '긴급출동', count: emergencyCount),
                      ],
                    ),

                    SizedBox(height: r.itemSpacing),

                    // 검색창
                    ReportSearchBar(
                      r: r,
                      onSearch: _updateSearchResults,
                      allTargets: _allTargets,
                    ),

                    SizedBox(height: r.sectionSpacing / 1.5),

                    if (reportVM.isLoading && _allTargets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_filteredTargets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('표시할 대상자가 없습니다.')),
                      )
                    else
                      Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const crossAxisCount = 2;
                            final cardWidth = (constraints.maxWidth - r.itemSpacing) / 2;
                            final aspectRatio = (cardWidth / 230).clamp(0.68, 0.95).toDouble();

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredTargets.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: r.itemSpacing,
                                crossAxisSpacing: r.itemSpacing,
                                childAspectRatio: aspectRatio,
                              ),
                              itemBuilder: (_, i) => TargetCard(r: r, data: _filteredTargets[i]),
                            );
                          },
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
