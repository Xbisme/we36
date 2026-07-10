import 'package:flutter/material.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Inline follow-back control for a follow notification (#013 US5). Optimistic:
/// flips Follow → Following on tap, reverting with a toast if the request fails
/// (reuses the shipped #010 follow toggle behind [onFollowBack]).
class FollowBackButton extends StatefulWidget {
  const FollowBackButton({required this.onFollowBack, super.key});

  /// Performs the follow; returns true on success (false → revert).
  final Future<bool> Function() onFollowBack;

  @override
  State<FollowBackButton> createState() => _FollowBackButtonState();
}

class _FollowBackButtonState extends State<FollowBackButton> {
  bool _following = false;
  bool _busy = false;

  Future<void> _onTap() async {
    if (_busy || _following) return;
    setState(() {
      _following = true; // optimistic
      _busy = true;
    });
    final ok = await widget.onFollowBack();
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _following = false; // rollback
    });
    if (!ok && getIt.isRegistered<ToastService>()) {
      getIt<ToastService>().show(context, message: context.l10n.followFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppButton(
      label: _following ? l10n.following : l10n.notifFollowBack,
      kind: _following ? AppButtonKind.secondary : AppButtonKind.primary,
      size: AppButtonSize.sm,
      onPressed: _following ? null : _onTap,
    );
  }
}
