import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/features/dev/presentation/states_demo_cubit.dart';

void main() {
  group('StatesDemoCubit (FR-028a)', () {
    blocTest<StatesDemoCubit, AppState<String>>(
      'success path: loading → loaded',
      build: StatesDemoCubit.new,
      act: (c) => c.loadSuccess(),
      expect: () => const [
        AppState<String>.loading(),
        AppState<String>.loaded('Loaded data'),
      ],
    );

    blocTest<StatesDemoCubit, AppState<String>>(
      'failure path: loading → error',
      build: StatesDemoCubit.new,
      act: (c) => c.loadFailure(),
      expect: () => const [
        AppState<String>.loading(),
        AppState<String>.error(AppFailure.offline()),
      ],
    );

    blocTest<StatesDemoCubit, AppState<String>>(
      'reset returns to initial',
      build: StatesDemoCubit.new,
      act: (c) async {
        await c.loadSuccess();
        c.reset();
      },
      skip: 2,
      expect: () => const [AppState<String>.initial()],
    );
  });
}
