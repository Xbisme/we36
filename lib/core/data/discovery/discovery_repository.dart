import 'package:we36/core/data/discovery/discovery_page.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// The discovery data seam (#009, B#009 contract; Constitution VIII/IX). Explore
/// reads flow through the drift cache as one canonical ordered snapshot
/// ([watchExplore]); pagination reconciles pages. Search (Top snapshot + per-type
/// cursor lists), hashtag/place pages, and recents are live-query. Every screen
/// consumes this — never HTTP directly. A real impl (`env:['real']`) and an
/// in-memory fake (`env:['fake']`, the one that runs) exist.
abstract interface class DiscoveryRepository {
  // ── Explore grid (persisted, reactive) ─────────────────────────────────────

  /// Reactive Explore grid in server order (the single render source).
  Stream<List<ExploreItem>> watchExplore();

  /// Load the first Explore page (`GET /explore`), replacing the cached snapshot.
  Future<Result<CursorPage<ExploreItem>>> loadExploreFirst();

  /// Load the next Explore page (`GET /explore?cursor=…`), appending to the cache.
  Future<Result<CursorPage<ExploreItem>>> loadExploreNext(String cursor);

  // ── Search (live) ───────────────────────────────────────────────────────────

  /// The fixed blended `top` snapshot for [q] (no pagination).
  Future<Result<SearchTop>> searchTop(String q);

  /// Cursor page of account results for [q].
  Future<Result<CursorPage<AccountResult>>> searchAccounts(
    String q, {
    String? cursor,
  });

  /// Cursor page of hashtag results for [q].
  Future<Result<CursorPage<HashtagResult>>> searchTags(
    String q, {
    String? cursor,
  });

  /// Cursor page of place results for [q].
  Future<Result<CursorPage<PlaceResult>>> searchPlaces(
    String q, {
    String? cursor,
  });

  // ── Hashtag / place pages (live) ────────────────────────────────────────────

  /// A hashtag page (header + first/next cursor grid).
  Future<Result<HashtagPage>> hashtagPage(String tag, {String? cursor});

  /// A place page (header + first/next cursor grid).
  Future<Result<PlacePage>> placePage(String id, {String? cursor});

  // ── Recent searches (dedupe-and-promote) ────────────────────────────────────

  /// The viewer's recent searches (newest-first, capped, not paginated).
  Future<Result<List<SearchRecent>>> recents();

  /// Record a recent (tap a result / submit a term) — dedupe-and-promote.
  Future<Result<SearchRecent>> recordRecent(RecordSearchRecent record);

  /// Remove one recent entry.
  Future<Result<void>> deleteRecent(String id);

  /// Clear all recent entries.
  Future<Result<void>> clearRecents();
}
