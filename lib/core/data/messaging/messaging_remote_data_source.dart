import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/messaging/messaging_dto.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for Direct Messages (#012) via the shared [ApiClient] — DERIVED
/// B#012 shapes (`contracts/messaging-api.md`), reconciled at cutover. Send
/// carries an `Idempotency-Key` = the client [Message.clientKey] so a retry
/// delivers exactly one message (SC-003); the response is the persisted message
/// (= `sent`). Typing/presence/read ride the socket, not REST.
@lazySingleton
class MessagingRemoteDataSource {
  const MessagingRemoteDataSource(this._api);

  final ApiClient _api;

  /// [filter] partitions the inbox: `primary` (default, accepted) or `requests`
  /// (pending — messages from people you don't follow). The client lists both
  /// (no separate requests-inbox in v1.0).
  Future<Result<CursorPage<Conversation>>> listConversations({
    String? cursor,
    String filter = 'primary',
  }) => _api.get<CursorPage<Conversation>>(
    ApiEndpoints.conversations,
    query: {'filter': filter, ...?_pageQuery(cursor)},
    decode: (data) => CursorPage<Conversation>.fromJson(
      (data as Map).cast<String, dynamic>(),
      conversationFromWire,
    ),
  );

  Future<Result<Conversation>> openOrStart(String userId) =>
      _api.post<Conversation>(
        ApiEndpoints.conversations,
        body: {'userId': userId},
        idempotent: true,
        decode: (data) =>
            conversationFromWire((data as Map).cast<String, dynamic>()),
      );

  Future<Result<CursorPage<Message>>> history(
    String conversationId, {
    required String currentUserId,
    String? cursor,
  }) => _api.get<CursorPage<Message>>(
    ApiEndpoints.conversationMessages(conversationId),
    query: _pageQuery(cursor),
    decode: (data) => CursorPage<Message>.fromJson(
      (data as Map).cast<String, dynamic>(),
      (item) => messageFromWire(
        item,
        isMine: item['senderId'] == currentUserId,
        conversationId: conversationId,
      ),
    ),
  );

  /// Send a message. [content] is the flat kind-specific body (`{body}` /
  /// `{mediaId}` / `{sharedPostId}` / `{stickerId}`). Idempotency rides the
  /// `Idempotency-Key` header (the client key); the wire body carries no key.
  /// Returns the persisted message.
  Future<Result<Message>> send(
    String conversationId, {
    required String clientKey,
    required MessageKind kind,
    required Map<String, dynamic> content,
  }) => _api.post<Message>(
    ApiEndpoints.conversationMessages(conversationId),
    body: {'kind': kindToWire(kind), ...content},
    idempotencyKey: clientKey,
    decode: (data) => messageFromWire(
      (data as Map).cast<String, dynamic>(),
      isMine: true,
      conversationId: conversationId,
    ),
  );

  Future<Result<void>> markRead(String conversationId, String upToMessageId) =>
      _api.post<void>(
        ApiEndpoints.conversationRead(conversationId),
        body: {'upToMessageId': upToMessageId},
        decode: (_) {},
      );

  /// People search for the composer — reuses the #009 accounts search.
  Future<Result<CursorPage<UserSummary>>> searchPeople(String query) =>
      _api.get<CursorPage<UserSummary>>(
        ApiEndpoints.search,
        query: {'q': query, 'type': 'accounts'},
        decode: (data) => CursorPage<UserSummary>.fromJson(
          (data as Map).cast<String, dynamic>(),
          _userFromWire,
        ),
      );

  static Map<String, dynamic>? _pageQuery(String? cursor) =>
      cursor == null ? null : {'cursor': cursor};

  static UserSummary _userFromWire(Map<String, dynamic> json) {
    final u = (json['user'] as Map?)?.cast<String, dynamic>() ?? json;
    return UserSummary(
      id: u['id'] as String? ?? '',
      isVerified: u['isVerified'] as bool? ?? false,
      username: u['username'] as String?,
      displayName: u['displayName'] as String?,
      avatarUrl: u['avatarUrl'] as String?,
    );
  }
}
