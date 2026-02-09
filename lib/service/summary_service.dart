import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';

const String baseUrl = ApiConfig.baseUrl;

/// 대화 요약 관련 API 통신을 담당하는 서비스 클래스
class SummaryService {
  /// 대화 요약 데이터 조회
  Future<dynamic> fetchSummaryData() async {
    final response = await http.get(Uri.parse('$baseUrl/conversation-summary'));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception('Failed to load conversation summary');
    }

    // 더미 데이터 - 추후 실제 API 연동 시 제거 필요
    // return [
    //   {
    //     "title": "사회적 고립 상태 평가",
    //     "content": ["사람 만남 꺼림, 의욕 상실", "외로움 무기력 심화"],
    //   },
    //   {
    //     "title": "정신적/감정적 건강",
    //     "content": ["스트레스, 수면 장애"],
    //   },
    // ];
  }
}
