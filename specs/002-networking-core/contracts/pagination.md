# Contract: Cursor Pagination

## Envelope (backend)

```json
{ "items": [ /* … */ ], "nextCursor": "opaque-base64url-or-null", "hasMore": true }
```

- Request: `?cursor=<opaque>&limit=<n>` — `limit` default **20**, max **30** (clamped client-side).
- Opaque keyset cursor; **no offset**; stable ordering guaranteed by the server.

## `CursorPage<T>`

```
CursorPage<T> {
  List<T> items;
  String? nextCursor;   // null ⇒ end
  bool hasMore;
  static CursorPage<T> fromJson(Map json, T Function(Map) itemFromJson);
}
```

- Tolerance: if `nextCursor == null`, treat as end regardless of `hasMore`.
- Malformed item in `items` → skip it (one bad item must not fail the page; Constitution IX).

## `PaginatedListCubit<T>` (extends `AppCubit<List<T>>`)

State (4-state + extended variants, Constitution III):

| State | items | flags |
|---|---|---|
| `initial` | — | — |
| `loading` | — | first page in flight |
| `loaded` | yes | `nextCursor`, `hasMore` |
| `loadedPaginating` | yes (retained) | load-more in flight |
| `loadedRefreshing` | yes (retained) | refresh in flight |
| `error` | — | first-page failure (`AppFailure`) |

Operations:

| Op | Behavior |
|---|---|
| `loadFirst()` | `loading` → fetch page(cursor:null) → `loaded` / `error` |
| `loadMore()` | no-op if `!hasMore` or already paginating; else `loadedPaginating` → fetch page(cursor:nextCursor) → append+de-dupe → `loaded` |
| `refresh()` | `loadedRefreshing` → fetch page(cursor:null) → replace items → `loaded` |

- **De-dupe** by `String Function(T) idSelector` (drop duplicates across page boundaries).
- **Load-more failure** keeps `loaded` (prior items) + soft failure; never drops to `error`.
- Proven in #002 against a **fake** multi-page source (no network).
