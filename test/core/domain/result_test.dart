import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

void main() {
  group('Result', () {
    test('Ok folds to the success branch', () {
      const result = Result<int>.ok(42);
      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.fold((v) => 'ok:$v', (_) => 'err'), 'ok:42');
    });

    test('Err folds to the failure branch', () {
      const result = Result<int>.err(AppFailure.offline());
      expect(result.isErr, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, const AppFailure.offline());
      expect(result.fold((_) => 'ok', (_) => 'err'), 'err');
    });

    test('map transforms Ok and preserves Err', () {
      expect(const Result<int>.ok(2).map((v) => v * 10).valueOrNull, 20);
      expect(
        const Result<int>.err(AppFailure.timeout()).map((v) => v).failureOrNull,
        const AppFailure.timeout(),
      );
    });
  });
}
