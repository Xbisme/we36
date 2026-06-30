import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

/// Wires the injectable dependency graph (Constitution XI). Called from
/// bootstrap before the UI starts.
@InjectableInit()
void configureDependencies() => getIt.init();
