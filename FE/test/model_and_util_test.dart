import 'package:flutter_test/flutter_test.dart';
import 'package:safe_hi/model/user_model.dart';
import 'package:safe_hi/util/format_time.dart';

void main() {
  group('UserModel', () {
    test('JSON 응답 모델 변환', () {
      final user = UserModel.fromJson({
        'user_id': 1,
        'name': '테스트 사용자',
        'phone_number': '01012345678',
        'email': 'test@test.com',
        'birthdate': '1990-01-01',
        'gender': 0,
        'etc': '',
        'role': 1,
      });

      expect(user.userId, 1);
      expect(user.name, '테스트 사용자');
      expect(user.email, 'test@test.com');
      expect(user.role, 1);
    });
  });

  group('formatTime', () {
    test('방문 시간 표시 변환', () {
      expect(formatTime('2026-07-04 09:30'), '9:30 AM');
    });
  });
}
