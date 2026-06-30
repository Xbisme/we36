import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test bootstrap. Loads the bundled brand fonts (Plus Jakarta Sans +
/// Inter) so golden tests render real glyphs instead of the Ahem fallback —
/// matching the bundled, runtime-fetch-disabled font config (Constitution VI).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('PlusJakartaSans', 'assets/fonts/PlusJakartaSans.ttf');
  await _loadFont('Inter', 'assets/fonts/Inter.ttf');
  await testMain();
}

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = await file.readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)));
  await loader.load();
}
