import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_state.dart';

/// Drives the signed-in person's own profile (#010 US1). The header identity
/// comes from the cached current user (`watchMe`, so edits repaint it), the
/// counts + grid from the profile endpoint (`isMe`). Owns tab switch + grid
/// pagination.
@injectable
class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit(
    this._watchMe,
    this._fetchMe,
    this._loadProfile,
    this._loadGrid,
    this._relationships,
  ) : super(const MyProfileState.initial());

  final WatchMe _watchMe;
  final FetchMe _fetchMe;
  final LoadProfile _loadProfile;
  final LoadProfileGrid _loadGrid;
  final RelationshipStore _relationships;

  StreamSubscription<MeProfile?>? _sub;
  StreamSubscription<void>? _relSub;
  String? _userId;
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;
  bool _refreshing = false;
  ProfileTab _tab = ProfileTab.posts;

  Future<void> loadInitial() async {
    emit(const MyProfileState.loading());
    final me = await _fetchMe();
    if (me.isErr) {
      emit(MyProfileState.error(me.failureOrNull!));
      return;
    }
    final profile = me.valueOrNull!;
    final username = profile.username;
    if (username == null) {
      emit(const MyProfileState.error(AppFailure.notFound()));
      return;
    }
    final viewRes = await _loadProfile(username);
    if (viewRes.isErr) {
      emit(MyProfileState.error(viewRes.failureOrNull!));
      return;
    }
    // The backend's public-profile projection carries no `isMe`/`gated`; this is
    // definitionally the signed-in person, so own content is never gated.
    final view = viewRes.valueOrNull!.copyWith(isMe: true, gated: false);
    _userId = view.user.id;
    final gridRes = await _loadGrid(_userId!, _tab);
    final page = gridRes.valueOrNull;
    _cursor = page?.nextCursor;
    _hasMore = page?.hasMore ?? false;
    emit(
      MyProfileState.loaded(
        view: view,
        tab: _tab,
        grid: page?.items ?? const [],
        hasMore: _hasMore,
        website: profile.website,
        isOffline: gridRes.isErr,
      ),
    );
    _sub ??= _watchMe().listen(_onMe);
    // A follow/unfollow anywhere changes my own followingCount — re-fetch the
    // counts when the canonical relationship graph moves.
    _relSub ??= _relationships.changes.listen((_) => unawaited(_refreshView()));
  }

  /// Re-fetch just the profile view (counts + identity) by the current handle —
  /// used when the follow graph changes (the handle is unchanged, so no getMe).
  Future<void> _refreshView() async {
    final s = state;
    if (s is! MyProfileLoaded || _refreshing) return;
    _refreshing = true;
    final view = (await _loadProfile(
      s.view.user.username,
    )).valueOrNull?.copyWith(isMe: true, gated: false);
    _refreshing = false;
    final cur = state;
    if (view != null && cur is MyProfileLoaded) {
      emit(cur.copyWith(view: view));
    }
  }

  void _onMe(MeProfile? me) {
    if (me == null) return;
    final s = state;
    if (s is MyProfileLoaded) emit(s.copyWith(website: me.website));
  }

  Future<void> switchTab(ProfileTab tab) async {
    if (tab == _tab) return;
    final s = state;
    if (s is! MyProfileLoaded || _userId == null) return;
    // The Saved tab (#011) has no profile grid — its body is the Saved-
    // collections view (own `SavedTabSlot`/cubit), so just switch the tab.
    if (tab == ProfileTab.saved) {
      _tab = tab;
      emit(s.copyWith(tab: tab));
      return;
    }
    _tab = tab;
    _cursor = null;
    _hasMore = true;
    emit(s.copyWith(tab: tab, grid: const [], loadingMore: true));
    final gridRes = await _loadGrid(_userId!, tab);
    final page = gridRes.valueOrNull;
    _cursor = page?.nextCursor;
    _hasMore = page?.hasMore ?? false;
    emit(
      s.copyWith(
        tab: tab,
        grid: page?.items ?? const [],
        hasMore: _hasMore,
        loadingMore: false,
      ),
    );
  }

  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null || _userId == null) return;
    final s = state;
    if (s is! MyProfileLoaded) return;
    _busy = true;
    final gridRes = await _loadGrid(_userId!, _tab, cursor: _cursor);
    final page = gridRes.valueOrNull;
    if (page != null) {
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      emit(s.copyWith(grid: [...s.grid, ...page.items], hasMore: _hasMore));
    }
    _busy = false;
  }

  Future<void> retry() => loadInitial();

  /// Re-fetch the profile after returning from Edit profile — both the view
  /// (identity + counts + resolved avatar, from the profile endpoint) and the
  /// `MeProfile`-only fields (website), so every edited field repaints without a
  /// full-screen reload or disturbing the grid/scroll.
  Future<void> refresh() async {
    final s = state;
    if (s is! MyProfileLoaded) return;
    // Resolve the current handle first: a username edit changes it, so fetching
    // the profile by the *old* handle would 404. `getMe` yields the new handle
    // (and website), then the profile view is re-fetched by that handle.
    final me = (await _fetchMe()).valueOrNull;
    final username = me?.username ?? s.view.user.username;
    final view = (await _loadProfile(
      username,
    )).valueOrNull?.copyWith(isMe: true, gated: false);
    var next = s;
    if (view != null) next = next.copyWith(view: view);
    if (me != null) next = next.copyWith(website: me.website);
    emit(next);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _relSub?.cancel();
    return super.close();
  }
}
