import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_hi/core/constants.dart';
import 'package:safe_hi/model/client_model.dart';
import 'package:safe_hi/util/http_helper.dart';

/// 클라이언트 CRUD API 통신을 담당하는 서비스 클래스
class ClientService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// 클라이언트 조회
  Future<ClientModel> getClient(int clientId) async {
    final headers = await buildAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/db/clients/$clientId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return ClientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('클라이언트 조회 실패: ${response.statusCode}');
    }
  }

  /// 클라이언트 생성
  Future<ClientModel> createClient(Map<String, dynamic> data) async {
    final headers = await buildAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/db/clients'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ClientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('클라이언트 생성 실패: ${response.statusCode}');
    }
  }

  /// 클라이언트 업데이트
  Future<ClientModel> updateClient(
    int clientId,
    Map<String, dynamic> data,
  ) async {
    final headers = await buildAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/db/clients/$clientId'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return ClientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('클라이언트 업데이트 실패: ${response.statusCode}');
    }
  }

  /// 클라이언트 삭제
  Future<void> deleteClient(int clientId) async {
    final headers = await buildAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/db/clients/$clientId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('클라이언트 삭제 실패: ${response.statusCode}');
    }
  }
}
