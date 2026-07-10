import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Close-friends list management (#014, US4). Feeds the stories "Close friends"
/// audience (#005). A real impl (`env:['real']`) binds to `/me/close-friends`;
/// the in-memory fake (`env:['fake']`) seeds a small list + eligible candidates.
abstract interface class CloseFriendsRepository {
  /// The current close-friends members (cursor, newest-added first).
  Future<Result<CursorPage<UserSummary>>> list({String? cursor});

  /// Accounts eligible to be added (people who follow you), for the add picker.
  Future<Result<CursorPage<UserSummary>>> candidates({String? cursor});

  /// Add [userId] to close friends (idempotent; backend requires they follow
  /// you — a `validation` failure surfaces a friendly message).
  Future<Result<void>> add(String userId);

  /// Remove [userId] from close friends (idempotent).
  Future<Result<void>> remove(String userId);
}
