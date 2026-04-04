import 'package:safe_hi/service/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository({required UserService service}) : _service = service;

  Future<Map<String, dynamic>> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<Map<String, dynamic>> fetchUserInfo(int userid) {
    return _service.fetchUserInfo();
  }
}
