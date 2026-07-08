import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// People search for the new-message composer (#012 US4) — follows/recents
/// suggested when the query is empty.
@injectable
class SearchPeople {
  const SearchPeople(this._repo);
  final MessagingRepository _repo;

  Future<Result<CursorPage<UserSummary>>> call(String query) =>
      _repo.searchPeople(query);
}

/// Open the existing 1-1 conversation with a person, or start a new one
/// (idempotent → no duplicate, SC-007).
@injectable
class OpenOrStartConversation {
  const OpenOrStartConversation(this._repo);
  final MessagingRepository _repo;

  Future<Result<Conversation>> call(String userId) =>
      _repo.openOrStartConversation(userId);
}
