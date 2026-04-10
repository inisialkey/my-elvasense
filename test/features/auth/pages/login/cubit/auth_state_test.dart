import 'package:flutter_test/flutter_test.dart';
import 'package:myelvasense/features/features.dart';

void main() {
  group('AuthStatusX', () {
    test('returns correct values for AuthStatus.loading', () {
      const status = AuthState.loading();
      expect(status, const AuthState.loading());
    });

    test('returns correct values for AuthStatus.success', () {
      const status = AuthState.success(null);
      expect(status, const AuthState.success(null));
    });

    test('returns correct values for AuthStatus.failure', () {
      const status = AuthState.failure('');
      expect(status, const AuthState.failure(''));
    });
  });
}
