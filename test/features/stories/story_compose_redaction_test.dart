import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#005 FR-019): the create-story flow + its pipeline must never
/// write media bytes, memory refs, or PII to logs, and must not use
/// `print`/`debugPrint`.
void main() {
  final roots = <String>[
    'lib/features/stories',
    'lib/core/data/stories/own_story_store.dart',
    'lib/core/services/story_image_composer.dart',
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

  test('no print / debugPrint in the story flow', () {
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
      reason: 'Use AppLogger (redacted), never print/debugPrint:\n'
          '${offenders.join('\n')}',
    );
  });

  test('no logger call leaks raw media bytes or refs', () {
    final leak = RegExp(
      r'(logger|AppLogger|\.info|\.debug|\.warn|\.error)\s*\([^)]*'
      r'(imageBytes|bytes|pngBytes|originBytes|imageUrl|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      if (leak.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
