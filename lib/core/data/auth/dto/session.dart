import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// The credential bundle issued by register/login/oauth/refresh
/// (`Session` in the backend contract). The opaque [refreshToken] rotates on
/// every refresh; both tokens are persisted to secure storage only — never
/// cached in drift or logged (Constitution I).
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    @Default('Bearer') String tokenType,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
