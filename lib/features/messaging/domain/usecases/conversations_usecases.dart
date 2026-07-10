import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/data/moderation/block_filter.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/domain/result.dart';

/// Reactive read of the person's 1-1 conversations (#012 US1) — the one canonical
/// list from the drift cache, newest-activity first. Renders offline-from-cache
/// (FR-007).
@injectable
class WatchConversations {
  const WatchConversations(this._repo, this._blocked);
  final MessagingRepository _repo;
  final BlockedUsersStore _blocked;

  /// Conversations with blocked participants filtered out reactively (#014).
  Stream<List<Conversation>> call() => filterBlocked(
    _repo.watchConversations(),
    _blocked,
    (c) => c.participant.id,
  );
}

/// Reconcile the cached conversation list with the server (background refresh).
@injectable
class LoadConversations {
  const LoadConversations(this._repo);
  final MessagingRepository _repo;

  Future<Result<void>> call() => _repo.refreshConversations();
}
