import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
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
  ) : super(const MyProfileState.initial());

  final WatchMe _watchMe;
  final FetchMe _fetchMe;
  final LoadProfile _loadProfile;
  final LoadProfileGrid _loadGrid;

  StreamSubscription<MeProfile?>? _sub;
  String? _userId;
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;
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
    final view = viewRes.valueOrNull!;
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

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
