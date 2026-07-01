import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';

/// Who a story is published to (#005). Lives in core because [StorySegment]
/// (core) carries it; the compose feature reads it from here. `closeFriends`
/// list management belongs to #014 — this only records the choice.
enum StoryAudience { yourStory, closeFriends }

/// One image segment within a story reel (#004 — image segments only; video is
/// reels #008). `viewerHasLiked` is in-memory (fake) this spec. `imageUrl` may
/// be a `memory://<id>` ref for an offline-published own story (#005) — the
/// story image rendering resolves it via `MemoryImage(OwnStoryStore.bytesFor)`
/// (see #005 T020a).
@freezed
abstract class StorySegment with _$StorySegment {
  const factory StorySegment({
    required String id,
    required String authorId,
    required String imageUrl,
    required int durationMs,
    required int position,
    required DateTime createdAt,
    @Default(false) bool viewerHasLiked,
    @Default(StoryAudience.yourStory) StoryAudience audience,
  }) = _StorySegment;
}

/// One account's set of active story segments (#004). `hasUnseen` is derived by
/// merging the reel with the persisted seen-set — it drives the rail ring
/// (unseen gradient vs seen desaturated). `isYou` is the current user's own
/// "Your story" entry.
@freezed
abstract class StoryReel with _$StoryReel {
  const factory StoryReel({
    required String authorId,
    required String username,
    required List<StorySegment> segments,
    required bool hasUnseen,
    required DateTime latestAt,
    String? avatarUrl,
    @Default(false) bool isYou,
  }) = _StoryReel;
}
