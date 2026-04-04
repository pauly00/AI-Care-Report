import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:safe_hi/core/constants.dart';
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
}
