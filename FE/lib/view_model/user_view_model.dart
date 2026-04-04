import 'package:flutter/material.dart';
import 'package:safe_hi/model/user_model.dart';
import 'package:safe_hi/service/user_service.dart';
import 'package:safe_hi/util/login_storage_helper.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _service;
  UserModel? _user;
  String? _token;
  bool isLoading = false;

  UserViewModel(this._service);

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _user != null;

  // 사용자 정보 로드
  Future<void> loadUser(int userId) async {
    isLoading = true;
    notifyListeners();
    try {
      final userInfo = await _service.fetchUserInfo();
      _user = UserModel.fromJson(userInfo);
    } catch (e) {
      debugPrint('User fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 자동 로그인 - 저장된 토큰으로 사용자 정보 복원
  Future<void> tryAutoLogin() async {
    final token = await LoginStorageHelper.readToken();
    if (token == null || token.isEmpty) return;

    _token = token;

    try {
      final userInfo = await _service.fetchUserInfo();
      _user = UserModel.fromJson(userInfo);
      notifyListeners();
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('401') || msg.contains('unauthorized')) {
        await LoginStorageHelper.clearAll();
        _user = null;
        _token = null;
        notifyListeners();
      }
      // 네트워크 일시 오류는 토큰 유지 (재시도 가능)
    }
  }

  // 로그인
  Future<Map<String, dynamic>> login(String email, String password,
      {bool saveLogin = true}) async {
    try {
      final loginResponse = await _service.login(email, password);

      // 로그인 실패 처리
      if (loginResponse['status'] != true) {
        return {
          'success': false,
          'msg': loginResponse['msg'] ?? '로그인 실패',
        };
      }

      // 토큰 저장
      _token = loginResponse['token'];
      if (_token != null && _token!.isNotEmpty) {
        await LoginStorageHelper.saveToken(_token!);
      }

      // 유저 모델 생성
      _user = UserModel.fromJson(loginResponse['user'] as Map<String, dynamic>);

      // 자동 로그인 저장
      if (saveLogin) {
        await LoginStorageHelper.saveLogin(userid: _user!.userId);
      }

      notifyListeners();
      return {'success': true, 'msg': '로그인 성공'};
    } catch (e) {
      debugPrint('[UserViewModel] login error: $e');
      return {'success': false, 'msg': '로그인 처리 중 오류가 발생했습니다.'};
    }
  }

  // 로그인 상태 저장
  Future<void> saveLogin(int userId) async {
    await LoginStorageHelper.saveLogin(userid: userId);
  }

  // 로그아웃
  Future<void> logout() async {
    await LoginStorageHelper.clearAll();
    _user = null;
    _token = null;
    notifyListeners();
  }

  // 사용자 정보 직접 설정
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
