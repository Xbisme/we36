import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';

/// Drives the stories rail (US4). Loads the reels once, then keeps ring/order
/// state live by watching the persisted seen-set: "Your story" leads, unseen
/// reels (gradient ring) come before seen (desaturated), newest first.
@injectable
class StoriesRailCubit extends AppCubit<List<StoryReel>> {
  StoriesRailCubit(this._loadReels, this._watchSeen);

  final LoadStoryReels _loadReels;
  final WatchSeenSegments _watchSeen;

  StreamSubscription<Set<String>>? _seenSub;
  List<StoryReel> _reels = const [];

  Future<void> load() async {
    emitLoading();
    final result = await _loadReels();
    result.fold((reels) {
      _reels = reels;
      emitLoaded(_ordered(reels));
      _seenSub ??= _watchSeen().listen(_onSeen);
    }, emitError);
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
    return super.close();
  }
}
