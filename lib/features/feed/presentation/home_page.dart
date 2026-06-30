import 'package:flutter/material.dart';
import 'package:we36/core/mock/mock_data.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/stories_rail.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

/// Home feed placeholder rendered at real fidelity from mock data (FR-025) —
/// StoriesRail + PostCards. No network, no repository (FR-026).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    const counts = CountFormatter();
    const time = RelativeTimeFormatter();
    final now = DateTime(2026, 6, 30, 12);

    final stories = <StoryItem>[
      const StoryItem(label: 'Your story', isYou: true),
      for (final u in MockData.users)
        StoryItem(label: u.displayName, seen: u.storySeen),
    ];

    return SafeArea(
      child: Column(
        children: [
          // Header: wordmark + Activity + Messages (phone shortcuts)
          const SizedBox(
            height: 52,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Wordmark(fontSize: 24),
                  Spacer(),
                  AppIconButton(
                    icon: AppIcons.notification,
                    semanticLabel: 'Activity',
                    badgeCount: 2,
                  ),
                  AppIconButton(
                    icon: AppIcons.messages,
                    semanticLabel: 'Messages',
                    badgeCount: 3,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: MaxWidthBox(
              maxWidth: AppSpacing.feedMaxWidth,
              child: ListView(
                children: [
                  StoriesRail(items: stories),
                  Divider(height: 1, color: tokens.divider),
                  for (final p in MockData.posts)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: PostCard(
                        username: p.author.username,
                        likesText: '${counts.format(p.likeCount)} likes',
                        caption: p.caption,
                        location: p.location,
                        commentsText: p.commentCount > 0
                            ? 'View all ${p.commentCount} comments'
                            : null,
                        timeText: time.format(
                          now.subtract(Duration(minutes: p.minutesAgo)),
                          now: now,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
