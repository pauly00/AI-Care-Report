import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, String>> buildAuthHeaders({
  Map<String, String>? extraHeaders,
}) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');

  debugPrint('[AUTH 헤더] $token');

  final headers = {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
    ...?extraHeaders,
  };

  return headers;
}
