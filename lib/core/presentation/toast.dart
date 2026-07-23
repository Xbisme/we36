import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/theme/app_typography.dart';

enum ToastTone { success, info, error, neutral }

/// Centralized toast presenter (Constitution VI) — an ink pill with a colored
/// dot, optional action. NEVER use `ScaffoldMessenger.showSnackBar`.
@lazySingleton
class ToastService {
  OverlayEntry? _entry;

  void show(
    BuildContext context, {
    required String message,
    ToastTone tone = ToastTone.neutral,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _entry?.remove();
    final entry = OverlayEntry(
      builder: (_) => _ToastView(
        message: message,
        tone: tone,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
    _entry = entry;
    overlay.insert(entry);
    Future<void>.delayed(duration, () {
      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }
}

class _ToastView extends StatelessWidget {
  const _ToastView({
    required this.message,
    required this.tone,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final ToastTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  Color get _markColor => switch (tone) {
    ToastTone.success => AppColors.mint400,
    ToastTone.info => AppColors.violet500,
    ToastTone.error => AppColors.rose500,
    ToastTone.neutral => AppColors.gray400,
  };

  IconData get _markIcon => switch (tone) {
    ToastTone.success => AppIcons.check,
    ToastTone.info => AppIcons.notification,
    ToastTone.error => AppIcons.close,
    ToastTone.neutral => AppIcons.check,
  };

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Positioned(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: media.padding.bottom + 72,
      child: SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: AppShadows.lg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _markColor,
                      shape: BoxShape.circle,
                    ),
                    child: AppIcon(_markIcon, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(
                    child: Text(
                      message,
                      style: AppTypography.label.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (actionLabel != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: onAction,
                      child: Text(
                        actionLabel!,
                        style: AppTypography.label.copyWith(
                          color: AppColors.rose300,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
