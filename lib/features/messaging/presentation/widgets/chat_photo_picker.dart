import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The in-chat photo attach flow (#012 US3/T040): request the photo permission,
/// show a compact gallery grid, then upload the picked photo through the shipped
/// #007 media pipeline and hand back the finalized `mediaId` to send. Reuses
/// `PhotoLibraryService` + `MediaUploadService`; no new pipeline.
Future<void> pickAndSendChatPhoto(
  BuildContext context, {
  required void Function(String mediaId) onUploaded,
}) async {
  final photos = getIt<PhotoLibraryService>();
  final perm = await photos.ensurePermission();
  final granted = perm.valueOrNull;
  if (granted == PhotoPermission.denied || !context.mounted) {
    if (context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.dmSendFailed);
    }
    return;
  }
  final pageRes = await photos.loadAssets(page: 0, pageSize: 24);
  final assets = pageRes.valueOrNull?.assets ?? const <AssetRef>[];
  if (!context.mounted || assets.isEmpty) return;

  final picked = await showModalBottomSheet<AssetRef>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _PhotoGridSheet(assets: assets),
  );
  if (picked == null || !context.mounted) return;

  final bytesRes = await photos.originBytes(picked);
  final bytes = bytesRes.valueOrNull;
  if (bytes == null || !context.mounted) {
    if (context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.dmSendFailed);
    }
    return;
  }

  final upload = getIt<MediaUploadService>();
  await for (final event in upload.upload(
    bytes: bytes,
    idempotencyKey: const Uuid().v7(),
  )) {
    if (event is UploadDoneEvent) {
      onUploaded(event.media.id);
    } else if (event is UploadFailedEvent && context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.dmSendFailed);
    }
  }
}

/// A compact gallery grid in a bottom sheet — tapping a thumbnail returns it.
class _PhotoGridSheet extends StatelessWidget {
  const _PhotoGridSheet({required this.assets});

  final List<AssetRef> assets;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final photos = getIt<PhotoLibraryService>();
    return SafeArea(
      child: SizedBox(
        height: 420,
        child: GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.sm),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: assets.length,
          itemBuilder: (context, i) {
            final ref = assets[i];
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(ref),
              child: FutureBuilder<Uint8List?>(
                future: photos.originBytes(ref).then((r) => r.valueOrNull),
                builder: (context, snap) {
                  final data = snap.data;
                  if (data == null) {
                    return Container(color: tokens.surfaceSunken);
                  }
                  return Image.memory(
                    data,
                    fit: BoxFit.cover,
                    cacheWidth: 200,
                    errorBuilder: (_, _, _) =>
                        Container(color: tokens.surfaceSunken),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
