import 'package:flutter/material.dart';
import 'package:safe_hi/model/visit_summary_model.dart';
import 'package:safe_hi/repository/visit_summary_repository.dart';

class VisitSummaryViewModel extends ChangeNotifier {
  final VisitSummaryRepository repository;

  VisitSummaryViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VisitSummary> _summaries = [];
  List<VisitSummary> get summaries => _summaries;

  // 더미값 관련 세팅, 추후 삭제
  set summaries(List<VisitSummary> value) {
    _summaries = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchSummary(int reportId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await repository.getSummary(reportId);
      _summaries = response.items;
    } catch (e) {
      debugPrint('[방문 요약 에러] $e');
      _summaries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAllSummaries(int reportId) async {
    try {
      await repository.uploadEditedSummary(
        reportId: reportId,
        summaries: _summaries,
      );
      debugPrint('[요약 업로드 완료]');
    } catch (e) {
      debugPrint('[요약 업로드 실패] $e');
      rethrow;
    }
  }
}
