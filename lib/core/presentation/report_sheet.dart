import 'package:flutter/material.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/data/moderation/report_repository.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
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

/// Presents the fixed report-reason picker (#014, US3). On selection, submits
/// the report and shows an acknowledgement toast (surface-only). Never surfaces
/// a moderation outcome.
Future<void> showReportSheet(
  BuildContext context, {
  required ReportTargetType targetType,
  required String targetId,
}) async {
  final reason = await showModalBottomSheet<ReportReason>(
    context: context,
    backgroundColor: context.tokens.surface,
    showDragHandle: true,
    builder: (sheetContext) => _ReportSheet(),
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
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              l10n.reportTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
          ),
          for (final reason in ReportReason.values)
            Semantics(
              button: true,
              label: reportReasonLabel(l10n, reason),
              child: Pressable(
                onTap: () => Navigator.of(context).pop(reason),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Text(
                    reportReasonLabel(l10n, reason),
                    style: AppTypography.body16.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
