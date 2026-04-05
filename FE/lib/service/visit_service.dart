import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/report_model.dart';
import 'package:safe_hi/model/target_model.dart';
import 'package:safe_hi/model/visit_detail_model.dart';
import 'package:safe_hi/model/visit_model.dart';
import 'package:safe_hi/util/http_helper.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

/// 방문 일정 및 대상자 정보 관련 API 통신을 담당하는 서비스 클래스
class VisitService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 오늘 방문 예정 대상자 목록 조회
  static Future<List<Visit>> fetchTodayVisits() async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/db/getTodayList'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Visit.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load schedule list');
    }
  }

  /// 특정 날짜의 방문 대상자 목록 조회
  static Future<List<Visit>> fetchVisitsByDate(String date) async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/visits?date=$date'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Visit.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load visits for $date');
    }
  }

  /// 방문 대상자 기본 정보 조회
  static Future<Visit> fetchVisitDetail(int targetId) async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/db/getTargetInfo/$targetId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Visit.fromJson(data);
    } else {
      throw Exception('Failed to load target info');
    }
  }

  /// 방문자 상세 정보 조회
  Future<VisitDetail> getTargetDetail(int reportId) async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/db/getTargetInfo/$reportId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return VisitDetail.fromJson(jsonData);
    } else {
      throw Exception('상세 정보 요청 실패: ${response.statusCode}');
    }
  }

  /// 통화 녹음 파일 업로드
  static Future<void> uploadCallRecord({
    required int reportId,
    required File audioFile,
  }) async {
    final uri = Uri.parse('$baseUrl/db/uploadCallRecord');
    final request = http.MultipartRequest('POST', uri);
    final headers = await buildAuthHeaders();

    request.headers.addAll(headers);
    request.fields['reportid'] = reportId.toString();

    // 오디오 파일 확장자에 따른 MIME 타입 설정
    final ext = path.extension(audioFile.path).toLowerCase();
    String? mimeSubtype;

    if (ext == '.wav') {
      mimeSubtype = 'wav';
    } else if (ext == '.mp3') {
      mimeSubtype = 'mpeg';
    } else if (ext == '.m4a') {
      mimeSubtype = 'x-m4a';
    } else if (ext == '.webm') {
      mimeSubtype = 'webm';
    } else {
      // 확장자가 없으면 기본값으로 mp3 설정
      mimeSubtype = 'mp3';
      debugPrint('확장자 없음 → 기본으로 audio/mpeg으로 설정');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'audiofile',
        audioFile.path,
        filename:
            '${path.basename(audioFile.path)}${ext.isEmpty ? '.mp3' : ''}', // 확장자 보장
        contentType: MediaType('audio', mimeSubtype),
      ),
    );

    final response = await http.Response.fromStream(await request.send());

    debugPrint('[녹음 파일 업로드 응답] ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('녹음 파일 업로드 실패: ${response.statusCode}');
    }
  }

  /// 방문 보고서 생성
  static Future<Map<String, dynamic>> addVisitReport({
    required String visitTime,
    required String email,
    required String targetName,
    required int targetId,
  }) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/addVisitReport'),
      headers: headers,
      body: jsonEncode({
        'visittime': visitTime,
        'email': email,
        'targetname': targetName,
        'targetid': targetId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('방문 보고서 생성 실패: ${response.statusCode}');
    }
  }

  /// 모든 방문 보고서 조회 (JWT 필요)
  static Future<List<ReportTarget>> getAllVisitReports() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getAllVisitReports'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReportTarget.fromJson(e)).toList();
    } else {
      throw Exception('방문 보고서 조회 실패: ${response.statusCode}');
    }
  }

  /// 방문 완료 보고서 조회 (JWT 필요)
  static Future<List<ReportTarget>> getResultReportList() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getResultReportList'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReportTarget.fromJson(e)).toList();
    } else {
      throw Exception('완료 보고서 조회 실패: ${response.statusCode}');
    }
  }

  /// 상담 완료 처리 (reportstatus = 2)
  static Future<void> visitReportDone(int reportId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/visitReportDone?reportId=$reportId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('상담 완료 처리 실패: ${response.statusCode}');
    }
  }

  /// 보고서에 사용자(email) 설정
  static Future<void> setUserToReport({
    required int reportId,
    required String email,
  }) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/setUserToReport'),
      headers: headers,
      body: jsonEncode({'reportid': reportId, 'email': email}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('사용자 설정 실패: ${response.statusCode}');
    }
  }

  /// 카테고리 요약본 DB에 업데이트
  static Future<void> updateVisitCategory({
    required int reportId,
    required String email,
    required String txtFile,
  }) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/update_visit_category'),
      headers: headers,
      body: jsonEncode({
        'reportid': reportId,
        'email': email,
        'txt_file': txtFile,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('카테고리 업데이트 실패: ${response.statusCode}');
    }
  }

  /// 대상자 등록
  static Future<Map<String, dynamic>> addTarget(
    Map<String, dynamic> targetData,
  ) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/addTarget'),
      headers: headers,
      body: jsonEncode(targetData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('대상자 등록 실패: ${response.statusCode}');
    }
  }

  /// 모든 대상자 조회
  static Future<List<Target>> getAllTargets() async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/getAllTargets'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Target.fromJson(e)).toList();
    } else {
      throw Exception('대상자 목록 조회 실패: ${response.statusCode}');
    }
  }
}
