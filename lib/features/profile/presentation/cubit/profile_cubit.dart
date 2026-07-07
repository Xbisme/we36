import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/profile_state.dart';

/// Drives another person's profile (#010 US2/US4). Loads the [ProfileView],
/// keeps the follow relationship live from the canonical [RelationshipStore]
/// (SC-004), and performs **optimistic** follow/unfollow with follower-count
/// deltas + reconcile + rollback. `follow`/`unfollow` return `true` on success so
/// the page can toast on failure.
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._loadProfile, this._loadGrid, this._follow, this._store)
    : super(const ProfileState.initial());

  final LoadProfile _loadProfile;
  final LoadProfileGrid _loadGrid;
  final FollowAction _follow;
  final RelationshipStore _store;

  StreamSubscription<ViewerRelationship>? _relSub;
  String? _userId;
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  Future<void> loadInitial(String username) async {
    emit(const ProfileState.loading());
    final res = await _loadProfile(username);
    if (res.isErr) {
      emit(ProfileState.error(res.failureOrNull!));
      return;
    }
    final view = res.valueOrNull!;
    _userId = view.user.id;
    var grid = const <ExploreItem>[];
    if (!view.gated) {
      final gridRes = await _loadGrid(_userId!, ProfileTab.posts);
      final page = gridRes.valueOrNull;
      _cursor = page?.nextCursor;
      _hasMore = page?.hasMore ?? false;
      grid = page?.items ?? const [];
    } else {
      _hasMore = false;
    }
    emit(
      ProfileState.loaded(
        view: view,
        tab: ProfileTab.posts,
        grid: grid,
        hasMore: _hasMore,
      ),
    );
    _relSub ??= _store.watch(_userId!).listen(_onRelationship);
  }

  void _onRelationship(ViewerRelationship rel) {
    final s = state;
    if (s is ProfileLoaded && s.view.relationship != rel) {
      emit(s.copyWith(view: s.view.copyWith(relationship: rel)));
    }
  }

  /// Follow (public → following, private → requested). Returns false on failure.
  Future<bool> follow() async {
    final s = state;
    if (s is! ProfileLoaded || _busy) return false;
    final u = s.view.user;
    _busy = true;
    emit(
      s.copyWith(
        followBusy: true,
        view: s.view.copyWith(
          user: u.copyWith(
            followersCount: u.followersCount + (u.isPrivate ? 0 : 1),
          ),
        ),
      ),
    );
    final res = await _follow.follow(u.id, isPrivate: u.isPrivate);
    return _settle(res, s.view);
  }

  /// Unfollow or withdraw a request. Returns false on failure.
  Future<bool> unfollow() async {
    final s = state;
    if (s is! ProfileLoaded || _busy) return false;
    final u = s.view.user;
    final wasFollowing = s.view.relationship.following;
    _busy = true;
    emit(
      s.copyWith(
        followBusy: true,
        view: s.view.copyWith(
          user: u.copyWith(
            followersCount: (u.followersCount - (wasFollowing ? 1 : 0)).clamp(
              0,
              u.followersCount,
            ),
          ),
        ),
      ),
    );
    final res = await _follow.unfollow(u.id);
    return _settle(res, s.view);
  }

  bool _settle(Result<FollowResult> res, ProfileView prevView) {
    _busy = false;
    final s = state;
    if (s is! ProfileLoaded) return res.isOk;
    final value = res.valueOrNull;
    if (value != null) {
      emit(
        s.copyWith(
          followBusy: false,
          view: s.view.copyWith(
            relationship: value.relationship,
            user: s.view.user.copyWith(followersCount: value.followersCount),
          ),
        ),
      );
      return true;
    }
    // Failure: the store rolled the relationship back; restore the count too.
    emit(s.copyWith(followBusy: false, view: prevView));
    return false;
  }

  Future<void> loadMore() async {
    if (!_hasMore || _cursor == null || _userId == null) return;
    final s = state;
    if (s is! ProfileLoaded || s.loadingMore) return;
    emit(s.copyWith(loadingMore: true));
    final gridRes = await _loadGrid(_userId!, s.tab, cursor: _cursor);
    final page = gridRes.valueOrNull;
    if (page != null) {
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      emit(
        s.copyWith(
          grid: [...s.grid, ...page.items],
          hasMore: _hasMore,
          loadingMore: false,
        ),
      );
    } else {
      emit(s.copyWith(loadingMore: false));
    }
  }

  @override
  Future<void> close() async {
    await _relSub?.cancel();
    return super.close();
  }
}
