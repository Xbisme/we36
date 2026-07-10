import 'dart:async';

import 'package:we36/core/data/moderation/blocked_users_store.dart';

/// Combines a list stream with the [BlockedUsersStore], re-emitting a filtered
/// list whenever EITHER the source or the blocked set changes (#014, FR-014).
/// This is how blocked authors vanish from the feed / conversation list
/// in-session with no reload, while the app depends only on the core store.
Stream<List<T>> filterBlocked<T>(
  Stream<List<T>> source,
  BlockedUsersStore blocked,
  String Function(T item) authorId,
) {
  final controller = StreamController<List<T>>();
  var latest = <T>[];
  var hasSource = false;
  StreamSubscription<List<T>>? srcSub;
  StreamSubscription<Set<String>>? blkSub;

  void emit() => controller.add(
    latest
        .where((item) => !blocked.isBlocked(authorId(item)))
        .toList(growable: false),
  );

  controller
    ..onListen = () {
      srcSub = source.listen(
        (items) {
          latest = items;
          hasSource = true;
          emit();
        },
        onError: controller.addError,
        onDone: controller.close,
      );
      // Re-filter on block-set changes, but only once the source has produced
      // data (the store emits its initial set immediately on listen; emitting
      // an empty list before the source would corrupt `.first`).
      blkSub = blocked.blockedIds.listen((_) {
        if (hasSource) emit();
      });
    }
    ..onCancel = () async {
      await srcSub?.cancel();
      await blkSub?.cancel();
    };

  return controller.stream;
}
