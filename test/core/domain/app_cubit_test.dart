import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';

class _TestCubit extends AppCubit<int> {
  Future<void> loadOk() => run(() async => const Result.ok(7));
  Future<void> loadErr() =>
      run(() async => const Result.err(AppFailure.offline()));
}

void main() {
  group('AppCubit 4-state', () {
    test('starts in initial', () {
      expect(_TestCubit().state, const AppState<int>.initial());
    });

    blocTest<_TestCubit, AppState<int>>(
      'initial → loading → loaded on success',
      build: _TestCubit.new,
      act: (c) => c.loadOk(),
      expect: () => const [
        AppState<int>.loading(),
        AppState<int>.loaded(7),
      ],
    );

    blocTest<_TestCubit, AppState<int>>(
      'initial → loading → error on failure',
      build: _TestCubit.new,
      act: (c) => c.loadErr(),
      expect: () => const [
        AppState<int>.loading(),
        AppState<int>.error(AppFailure.offline()),
      ],
    );
  });
}
