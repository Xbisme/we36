import 'package:flutter/widgets.dart';
import 'package:we36/app/app.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/router/app_router.dart';
import 'package:we36/core/utils/app_logger.dart';

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
  configureDependencies();

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

  runApp(We36App(router: getIt<AppRouter>().router));
}
