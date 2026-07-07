import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';

/// Load the current identity to pre-fill the edit form.
@injectable
class LoadEditForm {
  const LoadEditForm(this._repo);
  final MeRepository _repo;
  Future<Result<MeProfile>> call() => _repo.getMe();
}

/// Live username availability (reuses the #003 `/auth/check-username` seam).
@injectable
class CheckUsername {
  const CheckUsername(this._auth);
  final AuthRepository _auth;
  Future<Result<bool>> call(String username) async {
    final res = await _auth.checkUsername(username: username);
    return res.isOk
        ? Result.ok(res.valueOrNull!.available)
        : Result.err(res.failureOrNull!);
  }
}

/// Upload a picked+processed avatar via the shared media pipeline (#007) and
/// return the resulting `mediaId` for the profile update.
@injectable
class ChangeAvatar {
  ChangeAvatar(this._uploader);
  final MediaUploadService _uploader;
  final Uuid _uuid = const Uuid();

  Future<Result<String>> call(Uint8List bytes) async {
    await for (final event in _uploader.upload(
      bytes: bytes,
      idempotencyKey: _uuid.v7(),
    )) {
      if (event is UploadDoneEvent) return Result.ok(event.media.id);
      if (event is UploadFailedEvent) return Result.err(event.failure);
    }
    return const Result.err(AppFailure.uploadFailed());
  }
}

/// Persist the edited identity (`PATCH /me`); the cache repaints every surface.
@injectable
class SaveProfile {
  const SaveProfile(this._repo);
  final MeRepository _repo;
  Future<Result<MeProfile>> call({
    String? displayName,
    String? username,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
  }) => _repo.updateProfile(
    displayName: displayName,
    username: username,
    pronouns: pronouns,
    website: website,
    bio: bio,
    avatarMediaId: avatarMediaId,
  );
}
