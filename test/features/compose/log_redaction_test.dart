import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (FR-024 / SC-008): the compose flow and its media pipeline must
/// never write media paths, raw bytes, or PII to logs. We forbid `print` /
/// `debugPrint` outright and forbid any logger call that passes image bytes or a
/// device asset path. `MediaUploadService` may log by index/size only.
void main() {
  final roots = <String>[
    'lib/features/compose',
    'lib/core/services/media_upload_service.dart',
    'lib/core/services/media_upload_service_fake.dart',
    'lib/core/services/image_processing_service.dart',
    'lib/core/services/photo_library_service.dart',
  ];

  Iterable<File> dartFiles() sync* {
    for (final root in roots) {
      final entity = FileSystemEntity.typeSync(root);
      if (entity == FileSystemEntityType.file) {
        yield File(root);
      } else {
        for (final f in Directory(root).listSync(recursive: true)) {
          if (f is File && f.path.endsWith('.dart')) yield f;
        }
      }
    }
  }

  test('no print / debugPrint in the compose + media pipeline', () {
    final offenders = <String>[];
    for (final file in dartFiles()) {
      if (file.path.endsWith('.g.dart') ||
          file.path.endsWith('.freezed.dart')) {
        continue;
      }
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

  test('no logger call leaks raw media bytes or asset paths', () {
    // A logger call (info/debug/warn/error/AppLogger) that mentions the byte
    // buffers or an origin path would leak media — forbid it (FR-024).
    final leak = RegExp(
      r'(logger|AppLogger|\.info|\.debug|\.warn|\.error)\s*\([^)]*'
      r'(originBytes|source|bytes|filePath|assetPath|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in dartFiles()) {
      final content = file.readAsStringSync();
      if (leak.hasMatch(content)) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
