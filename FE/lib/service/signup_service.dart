import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/user_register_model.dart';

/// 회원가입 관련 API 통신을 담당하는 서비스 클래스
class SignupService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 사용자 회원가입 요청
  static Future<Map<String, dynamic>> register(UserRegisterModel user) async {
    debugPrint('[회원가입 요청 시작]');
    debugPrint('요청 바디: ${jsonEncode(user.toJson())}');

    // 실제 서버 API 요청
    final url = Uri.parse('$baseUrl/db/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 바디: ${utf8.decode(response.bodyBytes)}');

      // 성공 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // 실패 응답 처리
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'status': false,
          'msg': errorBody['msg'] ?? '회원가입에 실패했습니다.',
        };
      }
    } catch (e) {
      debugPrint('[예외 발생] $e');
      return {
        'status': false,
        'msg': '회원가입 요청 중 오류가 발생했습니다.\n${e.toString()}',
      };
    }

    // 더미 응답 데이터
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션

    return {
      "status": true,
      "message": "User registered successfully",
      "user": {
        "user_id": 123, // 더미값 - 백엔드 연동 필요
        "name": user.name,
        "phone_number": user.phoneNumber,
        "email": user.email,
        "birthdate": user.birthdate,
        "gender": user.gender,
      }
    };
  }
}
