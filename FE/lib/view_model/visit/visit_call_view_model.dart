import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safe_hi/service/visit_service.dart';

class VisitCallViewModel extends ChangeNotifier {
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  bool _isUploaded = false;
  bool get isUploaded => _isUploaded;

  /// 파일 업로드 진행
  Future<void> uploadCallRecord({
    required int reportId,
    required File audioFile,
  }) async {
    _isUploading = true;
    notifyListeners();

    try {
      await VisitService.uploadCallRecord(
        reportId: reportId,
        audioFile: audioFile,
      );
      _isUploaded = true;
    } catch (e) {
      debugPrint('녹음 파일 업로드 실패: $e');
      _isUploaded = false;
      rethrow; // 에러 다시 던지기 (UI에서 핸들링 가능)
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// 업로드 상태 초기화 (필요시)
  void resetUploadState() {
    _isUploaded = false;
    notifyListeners();
  }
}
