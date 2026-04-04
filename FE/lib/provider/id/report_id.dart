import 'package:flutter/material.dart';

class ReportIdProvider with ChangeNotifier {
  int? _reportId;

  int? get reportId => _reportId;

  void setReportId(int id) {
    _reportId = id;
    notifyListeners();
  }

  void clear() {
    _reportId = null;
    notifyListeners();
  }
}
