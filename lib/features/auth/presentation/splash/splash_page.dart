import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';

/// First screen on cold start (Group A · Screen 1). Triggers the one-shot
/// session restore; the router holds here while the session is `unknown`, then
/// redirects to Home / Profile setup / the pre-auth entry once it resolves
/// (spec FR-008/FR-009). Static brand wash — no looping animation, so the
/// transient frame stays test-deterministic (Constitution VI Reduce-Motion).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Resolve the session once; SessionController notifies → router redirects.
    unawaited(getIt<SessionController>().bootstrap());
  }

  @override
  Widget build(BuildContext context) {
    // Splash sits on the brand gradient, so white / translucent-white literals
    // are allowed here (design source of truth).
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.brand),
      child: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Translucent "glass" tile (design-specific 84 / radius-26).
                      Container(
                        width: 84,
                        height: 84,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const AppIcon(
                          AppIcons.camera,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Wordmark(mono: true, fontSize: 48),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'share your world',
                        style: AppTypography.body16.copyWith(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
