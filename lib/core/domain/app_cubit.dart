import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';

/// Base Cubit enforcing the 4-state pattern (Constitution III). Feature Cubits
/// extend this and call [run] with a repository call returning [Result].
abstract class AppCubit<T> extends Cubit<AppState<T>> {
  AppCubit() : super(AppState<T>.initial());

  void emitLoading() => emit(AppState<T>.loading());
  void emitLoaded(T data) => emit(AppState<T>.loaded(data));
  void emitError(AppFailure failure) => emit(AppState<T>.error(failure));

  /// Drive initial → loading → loaded/error from a fallible operation.
  Future<void> run(Future<Result<T>> Function() operation) async {
    emitLoading();
    final result = await operation();
    if (isClosed) return;
    result.fold(emitLoaded, emitError);
  }
}
