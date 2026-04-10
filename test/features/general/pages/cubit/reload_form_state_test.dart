import 'package:flutter_test/flutter_test.dart';
import 'package:myelvasense/features/features.dart';

void main() {
  group('ReloadFormX', () {
    test('returns correct values for ReloadForm.initial', () {
      const status = ReloadFormState.initial();
      expect(status, const ReloadFormState.initial());
    });

    test('returns correct values for ReloadForm.formUpdated', () {
      const status = ReloadFormState.formUpdated();
      expect(status, const ReloadFormState.formUpdated());
    });
  });
}
