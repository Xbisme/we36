import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/explore/domain/usecases/search_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/search_state.dart';

/// Drives the Search results (#009 US1; Constitution III). Search runs **live
/// as-you-type**, debounced ~300 ms, only at **≥2 characters** (below that the
/// state is [SearchInitial] and the page shows recents). The **latest term wins**
/// — a completed request for a superseded query is ignored (monotonic token). The
/// Top snapshot is fetched once per term; single-type tabs lazily load + paginate.
@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._top, this._accounts, this._tags, this._places)
    : super(const SearchState.initial());

  final SearchTopQuery _top;
  final SearchAccounts _accounts;
  final SearchTags _tags;
  final SearchPlaces _places;

  static const int minChars = 2;
  static const Duration debounce = Duration(milliseconds: 300);

  Timer? _debounce;
  int _seq = 0;
  SearchTab _tab = SearchTab.top;
  String? _accountsCursor;
  String? _tagsCursor;
  String? _placesCursor;

  /// Live query input from the field. Debounces, then searches at ≥2 chars.
  void onQueryChanged(String raw) {
    final q = raw.trim();
    _debounce?.cancel();
    if (q.length < minChars) {
      _seq++; // cancel any in-flight term
      emit(const SearchState.initial());
      return;
    }
    _debounce = Timer(debounce, () => _search(q));
  }

  /// Immediate submit (Enter) — searches now (no debounce). The page records the
  /// recent term separately.
  Future<void> submit(String raw) async {
    final q = raw.trim();
    _debounce?.cancel();
    if (q.length < minChars) return;
    await _search(q);
  }

  /// Switch the active result tab; lazily loads that tab's data if not present.
  Future<void> changeTab(SearchTab tab) async {
    _tab = tab;
    final s = state;
    if (s is! SearchLoaded) return;
    emit(_loadedWith(s, tab: tab));
    final needsLoad = switch (tab) {
      SearchTab.top => s.top == null,
      SearchTab.accounts => s.accounts.isEmpty,
      SearchTab.tags => s.tags.isEmpty,
      SearchTab.places => s.places.isEmpty,
    };
    if (needsLoad) await _fetchTab(s.query, tab);
  }

  /// Paginate the active single-type tab (Top is a fixed snapshot).
  Future<void> loadMore() async {
    final s = state;
    if (s is! SearchLoaded || s.loadingMore || !s.hasMore) return;
    final cursor = switch (s.tab) {
      SearchTab.top => null,
      SearchTab.accounts => _accountsCursor,
      SearchTab.tags => _tagsCursor,
      SearchTab.places => _placesCursor,
    };
    if (cursor == null) return;
    emit(s.copyWith(loadingMore: true));
    await _fetchTab(s.query, s.tab, cursor: cursor);
  }

  /// Retry the active tab after an error.
  Future<void> retry() => _search(state.query, tab: _tab);

  Future<void> _search(String q, {SearchTab? tab}) async {
    final target = tab ?? _tab;
    _resetCursors();
    emit(SearchState.loading(query: q, tab: target));
    await _fetchTab(q, target, fresh: true);
  }

  Future<void> _fetchTab(
    String q,
    SearchTab tab, {
    String? cursor,
    bool fresh = false,
  }) async {
    final token = ++_seq;
    switch (tab) {
      case SearchTab.top:
        final r = await _top(q);
        if (token != _seq) return;
        r.fold(
          (top) => emit(_merge(q, tab, top: top)),
          (f) => _emitError(q, tab, f, fresh),
        );
      case SearchTab.accounts:
        final r = await _accounts(q, cursor: cursor);
        if (token != _seq) return;
        r.fold((page) {
          _accountsCursor = page.nextCursor;
          final prior = cursor == null
              ? const <AccountResult>[]
              : _current().accounts;
          emit(
            _merge(
              q,
              tab,
              accounts: [...prior, ...page.items],
              hasMore: page.hasMore,
            ),
          );
        }, (f) => _emitError(q, tab, f, fresh));
      case SearchTab.tags:
        final r = await _tags(q, cursor: cursor);
        if (token != _seq) return;
        r.fold((page) {
          _tagsCursor = page.nextCursor;
          final prior = cursor == null
              ? const <HashtagResult>[]
              : _current().tags;
          emit(
            _merge(
              q,
              tab,
              tags: [...prior, ...page.items],
              hasMore: page.hasMore,
            ),
          );
        }, (f) => _emitError(q, tab, f, fresh));
      case SearchTab.places:
        final r = await _places(q, cursor: cursor);
        if (token != _seq) return;
        r.fold((page) {
          _placesCursor = page.nextCursor;
          final prior = cursor == null
              ? const <PlaceResult>[]
              : _current().places;
          emit(
            _merge(
              q,
              tab,
              places: [...prior, ...page.items],
              hasMore: page.hasMore,
            ),
          );
        }, (f) => _emitError(q, tab, f, fresh));
    }
  }

  /// Merge a fresh fetch into a [SearchLoaded], preserving other tabs' data.
  SearchLoaded _merge(
    String q,
    SearchTab tab, {
    SearchTop? top,
    List<AccountResult>? accounts,
    List<HashtagResult>? tags,
    List<PlaceResult>? places,
    bool? hasMore,
  }) {
    final cur = _current();
    return SearchState.loaded(
          query: q,
          tab: tab,
          top: top ?? cur.top,
          accounts: accounts ?? cur.accounts,
          tags: tags ?? cur.tags,
          places: places ?? cur.places,
          hasMore: hasMore ?? (tab == cur.tab && cur.hasMore),
        )
        as SearchLoaded;
  }

  SearchLoaded _current() {
    final s = state;
    return s is SearchLoaded
        ? s
        : const SearchState.loaded(
                query: '',
                tab: SearchTab.top,
                accounts: [],
                tags: [],
                places: [],
              )
              as SearchLoaded;
  }

  SearchLoaded _loadedWith(SearchLoaded s, {required SearchTab tab}) {
    final hasMore = switch (tab) {
      SearchTab.top => false,
      SearchTab.accounts => _accountsCursor != null,
      SearchTab.tags => _tagsCursor != null,
      SearchTab.places => _placesCursor != null,
    };
    return s.copyWith(tab: tab, hasMore: hasMore, loadingMore: false);
  }

  void _emitError(String q, SearchTab tab, AppFailure failure, bool fresh) {
    // Only replace the screen with an error on a fresh fetch; a failed paginate
    // keeps the existing results.
    if (fresh) {
      emit(SearchState.error(query: q, tab: tab, failure: failure));
    } else if (state is SearchLoaded) {
      emit((state as SearchLoaded).copyWith(loadingMore: false));
    }
  }

  void _resetCursors() {
    _accountsCursor = null;
    _tagsCursor = null;
    _placesCursor = null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
