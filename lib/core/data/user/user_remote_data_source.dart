import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for the reference slice: `GET /v1/users/{username}` decoded to
/// [User] via the shared [ApiClient] (centralized error mapping → `Result`).
@lazySingleton
class UserRemoteDataSource {
  const UserRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<User>> getByUsername(String username) => _api.get<User>(
    ApiEndpoints.userByUsername(username),
    decode: (data) => User.fromJson(data as Map<String, dynamic>),
  );
}
