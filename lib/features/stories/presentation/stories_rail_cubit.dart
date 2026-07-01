import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';
import 'package:we36/features/stories/domain/usecases/watch_own_story_changes.dart';

/// Drives the stories rail (US4). Loads the reels once, then keeps ring/order
/// state live by watching the persisted seen-set: "Your story" leads, unseen
/// reels (gradient ring) come before seen (desaturated), newest first. It also
/// watches [WatchOwnStoryChanges] so a story published in the compose flow
/// repaints the rail with no manual refresh (#005, FR-011).
@injectable
class StoriesRailCubit extends AppCubit<List<StoryReel>> {
  StoriesRailCubit(this._loadReels, this._watchSeen, this._watchOwnChanges);

  final LoadStoryReels _loadReels;
  final WatchSeenSegments _watchSeen;
  final WatchOwnStoryChanges _watchOwnChanges;

  StreamSubscription<Set<String>>? _seenSub;
  StreamSubscription<void>? _ownSub;
  List<StoryReel> _reels = const [];

  Future<void> load() async {
    emitLoading();
    final result = await _loadReels();
    result.fold((reels) {
      _reels = reels;
      emitLoaded(_ordered(reels));
      _seenSub ??= _watchSeen().listen(_onSeen);
      _ownSub ??= _watchOwnChanges().listen((_) => unawaited(_refreshReels()));
    }, emitError);
  }

  /// Re-fetch reels (own published story merged in) without a loading flicker.
  Future<void> _refreshReels() async {
    final result = await _loadReels();
    result.fold((reels) {
      _reels = reels;
      if (!isClosed) emitLoaded(_ordered(reels));
    }, (_) {});
  }

  void _onSeen(Set<String> seen) {
    final updated = _reels
        .map(
          (r) => r.copyWith(
            hasUnseen: r.segments.any((s) => !seen.contains(s.id)),
          ),
        )
        .toList();
    _reels = updated;
    if (!isClosed) emitLoaded(_ordered(updated));
  }

  /// "Your story" first, then unseen reels (newest first), then seen reels.
  List<StoryReel> _ordered(List<StoryReel> reels) {
    final you = reels.where((r) => r.isYou).toList();
    final others = reels.where((r) => !r.isYou).toList()
      ..sort((a, b) {
        if (a.hasUnseen != b.hasUnseen) return a.hasUnseen ? -1 : 1;
        return b.latestAt.compareTo(a.latestAt);
      });
    return [...you, ...others];
  }

  @override
  Future<void> close() async {
    await _seenSub?.cancel();
    await _ownSub?.cancel();
    return super.close();
  }
}
