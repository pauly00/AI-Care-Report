import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/util/http_helper.dart';
import 'package:safe_hi/util/login_storage_helper.dart';

class UserService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 로그인 요청
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/db/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final json = jsonDecode(utf8.decode(response.bodyBytes));

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
          return {"status": false, "msg": "서버 응답에 사용자 정보가 없습니다."};
        }
      } else if (response.statusCode == 401) {
        return {"status": false, "msg": "아이디 또는 비밀번호가 올바르지 않습니다."};
      } else if (response.statusCode >= 500) {
        return {"status": false, "msg": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."};
      } else {
        return {"status": false, "msg": json['message'] ?? '로그인 실패'};
      }
    } catch (e) {
      debugPrint('[UserService] login error: $e');
      return {"status": false, "msg": "서버에 연결할 수 없습니다. 인터넷 상태를 확인해주세요."};
    }
  }

  /// 토큰으로 사용자 정보 요청 (자동 로그인용)
  Future<Map<String, dynamic>> fetchUserInfo() async {
    final token = await LoginStorageHelper.readToken();

    if (token == null || token.isEmpty) {
      throw Exception('토큰이 없습니다');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/db/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      throw Exception('401 Unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (responseData is List && responseData.isNotEmpty) {
      return responseData[0] as Map<String, dynamic>;
    }
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    throw Exception('예상하지 못한 응답 형식');
  }
}
