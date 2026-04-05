import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/yangchun_model.dart';
import 'package:safe_hi/util/http_helper.dart';

/// 양천구청 STT 관련 API 통신을 담당하는 서비스 클래스
class YangchunService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 양천구청 STT 원본 텍스트 반환
  Future<String> getYangchunSTTText(int reportId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getYangChunConverstationSTTtxt/$reportId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('양천 STT 텍스트 조회 실패: ${response.statusCode}');
    }
  }

  /// 양천구청 STT 결과 리스트 조회 (JWT 필요)
  Future<List<YangchunResultItem>> getYangchunResultList() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/yangchun_getResultList'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => YangchunResultItem.fromJson(e)).toList();
    } else {
      throw Exception('양천 결과 리스트 조회 실패: ${response.statusCode}');
    }
  }

  /// 양천 STT 요약 및 상담 항목 JSON 조회 (JWT 필요)
  Future<YangchunAbstractResponse> getYangchunAbstract(int id) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/yangchun_stt_abstract/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return YangchunAbstractResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('양천 STT 요약 조회 실패: ${response.statusCode}');
    }
  }

  /// 양천 STT 업로드 시작 (JWT 필요)
  Future<Map<String, dynamic>> uploadYangchunSTT(String sttFileName) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/yangchun_stt_upload'),
      headers: headers,
      body: jsonEncode({'stt_file_name': sttFileName}),
    );
    debugPrint('[양천 STT 업로드] ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('양천 STT 업로드 실패: ${response.statusCode}');
    }
  }

  /// 양천 STT 업로드 (email 포함)
  Future<Map<String, dynamic>> uploadYangchunSTTWithEmail({
    required String sttFileName,
    required String userEmail,
  }) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/yangchun_stt_upload_policy'),
      headers: headers,
      body: jsonEncode({
        'stt_file_name': sttFileName,
        'user_email': userEmail,
      }),
    );
    debugPrint('[양천 STT 업로드(이메일)] ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('양천 STT 업로드(이메일) 실패: ${response.statusCode}');
    }
  }

  /// 양천 ID 카드 신청정보 업로드
  Future<Map<String, dynamic>> uploadYangchunIdCardInfo(
    Map<String, dynamic> data,
  ) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/yangchun_idcard_info_upload'),
      headers: headers,
      body: jsonEncode(data),
    );
    debugPrint('[양천 ID카드 업로드] ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('양천 ID카드 업로드 실패: ${response.statusCode}');
    }
  }
}
