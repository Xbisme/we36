import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#006 FR-020): the post-detail + comments code must never write
/// comment text, author identity, or other PII to logs, and must not use
/// `print`/`debugPrint`.
void main() {
  final roots = <String>[
    'lib/features/post',
    'lib/core/data/comments',
  ];

  Iterable<File> dartFiles() sync* {
    for (final root in roots) {
      for (final f in Directory(root).listSync(recursive: true)) {
        if (f is File && f.path.endsWith('.dart')) yield f;
      }
    }
  }

  Iterable<File> sourceFiles() => dartFiles().where(
    (f) => !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'),
  );

  test('no print / debugPrint in the post/comments code', () {
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      final content = file.readAsStringSync();
      if (RegExp(r'\bprint\(').hasMatch(content) ||
          RegExp(r'\bdebugPrint\(').hasMatch(content)) {
        offenders.add(file.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Use AppLogger (redacted), never print/debugPrint:\n'
          '${offenders.join('\n')}',
    );
  });

  test('no logger call leaks comment text or author identity', () {
    final leak = RegExp(
      r'(logger|AppLogger|\.info|\.debug|\.warn|\.error)\s*\([^)]*'
      r'(\.text|\.author|\.username|\.displayName|comment\.text)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      if (leak.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
