import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/policy_model.dart';
import 'package:safe_hi/model/welfare_policy_model.dart';
import 'package:safe_hi/util/http_helper.dart';

const String baseUrl = ApiConfig.baseUrl;

/// 복지 정책 관련 API 통신을 담당하는 서비스 클래스
class WelfareService {
  /// 복지 정책 데이터 조회
  Future<Map<String, dynamic>> fetchWelfarePoliciesData(int targetId) async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/db/welfare-policies/$targetId'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load welfare policies');
    }

    // 더미 응답 데이터
    // return {
    //   "id": 1,
    //   "age": 25,
    //   "region": "서울",
    //   "policy": [
    //     {
    //       "policy_name": "노인 의료비 지원",
    //       "short_description": "무릎통증 등 병원 방문 비용 지원",
    //       "detailed_conditions": ["외과 진료기록", "보험납부 확인서"],
    //       "link": "https://www.naver.com/",
    //     },
    //     {
    //       "policy_name": "에너지 바우처!!!",
    //       "short_description": "난방비 지원",
    //       "detailed_conditions": ["전기세 납부 확인서"],
    //       "link": "https://www.energyv.or.kr/",
    //     },
    //   ],
    // };
  }

  /// 정책 확인 상태 업로드
  Future<void> uploadPolicyCheckStatus({
    required int reportId,
    required List<Map<String, dynamic>> policyList,
  }) async {
    final url = Uri.parse('$baseUrl/db/uploadCheckPolicy');
    final headers = await buildAuthHeaders();

    final body = {
      'reportid': reportId,
      'policy': policyList,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    debugPrint('[정책 업로드 응답 코드] ${response.statusCode}');
    debugPrint('[정책 업로드 응답 본문] ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        debugPrint('정책 업로드 성공');
        return;
      } else {
        throw Exception('서버 응답 실패: ${data['message'] ?? '상세 메시지 없음'}');
      }
    } else {
      throw Exception('HTTP 오류: ${response.statusCode}');
    }
  }

  /// 모든 복지정책 조회
  Future<List<WelfarePolicy>> getAllWelfarePolicies() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/welfare-policies'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return WelfarePolicy.listFromJson(data);
    } else {
      throw Exception('복지정책 목록 조회 실패: ${response.statusCode}');
    }
  }

  /// 특정 복지정책 조회
  Future<WelfarePolicy> getWelfarePolicy(int policyId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/welfare-policies/$policyId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return WelfarePolicy.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('복지정책 조회 실패: ${response.statusCode}');
    }
  }

  /// 유저의 복지정책 업데이트
  Future<void> updateUserWelfarePolicies(
    int userId,
    List<dynamic> policy,
  ) async {
    final headers = await buildAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/db/welfare-policies/$userId'),
      headers: headers,
      body: jsonEncode({'policy': policy}),
    );
    if (response.statusCode != 200) {
      throw Exception('복지정책 업데이트 실패: ${response.statusCode}');
    }
  }

  /// 유저의 처리완료된 복지 데이터 조회
  Future<Map<String, dynamic>> getWelfareDatas(int userId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/welfare-datas/$userId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('복지 데이터 조회 실패: ${response.statusCode}');
    }
  }

  /// 복지 데이터 업데이트
  Future<void> updateWelfareDatas(int userId, List<dynamic> policy) async {
    final headers = await buildAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/db/welfare-datas/$userId'),
      headers: headers,
      body: jsonEncode({'policy': policy}),
    );
    if (response.statusCode != 200) {
      throw Exception('복지 데이터 업데이트 실패: ${response.statusCode}');
    }
  }

  /// 정책 정보 조회
  Future<PolicyModel> getPolicy(int policyId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/policies/$policyId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return PolicyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('정책 조회 실패: ${response.statusCode}');
    }
  }

  /// 정책 생성
  Future<PolicyModel> createPolicy(Map<String, dynamic> data) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/policies'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PolicyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('정책 생성 실패: ${response.statusCode}');
    }
  }

  /// 정책 업데이트
  Future<PolicyModel> updatePolicy(
    int policyId,
    Map<String, dynamic> data,
  ) async {
    final headers = await buildAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/db/policies/$policyId'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return PolicyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('정책 업데이트 실패: ${response.statusCode}');
    }
  }

  /// 정책 삭제
  Future<void> deletePolicy(int policyId) async {
    final headers = await buildAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/db/policies/$policyId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('정책 삭제 실패: ${response.statusCode}');
    }
  }
}
