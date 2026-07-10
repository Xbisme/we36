import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/data/social/follow_requests_remote_data_source.dart';
import 'package:we36/core/data/social/follow_requests_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Live follow-request inbox (#014, B#014). On a confirmed Approve, seeds the
/// canonical [RelationshipStore] so the requester's `followsYou` reflects
/// everywhere, and signals aggregate views to refresh their counts.
@LazySingleton(as: FollowRequestsRepository, env: ['real'])
class FollowRequestsRepositoryImpl implements FollowRequestsRepository {
  const FollowRequestsRepositoryImpl(this._remote, this._relationships);

  final FollowRequestsRemoteDataSource _remote;
  final RelationshipStore _relationships;

  @override
  Future<Result<CursorPage<FollowRequest>>> list({String? cursor}) =>
      _remote.list(cursor: cursor);

  @override
  Future<Result<ViewerRelationship>> accept(
    String userId, {
    String? idempotencyKey,
  }) async {
    final result = await _remote.accept(userId, idempotencyKey: idempotencyKey);
    result.fold(
      (relationship) {
        _relationships
          ..seed(userId, relationship)
          ..notifyFollowChanged();
      },
      (_) {},
    );
    return result;
  }

  @override
  Future<Result<void>> reject(String userId, {String? idempotencyKey}) =>
      _remote.reject(userId, idempotencyKey: idempotencyKey);
}
