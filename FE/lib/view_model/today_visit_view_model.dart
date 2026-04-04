import 'package:flutter/material.dart';
import '../model/today_visit.dart';
import '../service/today_visit_service.dart';

class TodayVisitViewModel extends ChangeNotifier {
  List<TodayVisit> _todayVisits = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TodayVisit> get todayVisits => _todayVisits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTodayVisits({
    required String todayDate,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todayVisits = await TodayVisitService.getTodayList(
        todayDate: todayDate,
        token: token,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _todayVisits = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}