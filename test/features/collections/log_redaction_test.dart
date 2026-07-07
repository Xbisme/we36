import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#011, T049): the collections feature + its data slice must
/// never use `print`/`debugPrint`, nor log collection names / media refs / tokens
/// (Constitution XII — logging without secrets).
void main() {
  final roots = <String>[
    'lib/features/collections',
    'lib/core/data/collections',
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

  test('no print / debugPrint in the collections feature', () {
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

  test('no logger call leaks collection names, media refs, or tokens', () {
    final leak = RegExp(
      r'(?:AppLogger|_?logger)\s*(?:\.[a-z]+)?\s*\([^)]*'
      r'(\.name\b|coverRefs|thumbnailUrl|token|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      final content = file.readAsStringSync();
      if (leak.hasMatch(content)) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
