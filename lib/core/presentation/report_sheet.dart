import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/data/moderation/report_repository.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Localized label for a [ReportReason] (#014, FR-019 — backend-aligned set).
String reportReasonLabel(AppLocalizations l10n, ReportReason reason) =>
    switch (reason) {
      ReportReason.spam => l10n.reportReasonSpam,
      ReportReason.nudityOrSexual => l10n.reportReasonNudity,
      ReportReason.harassmentOrBullying => l10n.reportReasonHarassment,
      ReportReason.hateSpeech => l10n.reportReasonHate,
      ReportReason.violence => l10n.reportReasonViolence,
      ReportReason.selfHarm => l10n.reportReasonSelfHarm,
      ReportReason.falseInformation => l10n.reportReasonFalseInfo,
      ReportReason.intellectualProperty => l10n.reportReasonIp,
      ReportReason.other => l10n.reportReasonOther,
    };

/// Anonymity disclaimer shown atop the report screen (design overlays). English
/// copy is inlined here because the localized string set can't be extended from
/// this scope; localize when the ARB is next touched.
const String _reportDisclaimer =
    'Your report is anonymous. The account you report will not be told who '
    'filed it. If someone is in immediate danger, call your local emergency '
    'services.';

/// Presents the fixed report-reason picker (#014, US3). On selection, submits
/// the report and shows an acknowledgement toast (surface-only). Never surfaces
/// a moderation outcome.
///
/// When [onBlock]/[blockUsername] are provided, an in-report "Block this
/// account" row is offered (matches the mockup, where blocking is reachable
/// from within the report flow).
Future<void> showReportSheet(
  BuildContext context, {
  required ReportTargetType targetType,
  required String targetId,
  String? blockUsername,
  Future<void> Function()? onBlock,
}) async {
  final reason = await showModalBottomSheet<ReportReason>(
    context: context,
    backgroundColor: context.tokens.surface,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => _ReportSheet(
      blockUsername: blockUsername,
      onBlock: onBlock == null
          ? null
          : () {
              Navigator.of(sheetContext).pop();
              unawaited(onBlock());
            },
    ),
  );
  if (reason == null || !context.mounted) return;

  final result = await getIt<ReportRepository>().report(
    targetType: targetType,
    targetId: targetId,
    reason: reason,
  );
  if (!context.mounted) return;
  result.fold(
    (_) => getIt<ToastService>().show(
      context,
      message: context.l10n.reportAck,
      tone: ToastTone.success,
    ),
    (_) => getIt<ToastService>().show(
      context,
      message: context.l10n.reportFailed,
      tone: ToastTone.error,
    ),
  );
}

class _ReportSheet extends StatelessWidget {
  const _ReportSheet({this.blockUsername, this.onBlock});

  final String? blockUsername;
  final VoidCallback? onBlock;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              l10n.reportTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              _reportDisclaimer,
              style: AppTypography.caption.copyWith(
                color: tokens.textSecondary,
              ),
            ),
          ),
          // 8px surface-2 band that separates the disclaimer from the reasons.
          Container(height: AppSpacing.sm, color: tokens.surface2),
          // Scrollable so the full reason set never overflows a short sheet or
          // at large text scale (a11y).
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final reason in ReportReason.values)
                    Semantics(
                      button: true,
                      label: reportReasonLabel(l10n, reason),
                      child: Pressable(
                        onTap: () => Navigator.of(context).pop(reason),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: tokens.divider),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  reportReasonLabel(l10n, reason),
                                  style: AppTypography.body16.copyWith(
                                    color: tokens.textPrimary,
                                  ),
                                ),
                              ),
                              AppIcon(
                                AppIcons.chevronRight,
                                size: 20,
                                color: tokens.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (onBlock != null && blockUsername != null)
                    _BlockRow(username: blockUsername!, onTap: onBlock!),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Red "Block this account" row with an error-soft icon circle (design).
class _BlockRow extends StatelessWidget {
  const _BlockRow({required this.username, required this.onTap});

  final String username;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      label: context.l10n.blockAction,
      child: Pressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tokens.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: AppIcon(AppIcons.block, size: 18, color: tokens.error),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  context.l10n.blockAction,
                  style: AppTypography.body16.copyWith(color: tokens.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
