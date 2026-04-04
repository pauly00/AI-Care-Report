import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/visit_summary_model.dart';
import 'package:safe_hi/util/http_helper.dart';

/// 방문 요약 정보 관련 API 통신을 담당하는 서비스 클래스
class VisitSummaryService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 방문 요약 정보 조회
  Future<VisitSummaryResponse> fetchVisitSummary(int reportId) async {
    final headers = await buildAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/db/getVisitDetails/$reportId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return VisitSummaryResponse.fromJson(json);
    } else {
      throw Exception('방문 요약 정보를 불러오는 데 실패했습니다.');
    }

    // 더미 응답 데이터
    // return VisitSummaryResponse.fromJson({
    //   "reportid": 1, // 더미값 - 백엔드 연동 필요
    //   "items": [
    //     {
    //       "subject": "건강", // 더미값
    //       "abstract": "소화 관련 불편 지속적 호소", // 더미값
    //       "detail": "자세한 소화장애 증상 및 시간대별 변화 설명" // 더미값
    //     },
    //     {
    //       "subject": "경제", // 더미값
    //       "abstract": "공과금 부담, 경제적 스트레스 존재", // 더미값
    //       "detail": "전기/수도요금 미납 상태 및 긴급지원 필요사항" // 더미값
    //     },
    //     {
    //       "subject": "생활", // 더미값
    //       "abstract": "외출 빈도 급감, 활동량 저하 및 무기력감", // 더미값
    //       "detail": "최근 외출 기록 없음, 식사 준비도 소홀" // 더미값
    //     },
    //     {
    //       "subject": "기타", // 더미값
    //       "abstract": "가족과의 거리감, 사회활동 회피", // 더미값
    //       "detail": "전화 연락도 거의 없음, 이웃과 접촉도 줄어듦" // 더미값
    //     }
    //   ]
    // });
  }

  /// 방문 요약 수정 내용 업로드
  Future<void> uploadVisitSummaryEdit({
    required int reportId,
    required List<VisitSummary> summaries,
  }) async {
    final url = Uri.parse('$baseUrl/db/uploadEditAbstract');
    final headers = await buildAuthHeaders();

    final body = {
      'reportid': reportId,
      'items': summaries
          .map((summary) => {
                'subject': summary.subject,
                'abstract': summary.abstract,
                'detail': summary.detail,
              })
          .toList(),
    };

    debugPrint('[요약 업로드 요청] ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('요약 수정 업로드 실패: ${response.statusCode}');
    }
  }
}
