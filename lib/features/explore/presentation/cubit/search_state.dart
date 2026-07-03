import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'search_state.freezed.dart';

/// The active search result view (#009 US1).
enum SearchTab { top, accounts, tags, places }

/// Search state (Constitution III 4-state). [SearchInitial] means the query is
/// below the ≥2-char threshold — the page shows recents (US3) instead of results.
/// [SearchLoaded] carries the blended Top snapshot plus the paginated per-type
/// lists; the cubit owns cursors + the latest-term guard. Extended variants prefix
/// the base name.
@freezed
sealed class SearchState with _$SearchState {
  const SearchState._();

  /// Query < 2 chars — no results requested; the page shows recents.
  const factory SearchState.initial() = SearchInitial;

  /// First fetch of [tab] for [query] is in flight.
  const factory SearchState.loading({
    required String query,
    required SearchTab tab,
  }) = SearchLoading;

  /// Results for [query]. [top] is the blended snapshot (Top tab); the per-type
  /// lists back the Accounts/Tags/Places tabs. [hasMore]/[loadingMore] track the
  /// active single-type tab's pagination.
  const factory SearchState.loaded({
    required String query,
    required SearchTab tab,
    required List<AccountResult> accounts,
    required List<HashtagResult> tags,
    required List<PlaceResult> places,
    SearchTop? top,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
  }) = SearchLoaded;

  /// First fetch of [tab] for [query] failed (retryable).
  const factory SearchState.error({
    required String query,
    required SearchTab tab,
    required AppFailure failure,
  }) = SearchError;

  /// The query currently backing the state (empty in [SearchInitial]).
  String get query => switch (this) {
    SearchLoading(:final query) => query,
    SearchLoaded(:final query) => query,
    SearchError(:final query) => query,
    SearchInitial() => '',
  };

  /// The active tab (Top in [SearchInitial]).
  SearchTab get tab => switch (this) {
    SearchLoading(:final tab) => tab,
    SearchLoaded(:final tab) => tab,
    SearchError(:final tab) => tab,
    SearchInitial() => SearchTab.top,
  };
}
