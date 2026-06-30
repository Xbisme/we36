import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

part 'paginated_list_cubit.freezed.dart';

/// 4-state pagination state (Constitution III): `loaded` carries the cursor +
/// `hasMore`; extended `loadedPaginating`/`loadedRefreshing` retain items while
/// a load-more / refresh is in flight.
@freezed
sealed class PaginatedListState<T> with _$PaginatedListState<T> {
  const PaginatedListState._();

  const factory PaginatedListState.initial() = PaginatedInitial<T>;
  const factory PaginatedListState.loading() = PaginatedLoading<T>;
  const factory PaginatedListState.loaded({
    required List<T> items,
    required String? nextCursor,
    required bool hasMore,
  }) = PaginatedLoaded<T>;
  const factory PaginatedListState.loadedPaginating({
    required List<T> items,
    required String? nextCursor,
    required bool hasMore,
  }) = PaginatedLoadedPaginating<T>;
  const factory PaginatedListState.loadedRefreshing({
    required List<T> items,
    required String? nextCursor,
    required bool hasMore,
  }) = PaginatedLoadedRefreshing<T>;
  const factory PaginatedListState.error(AppFailure failure) =
      PaginatedError<T>;

  /// Items currently loaded (empty when not in a loaded variant).
  List<T> get items => switch (this) {
    PaginatedLoaded<T>(:final items) => items,
    PaginatedLoadedPaginating<T>(:final items) => items,
    PaginatedLoadedRefreshing<T>(:final items) => items,
    _ => const [],
  };

  String? get nextCursor => switch (this) {
    PaginatedLoaded<T>(:final nextCursor) => nextCursor,
    PaginatedLoadedPaginating<T>(:final nextCursor) => nextCursor,
    PaginatedLoadedRefreshing<T>(:final nextCursor) => nextCursor,
    _ => null,
  };

  bool get hasMore => switch (this) {
    PaginatedLoaded<T>(:final hasMore) => hasMore,
    PaginatedLoadedPaginating<T>(:final hasMore) => hasMore,
    PaginatedLoadedRefreshing<T>(:final hasMore) => hasMore,
    _ => false,
  };
}

/// Fetches one page for `PaginatedListCubit`.
typedef PageFetcher<T> =
    Future<Result<CursorPage<T>>> Function(PageRequest request);

/// Reusable cursor-paginated list controller (Constitution II/III/VIII) — reused
/// by feed/search/comments. De-dupes by `idSelector`; load-more failures keep the
/// already-loaded items (soft failure) rather than dropping to `error`.
class PaginatedListCubit<T> extends Cubit<PaginatedListState<T>> {
  PaginatedListCubit({
    required PageFetcher<T> fetchPage,
    required String Function(T item) idSelector,
    this.limit = PageRequest.defaultLimit,
  }) : _fetchPage = fetchPage,
       _idSelector = idSelector,
       super(PaginatedListState<T>.initial());

  final PageFetcher<T> _fetchPage;
  final String Function(T item) _idSelector;
  final int limit;

  /// Load (or reload) the first page.
  Future<void> loadFirst() async {
    emit(PaginatedListState<T>.loading());
    final result = await _fetchPage(PageRequest(limit: limit));
    if (isClosed) return;
    result.fold(
      (page) => emit(
        PaginatedListState<T>.loaded(
          items: _dedupe(page.items),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
      (failure) => emit(PaginatedListState<T>.error(failure)),
    );
  }

  /// Append the next page. No-op unless currently `loaded` with more pages.
  Future<void> loadMore() async {
    final current = state;
    if (current is! PaginatedLoaded<T> || !current.hasMore) return;

    emit(
      PaginatedListState<T>.loadedPaginating(
        items: current.items,
        nextCursor: current.nextCursor,
        hasMore: current.hasMore,
      ),
    );
    final result = await _fetchPage(
      PageRequest(cursor: current.nextCursor, limit: limit),
    );
    if (isClosed) return;
    result.fold(
      (page) => emit(
        PaginatedListState<T>.loaded(
          items: _dedupe([...current.items, ...page.items]),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
      // Soft failure: keep the items we already have.
      (_) => emit(
        PaginatedListState<T>.loaded(
          items: current.items,
          nextCursor: current.nextCursor,
          hasMore: current.hasMore,
        ),
      ),
    );
  }

  /// Reload from the first page, replacing items.
  Future<void> refresh() async {
    final current = state;
    if (current is PaginatedLoaded<T>) {
      emit(
        PaginatedListState<T>.loadedRefreshing(
          items: current.items,
          nextCursor: current.nextCursor,
          hasMore: current.hasMore,
        ),
      );
    }
    final result = await _fetchPage(PageRequest(limit: limit));
    if (isClosed) return;
    result.fold(
      (page) => emit(
        PaginatedListState<T>.loaded(
          items: _dedupe(page.items),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
      (failure) => emit(PaginatedListState<T>.error(failure)),
    );
  }

  List<T> _dedupe(List<T> items) {
    final seen = <String>{};
    final out = <T>[];
    for (final item in items) {
      if (seen.add(_idSelector(item))) out.add(item);
    }
    return out;
  }
}
