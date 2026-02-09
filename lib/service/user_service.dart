import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:safe_hi/util/http_helper.dart';
import 'package:safe_hi/util/login_storage_helper.dart';

/// 사용자 인증 및 정보 관련 API 통신을 담당하는 서비스 클래스
class UserService {
  // static const String baseUrl = ApiConfig.baseUrl;
  static const String baseUrl = 'http://localhost:8080';

  /// 로그인 요청
  Future<Map<String, dynamic>> login(String email, String password) async {

    /**
     * 더미 로그인 코드(추후 삭제 필요
     */
    debugPrint('[임시 로그인 시작]');
    return {
      "status": true,
      "msg": "테스트용 로그인 성공", // 더미 메시지
      "user": {
        "user_id": 4, // 더미값 - 백엔드 연동 필요
        "name": "테스트", // 더미값
        "phone_number": "01012345678", // 더미값
        "email": "test@test.com", // 더미값
        "birthdate": "2002-02-02T15:00:00.000Z", // 더미값
        "gender": 0, // 더미값
        "permission": 1, // 더미값
      }
    };

    debugPrint('[로그인 요청 시작]');
    debugPrint('보낸 데이터: {email: $email, password: $password}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/db/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 바디: ${utf8.decode(response.bodyBytes)}');

      final json = jsonDecode(response.body);

      // 성공 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = json['token'];
        final user = json['user'];

        if (token != null && user != null) {
          await LoginStorageHelper.saveToken(token);
          return {
            "status": true,
            "msg": json['message'] ?? "로그인 성공",
            "user": user,
            "token": token,
          };
        } else {
          return {
            "status": false,
            "msg": "서버 응답에 사용자 정보가 포함되어 있지 않습니다.",
          };
        }
      } 
      // 인증 실패 처리
      else if (response.statusCode == 401) {
        return {
          "status": false,
          "msg": "아이디 또는 비밀번호가 올바르지 않습니다.",
        };
      } 
      // 서버 오류 처리
      else if (response.statusCode >= 500) {
        return {
          "status": false,
          "msg": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
        };
      } else {
        return {
          "status": false,
          "msg": json['message'] ?? '로그인 실패',
        };
      }
    } catch (e) {
      return {
        "status": false,
        "msg": "서버에 연결할 수 없습니다. 인터넷 상태를 확인해주세요.",
      };
    }

    // 더미 응답 데이터 - 추후 실제 API 연동 시 제거 필요
    // await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션
    
    // return {
    //   "status": true,
    //   "msg": "테스트용 로그인 성공", // 더미 메시지
    //   "user": {
    //     "user_id": 4, // 더미값 - 백엔드 연동 필요
    //     "name": "yujin", // 더미값
    //     "phone_number": "01012345678", // 더미값
    //     "email": "jenny7732@naver.com", // 더미값
    //     "birthdate": "2002-02-02T15:00:00.000Z", // 더미값
    //     "gender": 0, // 더미값
    //     "permission": 1, // 더미값
    //   }
    // };
  }

  /// 자동 로그인 시 사용자 정보 요청
  Future<Map<String, dynamic>> fetchUserInfo() async {
    final token = await LoginStorageHelper.readToken();

    if (token == null || token.isEmpty) {
      throw Exception('토큰이 없습니다');
    }

    debugPrint('[AUTH 헤더] $token');

    final response = await http.get(
      Uri.parse('$baseUrl/db/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Bearer 토큰 인증 헤더
      },
    );

    debugPrint('[fetchUserInfo] 응답 코드: ${response.statusCode}');
    debugPrint('[fetchUserInfo] 응답 바디: ${response.body}');

    // 토큰 만료/무효 처리
    if (response.statusCode == 401) {
      throw Exception('401 Unauthorized - 토큰 만료/무효');
    }

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final responseData = json.decode(response.body);
    
    // 서버가 배열을 반환하는 경우 처리
    if (responseData is List && responseData.isNotEmpty) {
      return responseData[0] as Map<String, dynamic>;
    }
    
    // 서버가 객체를 반환하는 경우 처리
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    throw Exception('예상하지 못한 응답 형식: $responseData');
  }

  // 더미 사용자 정보 데이터
  // return {
  //   "user_id": userid,
  //   "name": "yujin",
  //   "phone_number": "01012345678",
  //   "email": "jenny7732@naver.com",
  //   "birthdate": "2002-02-02T15:00:00.000Z",
  //   "gender": 0,
  //   "permission": 1,
  // };
}
