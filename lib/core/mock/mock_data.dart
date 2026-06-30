/// In-memory sample data for #001 placeholders + goldens. NOT the real domain
/// models — no JSON, no persistence, no network (FR-026). Images are omitted on
/// purpose: components render tasteful placeholders, keeping renders offline and
/// golden-deterministic.
library;

class MockUser {
  const MockUser({
    required this.username,
    required this.displayName,
    this.hasUnseenStory = false,
    this.storySeen = false,
    this.isOnline = false,
  });

  final String username;
  final String displayName;
  final bool hasUnseenStory;
  final bool storySeen;
  final bool isOnline;
}

class MockPost {
  const MockPost({
    required this.author,
    required this.likeCount,
    required this.caption,
    required this.commentCount,
    required this.minutesAgo,
    this.location,
  });

  final MockUser author;
  final int likeCount;
  final String caption;
  final int commentCount;
  final int minutesAgo;
  final String? location;
}

class MockConversation {
  const MockConversation({
    required this.peer,
    required this.preview,
    required this.minutesAgo,
    this.unread = false,
    this.typing = false,
  });

  final MockUser peer;
  final String preview;
  final int minutesAgo;
  final bool unread;
  final bool typing;
}

/// Curated sample lists used by the placeholder destinations + dev harness.
abstract final class MockData {
  static const me = MockUser(username: 'you', displayName: 'You');

  static const users = <MockUser>[
    MockUser(
      username: 'mira.kw',
      displayName: 'Mira',
      hasUnseenStory: true,
      isOnline: true,
    ),
    MockUser(username: 'leoo', displayName: 'Leo', hasUnseenStory: true),
    MockUser(username: 'sana.h', displayName: 'Sana', storySeen: true),
    MockUser(
      username: 'devon',
      displayName: 'Devon',
      hasUnseenStory: true,
      isOnline: true,
    ),
    MockUser(username: 'yuki.t', displayName: 'Yuki', storySeen: true),
  ];

  static const posts = <MockPost>[
    MockPost(
      author: MockUser(
        username: 'mira.kw',
        displayName: 'Mira',
        isOnline: true,
      ),
      likeCount: 38400,
      caption: 'golden hour never misses 🌅',
      commentCount: 86,
      minutesAgo: 120,
      location: 'Lisbon, Portugal',
    ),
    MockPost(
      author: MockUser(username: 'devon', displayName: 'Devon'),
      likeCount: 1240,
      caption: 'studio days. new drop soon.',
      commentCount: 24,
      minutesAgo: 360,
    ),
    MockPost(
      author: MockUser(username: 'yuki.t', displayName: 'Yuki'),
      likeCount: 1200000,
      caption: 'morning ritual ☕',
      commentCount: 980,
      minutesAgo: 1440,
      location: 'Kyoto',
    ),
  ];

  static const conversations = <MockConversation>[
    MockConversation(
      peer: MockUser(username: 'mira.kw', displayName: 'Mira', isOnline: true),
      preview: 'see you tomorrow!',
      minutesAgo: 8,
      unread: true,
    ),
    MockConversation(
      peer: MockUser(username: 'leoo', displayName: 'Leo'),
      preview: 'typing…',
      minutesAgo: 40,
      typing: true,
    ),
    MockConversation(
      peer: MockUser(username: 'sana.h', displayName: 'Sana'),
      preview: 'sent the files',
      minutesAgo: 180,
    ),
  ];

  static List<String> get exploreTags => [
    'For you',
    'travel',
    'food',
    'design',
    'fitness',
  ];
}
