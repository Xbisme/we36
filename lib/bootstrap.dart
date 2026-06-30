import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:we36/app/app.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/router/app_router.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Pre-runApp setup (Constitution XI): register the flavor config, wire DI, hook
/// errors into the logger, then start the app inside a guarded zone.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<AppConfig>(config);
  configureDependencies();

  final logger = getIt<AppLogger>()
    ..info('Bootstrapping We36', data: {'flavor': config.flavor.name});

  FlutterError.onError = (details) => logger.error(
    'FlutterError',
    error: details.exception,
    stackTrace: details.stack,
  );

  runZonedGuarded(
    () => runApp(We36App(router: getIt<AppRouter>().router)),
    (error, stack) =>
        logger.error('Uncaught zone error', error: error, stackTrace: stack),
  );
}
