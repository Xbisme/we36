import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

/// DI environment for #002: the app runs on in-memory fakes (no live backend).
/// #003 switches this to a real environment once auth + a backend are wired.
const String diEnvironment = 'fake';

/// Wires the injectable dependency graph (Constitution XI). Called from
/// bootstrap before the UI starts. Defaults to the fake environment (#002).
@InjectableInit()
void configureDependencies({String environment = diEnvironment}) =>
    getIt.init(environment: environment);
