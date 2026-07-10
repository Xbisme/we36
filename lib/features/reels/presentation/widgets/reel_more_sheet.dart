import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/block_report_actions.dart';
import 'package:we36/core/presentation/report_sheet.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The per-reel overflow action sheet (#008/#014). **Report** + **Block** are
/// reachable from every non-own reel (Constitution I, FR-013/018); the viewer's
/// own reel gets **Delete** instead (FR-024, confirmed via [onDeleteConfirmed]).
Future<void> showReelMoreSheet(
  BuildContext context, {
  required bool isOwn,
  required String reelId,
  required String authorId,
  required String authorUsername,
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
      else ...[
        ActionSheetItem(
          icon: AppIcons.report,
          label: l10n.reportTitle,
          onTap: () => unawaited(
            showReportSheet(
              context,
              targetType: ReportTargetType.reel,
              targetId: reelId,
            ),
          ),
        ),
        ActionSheetItem(
          icon: AppIcons.block,
          label: l10n.blockAction,
          destructive: true,
          onTap: () => unawaited(
            confirmAndBlock(context, authorId, authorUsername),
          ),
        ),
      ],
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
