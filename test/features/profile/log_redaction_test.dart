import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Privacy guard (#010, T055): the profile feature + its data slice must never
/// use `print`/`debugPrint`, nor log handles/urls/tokens (Constitution XII —
/// logging without secrets).
void main() {
  final roots = <String>['lib/features/profile', 'lib/core/data/profile'];

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

  test('no print / debugPrint in the profile feature', () {
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

  test('no logger call leaks handles, urls, or tokens', () {
    final leak = RegExp(
      r'(?:AppLogger|_?logger)\s*(?:\.[a-z]+)?\s*\([^)]*'
      r'(username|avatarUrl|avatarMediaId|token|\.path)\b',
    );
    final offenders = <String>[];
    for (final file in sourceFiles()) {
      final content = file.readAsStringSync();
      if (leak.hasMatch(content)) offenders.add(file.path);
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
