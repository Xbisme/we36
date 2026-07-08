import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#012, T053): the messaging feature + its data slice + the
/// realtime wiring must never use `print`/`debugPrint`, nor log message bodies /
/// media refs / participant handles / tokens (Constitution I/XII — logging
/// without secrets, FR-026).
void main() {
  final roots = <String>[
    'lib/features/messaging',
    'lib/core/data/messaging',
    'lib/core/services/realtime',
    'lib/core/services/messaging',
  ];

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

  test('no print / debugPrint in the messaging surface', () {
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

  test(
    'no logger call leaks message bodies, media refs, handles, or tokens',
    () {
      final leak = RegExp(
        r'(?:AppLogger|_?logger)\s*(?:\.[a-z]+)?\s*\([^)]*'
        r'(\.body\b|contentJson|mediaId|\.url\b|token|username|displayName|'
        r'accessToken)\b',
      );
      final offenders = <String>[];
      for (final file in sourceFiles()) {
        final content = file.readAsStringSync();
        if (leak.hasMatch(content)) offenders.add(file.path);
      }
      expect(offenders, isEmpty, reason: offenders.join('\n'));
    },
  );
}
