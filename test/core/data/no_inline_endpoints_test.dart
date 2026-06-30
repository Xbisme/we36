import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guard (US6 / FR-026): the data layer must reference endpoint paths + socket
/// event names from the central constants (`ApiEndpoints` / `SocketEvents`), not
/// inline string literals. Generated files are excluded.
void main() {
  test('no inline /v1 paths or raw socket-event literals in lib/core/data', () {
    final dir = Directory('lib/core/data');
    final offenders = <String>[];

    final forbidden = <RegExp>[
      RegExp('''['"]/v1/'''), // raw versioned path
      RegExp(
        r'''['"](message|typing|presence|conversation|notification)\.[a-z]''',
      ),
    ];

    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }
      final content = entity.readAsStringSync();
      for (final pattern in forbidden) {
        if (pattern.hasMatch(content)) {
          offenders.add('${entity.path} matches ${pattern.pattern}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Use ApiEndpoints / SocketEvents constants instead of literals:\n'
          '${offenders.join('\n')}',
    );
  });
}
