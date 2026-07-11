import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/moderation/block_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Live blocking over the backend (#014, B#014). `block`/`unblock` +
/// `listBlocked` (`GET /me/blocks`, cursor page of `UserSummary`) are all backed
/// by real endpoints (the blocked-list route was added in B#014).
@LazySingleton(as: BlockRepository, env: ['real'])
class BlockRepositoryImpl implements BlockRepository {
  const BlockRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Result<ViewerRelationship>> block(String userId) =>
      _api.post<ViewerRelationship>(
        ApiEndpoints.userBlock(userId),
        decode: (data) =>
            ViewerRelationship.fromJson((data as Map).cast<String, dynamic>()),
      );

  @override
  Future<Result<ViewerRelationship>> unblock(String userId) =>
      _api.delete<ViewerRelationship>(
        ApiEndpoints.userBlock(userId),
        decode: (data) =>
            ViewerRelationship.fromJson((data as Map).cast<String, dynamic>()),
      );

  @override
  Future<Result<CursorPage<UserSummary>>> listBlocked({String? cursor}) =>
      _api.get<CursorPage<UserSummary>>(
        ApiEndpoints.meBlocks,
        query: cursor == null ? null : {'cursor': cursor},
        decode: (data) => CursorPage<UserSummary>.fromJson(
          (data as Map).cast<String, dynamic>(),
          UserSummary.fromJson,
        ),
      );
}
