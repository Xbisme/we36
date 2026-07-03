import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/features/explore/domain/usecases/discovery_page_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_state.dart';

/// Drives a hashtag or place page (#009 US4; Constitution III). Both render a
/// single cursor grid of `ExploreItem`s with a header — the same pagination shape
/// as the Explore grid — so one cubit serves both, parameterized by [initHashtag]
/// / [initPlace].
@injectable
class DiscoveryGridCubit extends Cubit<DiscoveryGridState> {
  DiscoveryGridCubit(this._loadHashtag, this._loadPlace)
    : super(const DiscoveryGridState.initial());

  final LoadHashtagPage _loadHashtag;
  final LoadPlacePage _loadPlace;

  DiscoveryPageKind? _kind;
  String _target = '';
  String? _cursor;
  bool _hasMore = false;
  bool _busy = false;

  /// Load a hashtag page.
  Future<void> initHashtag(String tag) async {
    _kind = DiscoveryPageKind.hashtag;
    _target = tag;
    await _first();
  }

  /// Load a place page.
  Future<void> initPlace(String id) async {
    _kind = DiscoveryPageKind.place;
    _target = id;
    await _first();
  }

  Future<void> _first() async {
    emit(const DiscoveryGridState.loading());
    if (_kind == DiscoveryPageKind.hashtag) {
      final r = await _loadHashtag(_target);
      r.fold((p) {
        _cursor = p.page.nextCursor;
        _hasMore = p.page.hasMore;
        emit(
          DiscoveryGridState.loaded(
            kind: DiscoveryPageKind.hashtag,
            title: '#${p.tag}',
            postCount: p.postCount,
            items: p.page.items,
            hasMore: _hasMore,
          ),
        );
      }, (f) => emit(DiscoveryGridState.error(f)));
    } else {
      final r = await _loadPlace(_target);
      r.fold((p) {
        _cursor = p.page.nextCursor;
        _hasMore = p.page.hasMore;
        emit(
          DiscoveryGridState.loaded(
            kind: DiscoveryPageKind.place,
            title: p.name,
            postCount: p.postCount,
            items: p.page.items,
            hasMore: _hasMore,
          ),
        );
      }, (f) => emit(DiscoveryGridState.error(f)));
    }
  }

  /// Retry the first page from the error state.
  Future<void> retry() => _first();

  /// Append the next page (soft-fail keeps items).
  Future<void> loadMore() async {
    final s = state;
    if (_busy || !_hasMore || _cursor == null || s is! DiscoveryGridLoaded) {
      return;
    }
    _busy = true;
    emit(s.copyWith(loadingMore: true));
    final cursor = _cursor!;
    if (_kind == DiscoveryPageKind.hashtag) {
      final r = await _loadHashtag(_target, cursor: cursor);
      r.fold((p) {
        _cursor = p.page.nextCursor;
        _hasMore = p.page.hasMore;
        emit(
          s.copyWith(
            items: [...s.items, ...p.page.items],
            hasMore: _hasMore,
            loadingMore: false,
          ),
        );
      }, (_) => emit(s.copyWith(loadingMore: false)));
    } else {
      final r = await _loadPlace(_target, cursor: cursor);
      r.fold((p) {
        _cursor = p.page.nextCursor;
        _hasMore = p.page.hasMore;
        emit(
          s.copyWith(
            items: [...s.items, ...p.page.items],
            hasMore: _hasMore,
            loadingMore: false,
          ),
        );
      }, (_) => emit(s.copyWith(loadingMore: false)));
    }
    _busy = false;
  }
}
