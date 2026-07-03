import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'recents_state.freezed.dart';

/// Recent-search state (#009 US3; Constitution III 4-state).
@freezed
sealed class RecentsState with _$RecentsState {
  const RecentsState._();

  const factory RecentsState.initial() = RecentsInitial;
  const factory RecentsState.loading() = RecentsLoading;
  const factory RecentsState.loaded(List<SearchRecent> items) = RecentsLoaded;
  const factory RecentsState.error(AppFailure failure) = RecentsError;

  /// The recents to render (empty in non-loaded states).
  List<SearchRecent> get items => switch (this) {
    RecentsLoaded(:final items) => items,
    _ => const [],
  };
}
