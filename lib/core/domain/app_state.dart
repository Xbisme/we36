import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'app_state.freezed.dart';

/// The mandatory 4-state pattern every screen Cubit emits (Constitution III).
/// Extended variants in later specs MUST prefix the base name
/// (e.g. `loadedPaginating`) — never `success`/`failed`/`empty`.
@freezed
sealed class AppState<T> with _$AppState<T> {
  const AppState._();

  const factory AppState.initial() = AppInitial<T>;
  const factory AppState.loading() = AppLoading<T>;
  const factory AppState.loaded(T data) = AppLoaded<T>;
  const factory AppState.error(AppFailure failure) = AppError<T>;

  bool get isLoading => this is AppLoading<T>;

  T? get dataOrNull => switch (this) {
    AppLoaded<T>(:final data) => data,
    _ => null,
  };
}
