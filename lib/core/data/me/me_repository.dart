import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/result.dart';

/// The authenticated current-user profile (#003). Real + fake implementations
/// are interchangeable via DI; the real one reconciles `GET /v1/me` into the
/// drift cache and exposes a reactive [watchMe] (one canonical copy,
/// Constitution IX). Profile editing beyond setup lands in #010.
abstract interface class MeRepository {
  /// Fetch the current profile from the backend (cache-first fallback in real).
  Future<Result<MeProfile>> getMe();

  /// Reactive read of the cached current user (single canonical copy).
  Stream<MeProfile?> watchMe();

  /// First-run profile setup (`POST /v1/me/setup`).
  Future<Result<MeProfile>> setupProfile({
    required String username,
    required String displayName,
    String? bio,
  });

  /// Partial update of the editable identity (#010, `PATCH /v1/me`). Only the
  /// non-null fields are sent; on success the canonical cache is updated so
  /// `watchMe` repaints every surface. Optimistic save + rollback is owned by
  /// the edit cubit (the repository persists the reconciled result).
  Future<Result<MeProfile>> updateProfile({
    String? displayName,
    String? username,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
  });
}
