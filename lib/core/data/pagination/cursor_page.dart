/// A single page of a cursor-paginated list (Constitution II/VIII). Envelope:
/// `{ items, nextCursor, hasMore }`; the cursor is opaque (base64url keyset),
/// `null` ⇒ end of list.
class CursorPage<T> {
  const CursorPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  /// Parse the envelope. A malformed item is skipped (one bad item must not fail
  /// the page — Constitution IX); a null cursor ends pagination regardless of
  /// `hasMore`.
  factory CursorPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> item) itemFromJson,
  ) {
    final rawItems = json['items'];
    final items = <T>[];
    if (rawItems is List) {
      for (final raw in rawItems) {
        if (raw is! Map) continue;
        try {
          items.add(itemFromJson(raw.cast<String, dynamic>()));
        } on Object catch (_) {
          // Skip the malformed item.
        }
      }
    }
    final nextCursor = json['nextCursor'] as String?;
    final hasMore = nextCursor != null && (json['hasMore'] as bool? ?? false);
    return CursorPage<T>(
      items: items,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
}

/// A page request: opaque [cursor] (null = first page) + [limit] (default 20,
/// clamped to a max of 30).
class PageRequest {
  PageRequest({this.cursor, int limit = defaultLimit})
    : limit = limit.clamp(1, maxLimit);

  static const int defaultLimit = 20;
  static const int maxLimit = 30;

  final String? cursor;
  final int limit;

  Map<String, dynamic> toQuery() => {
    if (cursor != null) 'cursor': cursor,
    'limit': limit,
  };
}
