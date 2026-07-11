/// Centralized REST endpoint paths (Constitution VIII) — never inline literals at
/// call sites. All paths are relative to the per-flavor base URL, which is rooted
/// at `/v1` (see `AppConfig.apiBaseUrl`). Shapes from the backend contract
/// (`backend/.claude/claude-app/api-context.md`).
abstract final class ApiEndpoints {
  /// Auth (#003) — email-first credentials, OAuth, recovery, username check.
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authForgot = '/auth/forgot';
  static const String authReset = '/auth/reset';
  static const String authCheckUsername = '/auth/check-username';

  /// OAuth exchange — `provider` ∈ {google, apple}.
  static String authOauth(String provider) => '/auth/oauth/$provider';

  /// Single-flight refresh target (wired into the refresh interceptor, #002).
  static const String authRefresh = '/auth/refresh';

  /// Current user profile.
  static const String me = '/me';

  /// First-run profile setup.
  static const String meSetup = '/me/setup';

  /// Partial update of the current user's editable identity (#010, `PATCH /me`).
  static const String meUpdate = '/me';

  /// Public profile by handle (#002 reference slice; #010 `ProfileView`).
  static String userByUsername(String username) => '/users/$username';

  /// Follow graph (#010, B#010) — idempotent follow (`POST`) / unfollow +
  /// withdraw-request (`DELETE`); returns the updated relationship + counts.
  static String userFollow(String userId) => '/users/$userId/follow';

  /// Followers / following lists (#010, cursor + `?q=` server-side search).
  static String userFollowers(String userId) => '/users/$userId/followers';
  static String userFollowing(String userId) => '/users/$userId/following';

  /// A user's Posts / Tagged grids (#010, cursor `CursorPage<ExploreItem>`).
  static String userPosts(String userId) => '/users/$userId/posts';
  static String userTagged(String userId) => '/users/$userId/tagged';

  /// Reverse-chronological feed (cursor) — consumed from #004.
  static const String feed = '/feed';

  /// Post engagement (#004) — idempotent like/save toggles returning
  /// `EngagementState`. `POST` adds, `DELETE` removes (both no-ops if already in
  /// the target state, per the B#004 contract).
  static String postLike(String id) => '/posts/$id/like';
  static String postSave(String id) => '/posts/$id/save';

  /// Comments (#006) — B#comments contract. Top-level comments for a post
  /// (cursor, oldest-first) and one level of replies for a comment; add a
  /// comment/reply (idempotent via `Idempotency-Key`); idempotent like toggle
  /// (`POST` adds / `DELETE` removes, target-state); delete own (cascade for a
  /// parent); surface-only report.
  static String postComments(String postId) => '/posts/$postId/comments';
  static String commentReplies(String commentId) =>
      '/comments/$commentId/replies';
  static String commentLike(String commentId) => '/comments/$commentId/like';
  static String comment(String commentId) => '/comments/$commentId';
  static String commentReport(String commentId) =>
      '/comments/$commentId/report';

  /// Media upload (B#003 presigned direct-upload flow): request a ticket
  /// (`POST /media/uploads` → `{mediaId, uploadUrl, method, headers}`), `PUT` the
  /// bytes straight to object storage at `uploadUrl`, then finalize
  /// (`POST /media/:id/finalize` → `MediaDto`) to enqueue processing. The API
  /// never proxies the binary (scalable large-video uploads, Constitution II).
  static const String mediaUploads = '/media/uploads';
  static String mediaFinalize(String id) => '/media/$id/finalize';
  static String mediaById(String id) => '/media/$id';

  /// Create post (#007) — publishes a post from uploaded media ids + caption +
  /// metadata; idempotent via the client `Idempotency-Key`. B#007 seam.
  static const String posts = '/posts';

  /// Reels (#008) — B#007 contract. Global reels feed (`GET`, cursor,
  /// reverse-chron, ready-only) + create (`POST`, idempotent via
  /// `Idempotency-Key`). Single reel (`GET`) / delete own (`DELETE`). Idempotent
  /// like/save toggles returning `EngagementState` (`POST` adds / `DELETE`
  /// removes). Reel comments delegate to the B#005 comments surface.
  static const String reels = '/reels';
  static String reel(String id) => '/reels/$id';
  static String reelLike(String id) => '/reels/$id/like';
  static String reelSave(String id) => '/reels/$id/save';
  static String reelComments(String id) => '/reels/$id/comments';

  /// Stories (#004 / B#006 contract). Publish (`POST /stories`, idempotent) from
  /// one uploaded media + audience; the bounded tray (`GET /stories/feed`) is
  /// unseen-first, self entry first.
  static const String stories = '/stories';
  static const String storiesFeed = '/stories/feed';

  /// Explore & Search (#009) — B#009 contract. Non-personalized discovery grid
  /// (`GET /explore`, cursor, ready-only). Full-text search (`GET /search`,
  /// `q`+`type`∈{top,accounts,tags,places}; `top` is a fixed blended snapshot,
  /// single-type is cursor-paginated). Hashtag/place pages (`GET`, cursor grid).
  /// Recent-search history (`GET/POST /me/search-recents`, dedupe-and-promote;
  /// `DELETE /me/search-recents/:id` one, `DELETE /me/search-recents` clear all).
  static const String explore = '/explore';
  static const String search = '/search';
  static String hashtagPage(String tag) => '/hashtags/$tag';
  static String placePage(String id) => '/places/$id';
  static const String searchRecents = '/me/search-recents';
  static String searchRecent(String id) => '/me/search-recents/$id';

  /// Saved Collections (#011, B#011 — reconciled with the shipped backend). The
  /// saved pile (`GET /me/saved`) + collections list/create (`GET`/`POST
  /// /me/collections`) are user-scoped; a single collection + its items are
  /// **not** under `/me` (`GET`/`PATCH`/`DELETE /collections/:id`, `GET`/`POST
  /// /collections/:id/items`, `DELETE /collections/:id/items/:postId`). Add-item
  /// takes `{postId}` in the body (auto-saves). Cover is server-derived (no
  /// set-cover endpoint); there is no per-post membership endpoint. Full unsave
  /// reuses [postSave] (#004).
  static const String meSaved = '/me/saved';
  static const String meCollections = '/me/collections';
  static String collection(String id) => '/collections/$id';
  static String collectionItems(String id) => '/collections/$id/items';
  static String collectionItem(String id, String postId) =>
      '/collections/$id/items/$postId';

  /// Direct Messages (#012, B#012 — reconciled with the shipped dev backend
  /// 2026-07-08). Conversation **list** (`GET /conversations`, cursor,
  /// newest-activity first) + **open-or-start** a 1-1 conversation
  /// (`POST /conversations` `{userId}`, idempotent → returns the existing thread
  /// if any, SC-007) share the [conversations] path. One conversation
  /// (`GET`/`DELETE /conversations/:id`). Message history
  /// (`GET /conversations/:id/messages`, cursor) + send
  /// (`POST /conversations/:id/messages` `{kind, body|mediaId|sharedPostId|
  /// stickerId}`, idempotent via the `Idempotency-Key` header — the wire body
  /// carries no client key). Mark read (`POST /conversations/:id/read`). Realtime
  /// typing/presence/receipts ride the socket (see `SocketEvents`); compose
  /// people-search reuses [search] + [userFollowing]. (Backend also exposes
  /// accept/decline for message requests + `DELETE /messages/:id` — not used in
  /// v1.0.)
  static const String conversations = '/conversations';
  static String conversation(String id) => '/conversations/$id';
  static String conversationMessages(String id) =>
      '/conversations/$id/messages';
  static String conversationRead(String id) => '/conversations/$id/read';

  /// Notifications & Push (#013, B#013 — source-verified against
  /// `backend/src/modules/notifications`). The grouped **activity feed**
  /// (`GET /notifications`, cursor, newest-activity first), the **unread count**
  /// (`GET /notifications/unread-count` → `{count}`, drives the badge), and
  /// **mark-all-read** (`POST /notifications/read` → 204; advances one server
  /// `lastReadAt` marker — no per-notification read, no get-by-id). Push **device
  /// registry**: register/refresh a token (`POST /devices` `{platform, token}` →
  /// `{id, platform, createdAt}`, token never echoed) / unregister
  /// (`DELETE /devices/:token`, idempotent). Live `notification.new` rides the
  /// socket (see `SocketEvents`).
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsRead = '/notifications/read';
  static const String devices = '/devices';
  static String device(String token) => '/devices/$token';

  /// Settings, Privacy & Safety (#014, B#014 — source-verified against
  /// `backend/src/modules/{users,social,moderation,stories}`). One-stop settings
  /// read/write (`GET`/`PATCH /me/settings` → `SettingsView` {isPrivate,
  /// activityStatusVisible, twoFactorEnabled, closeFriendsCount, notifications}).
  /// Follow-request approval inbox (`GET /me/follow-requests`, cursor;
  /// accept → `RelationshipState`, reject → 204). Block/unblock
  /// (`POST`/`DELETE /users/:id/block` → `RelationshipState`; atomic bidirectional
  /// sever server-side). Report (`POST /reports` → 202 `{accepted}`, surface-only).
  /// Close friends (`GET /me/close-friends` cursor; `POST`/`DELETE
  /// /me/close-friends/:userId`, 204). Blocked-list read
  /// (`GET /me/blocks`, cursor `UserSummary`) is implemented in B#014.
  static const String meSettings = '/me/settings';
  static const String followRequests = '/me/follow-requests';
  static String followRequestAccept(String userId) =>
      '/me/follow-requests/$userId/accept';
  static String followRequestReject(String userId) =>
      '/me/follow-requests/$userId/reject';
  static String userBlock(String userId) => '/users/$userId/block';
  static const String meBlocks = '/me/blocks'; // blocked-list (B#014)
  static const String reports = '/reports';
  static const String closeFriends = '/me/close-friends';
  static String closeFriend(String userId) => '/me/close-friends/$userId';
}
