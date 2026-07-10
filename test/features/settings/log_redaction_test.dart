import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#014, T045; Constitution I / SC-008): the settings + moderation
/// slices must never `print`/`debugPrint` nor log tokens/PII from any
/// privacy/safety action (block, report, follow-request, settings toggle).
void main() {
  final roots = <String>[
    'lib/features/settings',
    'lib/core/data/settings',
    'lib/core/data/moderation',
    'lib/core/data/social',
    'lib/core/presentation/report_sheet.dart',
    'lib/core/presentation/block_report_actions.dart',
  ];

  Iterable<File> sourceFiles() sync* {
    for (final root in roots) {
      final type = FileSystemEntity.typeSync(root);
      if (type == FileSystemEntityType.file) {
        yield File(root);
      } else if (type == FileSystemEntityType.directory) {
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
  }

  test('no print / debugPrint in settings + moderation', () {
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

  test('no logger call leaks tokens or credentials', () {
    final leak = RegExp(
      r'(logger|AppLogger|\.info|\.debug|\.warn|\.error)\s*\([^)]*'
      r'(token|password|\baccessToken\b|\brefreshToken\b)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      if (leak.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
