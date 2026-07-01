import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/own_story_store.dart';

/// Surfaces [OwnStoryStore.changes] to the presentation layer (Constitution III
/// — inject use cases, not stores/repos, into cubits). The stories rail listens
/// so a newly published story repaints the rail with no manual refresh (#005,
/// FR-011, analysis finding I1).
@injectable
class WatchOwnStoryChanges {
  const WatchOwnStoryChanges(this._store);
  final OwnStoryStore _store;
  Stream<void> call() => _store.changes;
}
