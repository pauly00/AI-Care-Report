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

  // 자동 로그인 처리 - 저장된 토큰으로 사용자 정보 복원
  Future<void> tryAutoLogin() async {
    // 저장된 토큰 확인
    final token = await LoginStorageHelper.readToken();
    if (token == null || token.isEmpty) {
      debugPrint('[AUTO] 저장된 토큰 없음');
      return;
    }

    _token = token;
    debugPrint('[AUTO] 저장된 토큰으로 자동 로그인 시도');

    try {
      // 토큰으로 유저 정보 요청
      final userInfo = await _service.fetchUserInfo();
      _user = UserModel.fromJson(userInfo);
      debugPrint('[AUTO] 자동 로그인 성공: ${_user?.name}');
      notifyListeners();

    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      // 토큰 만료/무효 시 저장소 정리
      if (errorMessage.contains('401') ||
          errorMessage.contains('unauthorized') ||
          errorMessage.contains('token') && errorMessage.contains('invalid')) {
        debugPrint('[AUTO] 토큰 만료/무효 → 저장소 정리');
        await LoginStorageHelper.clearToken();
        await LoginStorageHelper.clear();
        _user = null;
        _token = null;
        notifyListeners();
      } else {
        // 네트워크 오류 등 일시적 에러: 토큰 유지
        debugPrint('[AUTO] 임시 실패(네트워크 등): $e');
      }
    }
  }

  // 로그인 상태 저장
  Future<void> saveLogin(int userId) async {
    await LoginStorageHelper.saveLogin(userid: userId);
  }

  // 로그인 처리 및 토큰 저장
  Future<Map<String, dynamic>> login(String email, String password,
      {bool saveLogin = true}) async {
    debugPrint('[LOGIN] 로그인 시작: $email');
    
    try {
      final loginResponse = await _service.login(email, password);
      debugPrint('[LOGIN] 서버 응답 받음: ${loginResponse.keys}');
      
      _token = loginResponse['token'];
      debugPrint('[LOGIN] 토큰 추출: $_token');

      // 토큰 영구 저장
      if (_token != null && _token!.isNotEmpty) {
        debugPrint('[LOGIN] 토큰 저장 시작...');
        await LoginStorageHelper.saveToken(_token!);
        debugPrint('[LOGIN] 토큰 저장 완료: ${_token!.substring(0, 20)}...');
        
        // 저장 확인
        final savedToken = await LoginStorageHelper.readToken();
        debugPrint('[LOGIN] 저장된 토큰 확인: ${savedToken?.substring(0, 20)}...');
      } else {
        debugPrint('[LOGIN] 토큰이 null이거나 비어있음: $_token');
      }

      final userInfo = loginResponse['user'];
      debugPrint("로그인 응답 userInfo: $userInfo");

      _user = UserModel.fromJson(userInfo);
      debugPrint('[LOGIN] 유저 모델 생성 완료: ${_user?.name}');

      // 로그인 상태 저장
      if (saveLogin) {
        debugPrint('[LOGIN] loginStatus 저장 시작...');
        await LoginStorageHelper.saveLogin(userid: _user!.userId);
        debugPrint('[LOGIN] loginStatus 저장 완료: ${_user!.userId}');
      }

      notifyListeners();
      debugPrint('[LOGIN] notifyListeners 완료');

      return {
        'success': true,
        'msg': '로그인 성공',
      };
    } catch (e) {
      debugPrint('[LOGIN] 로그인 에러: $e');
      return {
        'success': false,
        'msg': '로그인 실패: $e',
      };
    }
  }

  // 로그아웃 - 저장된 데이터 모두 삭제
  Future<void> logout() async {
    await LoginStorageHelper.clear();
    await LoginStorageHelper.clearToken();
    _user = null;
    _token = null;
    debugPrint('[LOGOUT] 로그아웃 완료 - 저장소 클리어');
    notifyListeners();
  }
  
  // 사용자 정보 직접 설정
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}