import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for the current user: `GET /v1/me` + `POST /v1/me/setup`,
/// decoded to [MeProfile] via the shared [ApiClient].
@lazySingleton
class MeRemoteDataSource {
  const MeRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<MeProfile>> getMe() =>
      _api.get<MeProfile>(ApiEndpoints.me, decode: _decode);

  Future<Result<MeProfile>> setupProfile({
    required String username,
    required String displayName,
    String? bio,
  }) => _api.post<MeProfile>(
    ApiEndpoints.meSetup,
    body: {
      'username': username,
      'displayName': displayName,
      if (bio != null && bio.isNotEmpty) 'bio': bio,
    },
    decode: _decode,
  );

  Future<Result<MeProfile>> updateProfile({
    String? displayName,
    String? username,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
  }) => _api.patch<MeProfile>(
    ApiEndpoints.meUpdate,
    body: {
      'displayName': ?displayName,
      'username': ?username,
      'pronouns': ?pronouns,
      'website': ?website,
      'bio': ?bio,
      'avatarMediaId': ?avatarMediaId,
    },
    decode: _decode,
  );

  static MeProfile _decode(dynamic data) =>
      MeProfile.fromJson((data as Map).cast<String, dynamic>());
}
