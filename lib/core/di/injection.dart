import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

/// Default DI environment: `'real'` (the live backend). The app runs on real
/// implementations; the `'fake'` env is an in-memory, zero-network graph used
/// only by hermetic tests (`AppConfig.diEnvironment` / `--dart-define=DI_ENV`).
const String diEnvironment = 'real';

/// Wires the injectable dependency graph (Constitution XI). Called from
/// bootstrap before the UI starts with `AppConfig.diEnvironment` (`'real'`);
/// tests opt into the fake graph explicitly.
@InjectableInit()
void configureDependencies({String environment = diEnvironment}) =>
    getIt.init(environment: environment);
