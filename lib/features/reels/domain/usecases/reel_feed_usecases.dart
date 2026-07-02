import 'package:injectable/injectable.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Reels feed use cases (Constitution III: inject use cases into cubits, not
/// repos). Each is a thin, testable seam over [ReelsRepository].

/// Reactive canonical reels feed read (drift stream).
@injectable
class WatchReelsFeed {
  const WatchReelsFeed(this._repo);
  final ReelsRepository _repo;
  Stream<List<Reel>> call() => _repo.watchReelsFeed();
}

/// Load the first page (also used for pull-to-refresh).
@injectable
class LoadReels {
  const LoadReels(this._repo);
  final ReelsRepository _repo;
  Future<Result<CursorPage<Reel>>> call() => _repo.loadFirstPage();
}

/// Append the next page for the given cursor.
@injectable
class LoadMoreReels {
  const LoadMoreReels(this._repo);
  final ReelsRepository _repo;
  Future<Result<CursorPage<Reel>>> call(String cursor) =>
      _repo.loadNextPage(cursor);
}
