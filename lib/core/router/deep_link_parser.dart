import 'package:we36/core/constants/app_routes.dart';

/// Validates inbound deep links BEFORE routing (Constitution X — a security
/// boundary). #001 wires validation + rejection; per-feature targets
/// (post/profile/hashtag/chat) are added by their specs.
class DeepLinkParser {
  const DeepLinkParser();

  static const String scheme = 'we36';

  /// Known top-level path segments accepted this spec.
  static const Set<String> _knownSegments = {
    'home',
    'explore',
    'reels',
    'messages',
    'profile',
    'notifications',
    'settings',
  };

  /// Returns the in-app route for a valid `we36://` link, or null when the
  /// scheme/host is unknown or malformed (caller falls back safely — no crash).
  String? resolve(Uri uri) {
    if (uri.scheme != scheme) return null;
    final segment = uri.host.isNotEmpty
        ? uri.host
        : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '');
    if (segment.isEmpty || !_knownSegments.contains(segment)) return null;
    return '/$segment';
  }

  /// True when the link is a well-formed, known We36 deep link.
  bool isValid(Uri uri) => resolve(uri) != null;
}

/// Convenience for tests/readers: the destination route for a string link.
String? resolveDeepLink(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri == null) return null;
  final route = const DeepLinkParser().resolve(uri);
  // Guard: never route to an unknown path.
  if (route == null) return null;
  assert(route.startsWith('/'), 'route must be absolute');
  // Sanity: the resolved route must be a real AppRoutes branch root.
  const known = {
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.reels,
    AppRoutes.messages,
    AppRoutes.profile,
    AppRoutes.notifications,
    AppRoutes.settings,
  };
  return known.contains(route) ? route : null;
}
