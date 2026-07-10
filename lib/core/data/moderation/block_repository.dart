import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Blocking (#014, US3). A real impl (`env:['real']`) binds to
/// `POST`/`DELETE /users/:id/block`; the blocked-accounts **list** binds to a
/// PENDING `GET /me/blocks` (B#014 backend addition — see contracts). The
/// in-memory fake (`env:['fake']`) implements the full surface.
abstract interface class BlockRepository {
  /// Block [userId] — atomic bidirectional sever server-side. Returns the
  /// updated relationship (`blocking: true`).
  Future<Result<ViewerRelationship>> block(String userId);

  /// Unblock [userId]. Does NOT restore any prior follow.
  Future<Result<ViewerRelationship>> unblock(String userId);

  /// The accounts the signed-in person has blocked (cursor).
  Future<Result<CursorPage<UserSummary>>> listBlocked({String? cursor});
}
