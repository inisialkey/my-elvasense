import 'package:flutter_test/flutter_test.dart';
import 'package:myelvasense/core/core.dart';

void main() {
  group('ListAPI', () {
    test('Auth endpoints', () {
      expect(ListAPI.user, equals('/v1/api/user'));
      expect(ListAPI.login, equals('/api/v1/sign-in'));
      expect(ListAPI.logout, equals('/api/v1/user/logout'));
    });

    test('User endpoints', () {
      expect(ListAPI.users, equals('/v1/api/user/all'));
    });
  });
}
