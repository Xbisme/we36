import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Two-factor authentication entry (#014 US6, FR-029) — surface only; full
/// enrolment is out of scope for this release (the backend supports it).
class TwoFactorEntryPage extends StatelessWidget {
  const TwoFactorEntryPage({super.key});

  @override
  Widget build(BuildContext context) => _EntryScaffold(
    title: context.l10n.settingsTwoFactor,
    icon: AppIcons.shield,
    body: context.l10n.twoFactorEntryBody,
  );
}

/// Shared layout for surface-only settings entries (2FA, data export).
class _EntryScaffold extends StatelessWidget {
  const _EntryScaffold({
    required this.title,
    required this.icon,
    required this.body,
  });

  final String title;
  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(title: title, large: true, onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(icon, size: 40, color: tokens.accent),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  title,
                  style: AppTypography.h3.copyWith(color: tokens.textPrimary),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.accentSoft,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    l10n.comingSoon,
                    style: AppTypography.caption.copyWith(color: tokens.accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Download-your-data entry (#014 US6, FR-029) — surface only.
class DataExportEntryPage extends StatelessWidget {
  const DataExportEntryPage({super.key});

  @override
  Widget build(BuildContext context) => _EntryScaffold(
    title: context.l10n.settingsDataExport,
    icon: AppIcons.download,
    body: context.l10n.dataExportEntryBody,
  );
}
