import 'package:flutter/material.dart';
import 'package:safe_hi/model/visit_detail_model.dart';
import 'package:safe_hi/model/visit_model.dart';
import 'package:safe_hi/repository/visit_repository.dart';

class VisitViewModel extends ChangeNotifier {
  final VisitRepository repository;
  Visit? visit;

  VisitViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Visit> _visits = [];
  List<Visit> get visits => _visits;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  // 오늘 방문자 가져오기
  Future<void> fetchTodayVisits() async {
    _isLoading = true;
    safeNotify();

    try {
      final data = await repository.getTodayVisits();
      _visits = data;
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      safeNotify();
    }
  }

  // 특정 날짜 방문자 가져오기
  Future<void> fetchVisitsByDate(String date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getVisitsByDate(date);
      _visits = data;
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<VisitDetail> fetchVisitDetail(int reportId) async {
    return await repository.getVisitDetail(reportId);
  }
}
