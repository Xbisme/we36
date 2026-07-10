import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:we36/app/app.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/router/app_router.dart';
import 'package:we36/core/services/push/push_service.dart';
import 'package:we36/core/utils/app_logger.dart';
import 'package:we36/features/notifications/domain/usecases/push_usecases.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';

/// Pre-runApp setup (Constitution XI): register the flavor config, wire DI, hook
/// sync + async errors into the logger, then start the app.
///
/// We deliberately do NOT wrap `runApp` in `runZonedGuarded` — that requires
/// `ensureInitialized()` to run in the same zone and is an easy source of
/// "Zone mismatch" crashes. `FlutterError.onError` +
/// `platformDispatcher.onError` capture both error classes without a custom zone.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reset so hot-restart re-runs of main() don't double-register.
  await getIt.reset();
  getIt.registerSingleton<AppConfig>(config);
  configureDependencies(environment: config.diEnvironment);

  final logger = getIt<AppLogger>()
    ..info('Bootstrapping We36', data: {'flavor': config.flavor.name});

  FlutterError.onError = (details) => logger.error(
    'FlutterError',
    error: details.exception,
    stackTrace: details.stack,
  );
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    logger.error('Uncaught error', error: error, stackTrace: stack);
    return true;
  };

  final router = getIt<AppRouter>();
  final push = getIt<PushService>();
  // Startup push init (real: Firebase + background handler; no-op in fake mode).
  await push.initialize();
  _wirePushDeepLinks(router, push);

  // Load the device-scoped appearance/language selection before first frame
  // (#014, US5) so the app opens in the chosen theme/locale.
  final appSettings = getIt<AppSettingsCubit>();
  await appSettings.load();

  runApp(We36App(router: router.router, appSettings: appSettings));
}

/// Route a tapped push to its coarse destination (#013 US2/US5): a DM push →
/// Messages, any feed-activity push → Activity. A no-op in fake mode (the fake
/// push service emits nothing). Foreground/background taps route immediately; a
/// cold-start tap routes once the first frame is up. Auth-gating is handled by
/// the router redirect.
void _wirePushDeepLinks(AppRouter router, PushService push) {
  push.onNotificationTap.listen((tap) => router.router.go(pushTapRoute(tap)));
  unawaited(
    push.initialTap().then((tap) {
      if (tap != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => router.router.go(pushTapRoute(tap)),
        );
      }
    }),
  );
}
