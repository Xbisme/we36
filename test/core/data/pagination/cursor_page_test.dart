import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';

void main() {
  group('CursorPage.fromJson (US3)', () {
    test('parses items + cursor + hasMore', () {
      final page = CursorPage<String>.fromJson(
        {
          'items': [
            {'v': 'a'},
            {'v': 'b'},
          ],
          'nextCursor': 'c1',
          'hasMore': true,
        },
        (item) => item['v'] as String,
      );
      expect(page.items, ['a', 'b']);
      expect(page.nextCursor, 'c1');
      expect(page.hasMore, isTrue);
    });

    test('null cursor ends pagination regardless of hasMore', () {
      final page = CursorPage<String>.fromJson(
        {
          'items': <dynamic>[],
          'nextCursor': null,
          'hasMore': true,
        },
        (item) => item['v'] as String,
      );
      expect(page.nextCursor, isNull);
      expect(page.hasMore, isFalse);
    });

    test('a malformed item is skipped, not fatal (Constitution IX)', () {
      final page = CursorPage<String>.fromJson(
        {
          'items': [
            {'v': 'a'},
            {'bad': 'no v'}, // itemFromJson throws → skipped
            {'v': 'c'},
          ],
          'nextCursor': null,
          'hasMore': false,
        },
        (item) => item['v'] as String,
      );
      expect(page.items, ['a', 'c']);
    });
  });

  group('PageRequest (US3)', () {
    test('clamps limit to max 30 and builds query', () {
      expect(PageRequest(limit: 100).limit, 30);
      expect(PageRequest().limit, 20);
      expect(PageRequest(cursor: 'c', limit: 10).toQuery(), {
        'cursor': 'c',
        'limit': 10,
      });
      expect(PageRequest().toQuery(), {'limit': 20});
    });
  });
}
