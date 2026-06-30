import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';

/// Drives all four AppState transitions from a simulated local source (no
/// network) so the base state + tests cover every transition (FR-028a).
class StatesDemoCubit extends AppCubit<String> {
  /// Simulated success path: initial → loading → loaded.
  Future<void> loadSuccess() => run(() async => const Result.ok('Loaded data'));

  /// Simulated failure path: initial → loading → error.
  Future<void> loadFailure() =>
      run(() async => const Result.err(AppFailure.offline()));

  void reset() => emit(const AppState<String>.initial());
}
