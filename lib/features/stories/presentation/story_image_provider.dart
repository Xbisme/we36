import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/di/injection.dart';

const Color _storyBg = Color(0xFF000000);

/// Renders a story segment image, resolving `memory://<id>` refs (offline own
/// stories, #005 finding U1) to their in-memory bytes via [OwnStoryStore]; every
/// other url goes through the network image path (unchanged #004 behavior).
Widget storyImage(String url, {BoxFit fit = BoxFit.cover}) {
  if (url.startsWith('$kOwnStoryScheme://')) {
    final id = url.substring(kOwnStoryScheme.length + 3);
    final bytes = getIt<OwnStoryStore>().bytesFor(id);
    if (bytes != null) {
      return Image.memory(bytes, fit: fit, gaplessPlayback: true);
    }
    return const ColoredBox(color: _storyBg);
  }
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (_, _) => const ColoredBox(color: _storyBg),
    errorWidget: (_, _, _) => const ColoredBox(color: _storyBg),
  );
}
