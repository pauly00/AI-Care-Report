import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginStorageHelper {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveLogin({required int userid}) async {
    await _storage.write(key: 'loginStatus', value: 'true');
    await _storage.write(key: 'userid', value: userid.toString());
  }

  static Future<Map<String, String?>> readLogin() async {
    return {
      'loginStatus': await _storage.read(key: 'loginStatus'),
      'userid': await _storage.read(key: 'userid'),
    };
  }

  static String? _cachedToken;

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'accessToken', value: token);
    _cachedToken = token;
  }

  static Future<String?> readToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _storage.read(key: 'accessToken');
    return _cachedToken;
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'accessToken');
    _cachedToken = null;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
    _cachedToken = null;
  }

  static Future<void> clear() async => await _storage.deleteAll();
}
