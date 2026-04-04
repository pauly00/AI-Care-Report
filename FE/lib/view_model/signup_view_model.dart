import 'package:flutter/material.dart';
import 'package:safe_hi/model/user_register_model.dart';
import 'package:safe_hi/service/signup_service.dart';

class SignupViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<Map<String, dynamic>> signup(UserRegisterModel user) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await SignupService.register(user);
      isLoading = false;
      notifyListeners();
      return {
        'success': response['status'] == true,
        'msg': response['msg'] ?? '오류가 발생했습니다.',
      };
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'msg': '회원가입 중 오류가 발생했습니다.',
      };
    }
  }
}
