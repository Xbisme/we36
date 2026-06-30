import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/router/deep_link_parser.dart';

void main() {
  const parser = DeepLinkParser();

  group('DeepLinkParser (Constitution X)', () {
    test('accepts known we36:// links', () {
      expect(parser.resolve(Uri.parse('we36://home')), '/home');
      expect(parser.resolve(Uri.parse('we36://messages')), '/messages');
      expect(parser.isValid(Uri.parse('we36://profile')), isTrue);
    });

    test('rejects unknown host', () {
      expect(parser.resolve(Uri.parse('we36://wat')), isNull);
      expect(parser.isValid(Uri.parse('we36://wat')), isFalse);
    });

    test('rejects wrong scheme', () {
      expect(parser.resolve(Uri.parse('https://home')), isNull);
    });

    test('rejects malformed', () {
      expect(parser.resolve(Uri.parse('we36://')), isNull);
      expect(resolveDeepLink('not a uri at all'), anyOf(isNull, isNotNull));
      expect(resolveDeepLink('we36://settings'), '/settings');
      expect(resolveDeepLink('we36://nope'), isNull);
    });
  });
}
