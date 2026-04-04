import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/model/user_model.dart';
import 'package:safe_hi/repository/report_repository.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportRepository repository;
  ReportViewModel({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ReportTarget> _targets = [];
  List<ReportTarget> get targets => _targets;

  ReportTarget? _selectedTarget;

  void setSelectedTarget(ReportTarget target) {
    _selectedTarget = target;
    notifyListeners();
  }

  ReportTarget? get selectedTarget => _selectedTarget;

  Future<void> fetchTargets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getReportTargets();
      _targets = data;
    } catch (e) {
      debugPrint('Error fetching report targets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> submitReportStep1({
    required String visitType,
    required UserModel user,
    required String endTime,
  }) async {
    if (_selectedTarget == null) {
      throw Exception("선택된 리포트가 없습니다.");
    }

    return await repository.uploadDefaultReport(
      target: _selectedTarget!,
      user: user,
      visitType: visitType,
      endTime: endTime,
    );
  }

  void updateVisitTime(DateTime dateTime) {
    if (_selectedTarget != null) {
      final formatted =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      _selectedTarget = _selectedTarget!.copyWith(visitTime: formatted);
      notifyListeners();
      debugPrint('[visitTime 변경됨] $formatted');
    }
  }

  Future<void> uploadVisitDetail(int reportId, String detail) async {
    await repository.uploadVisitDetail(reportId: reportId, detail: detail);
  }

  Future<void> uploadImages(int reportId, List<File> imageFiles) async {
    await repository.uploadImages(reportId: reportId, imageFiles: imageFiles);
    for (var file in imageFiles) {
      debugPrint('[전송할 이미지] ${file.path}');
    }
  }

  String? _conversationText;
  String? get conversationText => _conversationText;

  Future<void> fetchConversationText(int reportId) async {
    _conversationText = await repository.getConversationText(reportId);
    notifyListeners();
  }

  Future<File> downloadReport(int reportId) async {
    return await repository.downloadReport(reportId);
  }
}
