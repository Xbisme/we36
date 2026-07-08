import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The per-message delivery indicator under an own bubble (#012 US2, FR-010):
/// sending → sent → delivered → read, plus a tappable "Not delivered" on failure.
class DeliveryStatus extends StatelessWidget {
  const DeliveryStatus({required this.state, super.key});

  final DeliveryState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final (label, color) = switch (state) {
      DeliveryState.sending => (l10n.dmSending, tokens.textTertiary),
      DeliveryState.sent => (l10n.dmSent, tokens.textTertiary),
      DeliveryState.delivered => (l10n.dmDelivered, tokens.textTertiary),
      DeliveryState.read => (l10n.dmSeen, tokens.textSecondary),
      DeliveryState.failed => (l10n.dmFailed, tokens.error),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 2, right: 4),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: color, fontSize: 11),
      ),
    );
  }
}
