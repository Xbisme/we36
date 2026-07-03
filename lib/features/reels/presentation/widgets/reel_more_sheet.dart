import 'package:flutter/material.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The per-reel overflow action sheet (#008). **Report** is reachable from every
/// reel (surface-only ack — Constitution I, FR-024a); the viewer's own reel gets
/// **Delete** instead of report (FR-024, confirmed via [onDeleteConfirmed]).
Future<void> showReelMoreSheet(
  BuildContext context, {
  required bool isOwn,
  required Future<void> Function() onDeleteConfirmed,
}) {
  final l10n = context.l10n;
  return showAppActionSheet(
    context,
    cancelLabel: l10n.reelComposeCancel,
    items: [
      if (isOwn)
        ActionSheetItem(
          icon: AppIcons.close,
          label: l10n.reelDelete,
          onTap: () async {
            final confirmed = await _confirmDelete(
              context,
              l10n.reelDeleteConfirm,
            );
            if (confirmed) await onDeleteConfirmed();
          },
        )
      else
        ActionSheetItem(
          icon: AppIcons.more,
          label: l10n.reelReport,
          onTap: () {
            getIt<ToastService>().show(
              context,
              message: l10n.reelReported,
              tone: ToastTone.success,
            );
          },
        ),
    ],
  );
}

Future<bool> _confirmDelete(BuildContext context, String title) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.reelComposeCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.reelDelete),
        ),
      ],
    ),
  );
  return result ?? false;
}
