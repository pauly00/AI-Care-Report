import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_hi/repository/welfare_repository.dart';
import 'package:safe_hi/service/welfare_service.dart';
import 'package:safe_hi/model/welfare_policy_model.dart';

class VisitPolicyViewModel extends ChangeNotifier {
  bool isLoading = false;
  final repo = WelfareRepository(WelfareService());

  Future<List<WelfarePolicy>> fetchWelfarePolicies(int reportId) async {
    isLoading = true;
    notifyListeners();

    try {
      final policyList = await repo.fetchWelfarePolicies(reportId);
      for (var p in policyList) {
        debugPrint(
            '[정책 로드] id: ${p.id}, name: ${p.policyName}, checkStatus: ${p.checkStatus}');
      }
      return policyList;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPolicyCheckStatus({
    required int reportId,
    required List<WelfarePolicy> policies,
  }) async {
    final policyList = policies
        .map((p) => {
              'id': p.id,
              'checkStatus': p.checkStatus,
            })
        .toList();

    debugPrint('[업로드할 정책 체크 데이터] ${jsonEncode({
          'reportid': reportId,
          'policy': policyList,
        })}');

    await repo.uploadPolicyCheckStatus(
      reportId: reportId,
      policyList: policyList,
    );
  }
}
