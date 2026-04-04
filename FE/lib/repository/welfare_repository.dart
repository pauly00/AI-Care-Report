import 'package:safe_hi/service/welfare_service.dart';
import 'package:safe_hi/model/welfare_policy_model.dart';

class WelfareRepository {
  final WelfareService _service;

  WelfareRepository(this._service);

  Future<List<WelfarePolicy>> fetchWelfarePolicies(int targetId) async {
    final rawData = await _service.fetchWelfarePoliciesData(targetId);

    final policyList = rawData['policy'] as List<dynamic>;

    return policyList.map((item) => WelfarePolicy.fromJson(item)).toList();
  }

  Future<void> uploadPolicyCheckStatus({
    required int reportId,
    required List<Map<String, dynamic>> policyList,
  }) {
    return _service.uploadPolicyCheckStatus(
      reportId: reportId,
      policyList: policyList,
    );
  }
}
