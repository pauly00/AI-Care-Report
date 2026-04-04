import 'dart:io';

import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/model/user_model.dart';
import 'package:safe_hi/service/report_service.dart';

class ReportRepository {
  final ReportService service;

  ReportRepository({required this.service});

  Future<List<ReportTarget>> getReportTargets() => service.fetchReportTargets();

  Future<Map<String, dynamic>> uploadDefaultReport({
    required ReportTarget target,
    required UserModel user,
    required String visitType,
    required String endTime,
  }) {
    return service.uploadDefaultReport(
      target: target,
      user: user,
      visitType: visitType,
      endTime: endTime,
    );
  }

  Future<void> uploadVisitDetail({
    required int reportId,
    required String detail,
  }) {
    return service.uploadVisitDetail(reportId: reportId, detail: detail);
  }

  Future<void> uploadImages({
    required int reportId,
    required List<File> imageFiles,
  }) {
    return service.uploadImages(reportId: reportId, imageFiles: imageFiles);
  }

  Future<String> getConversationText(int reportId) {
    return service.getConversationText(reportId);
  }

  Future<File> downloadReport(int reportId) {
    return service.downloadReport(reportId);
  }
}
