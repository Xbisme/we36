import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#009, T050): the discovery feature + its data slice must never
/// write query terms, delivery URLs, or tokens to logs, and must not use
/// `print`/`debugPrint` (Constitution — logging without secrets).
void main() {
  final roots = <String>['lib/features/explore', 'lib/core/data/discovery'];

  Iterable<File> sourceFiles() sync* {
    for (final root in roots) {
      for (final f in Directory(root).listSync(recursive: true)) {
        if (f is File &&
            f.path.endsWith('.dart') &&
            !f.path.endsWith('.g.dart') &&
            !f.path.endsWith('.freezed.dart')) {
          yield f;
        }
      }
    }
  }

  test('no print / debugPrint in the discovery feature', () {
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      final content = file.readAsStringSync();
      if (RegExp(r'\bprint\(').hasMatch(content) ||
          RegExp(r'\bdebugPrint\(').hasMatch(content)) {
        offenders.add(file.path);
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });

  test('no logger call leaks query terms, urls, or tokens', () {
    // Match an actual logger invocation (AppLogger/logger receiver, or a bare
    // .info/.debug/.warn/.error CALL — not a `State.error(...)` constructor,
    // which is `Type.error`), then a sensitive token in its args.
    final leak = RegExp(
      r'(?:AppLogger|_?logger)\s*(?:\.[a-z]+)?\s*\([^)]*'
      r'(query|\bterm\b|thumbnailUrl|videoUrl|posterUrl|imageUrl|token|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      if (leak.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
