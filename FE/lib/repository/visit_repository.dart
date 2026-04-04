import 'package:safe_hi/model/visit_detail_model.dart';
import 'package:safe_hi/model/visit_model.dart';
import 'package:safe_hi/service/visit_service.dart';

class VisitRepository {
  final VisitService service;

  VisitRepository({required this.service});

  /// 오늘 방문 목록
  Future<List<Visit>> getTodayVisits() => VisitService.fetchTodayVisits();

  /// 특정 날짜 방문 목록
  Future<List<Visit>> getVisitsByDate(String date) =>
      VisitService.fetchVisitsByDate(date);

  // Future<Visit> getVisitDetail(int visitId) =>
  //     VisitService.fetchVisitDetail(visitId);

  /// 방문 상세
  Future<VisitDetail> getVisitDetail(int reportId) {
    return service.getTargetDetail(reportId);
  }
}
