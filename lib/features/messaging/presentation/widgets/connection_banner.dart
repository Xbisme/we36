import 'package:flutter/material.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/services/realtime/realtime_connection_manager.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// A thin, non-blocking "connecting…" strip shown while the realtime channel is
/// down (#012 T055, FR-029). The app stays read-only-usable from cache; the
/// banner just surfaces the degraded state quietly. Guarded by `getIt` so a
/// minimal DI (tests) still renders nothing.
class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<RealtimeConnectionManager>()) {
      return const SizedBox.shrink();
    }
    final manager = getIt<RealtimeConnectionManager>();
    final tokens = context.tokens;
    return StreamBuilder<RealtimeConnectionState>(
      stream: manager.connectionState,
      initialData: manager.state,
      builder: (context, snapshot) {
        final down =
            snapshot.data is RtReconnecting || snapshot.data is RtDisconnected;
        if (!down) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          color: tokens.surfaceSunken,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            context.l10n.dmOffline,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
          ),
        );
      },
    );
  }
}
