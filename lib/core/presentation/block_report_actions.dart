import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/data/moderation/block_actions.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/report_sheet.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Shared Report + Block action sheet for a target account (#014, FR-013/018,
/// Constitution I/XI). Reachable from every content surface — profile, reel,
/// comment, DM, story — via this one core seam so features never import
/// `features/settings`.
///
/// [userId]/[username] identify the account to block. [reportTargetType] +
/// [reportTargetId] identify what a report is filed against (defaults to the
/// user).
Future<void> showBlockReportActions(
  BuildContext context, {
  required String userId,
  required String username,
  ReportTargetType reportTargetType = ReportTargetType.user,
  String? reportTargetId,
}) {
  final l10n = context.l10n;
  return showAppActionSheet(
    context,
    cancelLabel: l10n.commonCancel,
    items: [
      ActionSheetItem(
        icon: AppIcons.report,
        label: l10n.reportTitle,
        onTap: () => unawaited(
          showReportSheet(
            context,
            targetType: reportTargetType,
            targetId: reportTargetId ?? userId,
            blockUsername: username,
            onBlock: () => confirmAndBlock(context, userId, username),
          ),
        ),
      ),
      ActionSheetItem(
        icon: AppIcons.block,
        label: l10n.blockAction,
        destructive: true,
        onTap: () => unawaited(confirmAndBlock(context, userId, username)),
      ),
    ],
  );
}

/// Confirm-then-block [userId] (#014, FR-015). Optimistic via `BlockActions`;
/// toasts on success/failure. Public so surfaces that build their own action
/// sheet (reels) can reuse the same flow.
Future<void> confirmAndBlock(
  BuildContext context,
  String userId,
  String username,
) async {
  final l10n = context.l10n;
  final ok = await showAppDialog(
    context,
    title: l10n.blockConfirmTitle(username),
    body: l10n.blockConfirmBody,
    primaryLabel: l10n.blockAction,
    secondaryLabel: l10n.commonCancel,
    destructive: true,
  );
  if (!ok || !context.mounted) return;
  final result = await getIt<BlockActions>().block(userId);
  if (!context.mounted) return;
  result.fold(
    (_) => getIt<ToastService>().show(context, message: l10n.blockAck),
    (_) => getIt<ToastService>().show(
      context,
      message: l10n.unblockFailed,
      tone: ToastTone.error,
    ),
  );
}
