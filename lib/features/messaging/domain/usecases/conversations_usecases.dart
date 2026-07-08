import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Reactive read of the person's 1-1 conversations (#012 US1) — the one canonical
/// list from the drift cache, newest-activity first. Renders offline-from-cache
/// (FR-007).
@injectable
class WatchConversations {
  const WatchConversations(this._repo);
  final MessagingRepository _repo;

  Stream<List<Conversation>> call() => _repo.watchConversations();
}

/// Reconcile the cached conversation list with the server (background refresh).
@injectable
class LoadConversations {
  const LoadConversations(this._repo);
  final MessagingRepository _repo;

  Future<Result<void>> call() => _repo.refreshConversations();
}
