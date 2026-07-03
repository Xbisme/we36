import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#008, T051): the reels feature + its data slice must never
/// write video/poster URLs, tokens, or media byte refs to logs, and must not use
/// `print`/`debugPrint` (Constitution — logging without secrets; SC log gate).
void main() {
  final roots = <String>[
    'lib/features/reels',
    'lib/core/data/reels',
  ];

  Iterable<File> dartFiles() sync* {
    for (final root in roots) {
      final entity = FileSystemEntity.typeSync(root);
      if (entity == FileSystemEntityType.file) {
        yield File(root);
      } else if (entity == FileSystemEntityType.directory) {
        for (final f in Directory(root).listSync(recursive: true)) {
          if (f is File && f.path.endsWith('.dart')) yield f;
        }
      }
    }
  }

  Iterable<File> sourceFiles() => dartFiles().where(
    (f) => !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'),
  );

  test('no print / debugPrint in the reels feature', () {
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

  test('no logger call leaks video/poster URLs, tokens, or byte refs', () {
    final leak = RegExp(
      r'(logger|AppLogger|\.info|\.debug|\.warn|\.error)\s*\([^)]*'
      r'(videoUrl|posterUrl|imageUrl|\bbytes\b|token|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      if (leak.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
