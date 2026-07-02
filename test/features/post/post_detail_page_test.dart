import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';
import 'package:we36/features/post/presentation/post_detail_page.dart';
import 'package:we36/features/post/presentation/widgets/comment_input.dart';
import 'package:we36/features/post/presentation/widgets/comment_tile.dart';

import '../../helpers/comment_test_doubles.dart';
import '../../helpers/pump_app.dart';

void main() {
  late FakeCommentsRepository comments;

  setUp(() {
    comments = FakeCommentsRepository(
      clock: () => DateTime.utc(2026, 7, 2, 12),
    );
  });

  Future<CommentsCubit> loaded(String id, {int commentCount = 3}) async {
    final cubit = buildCommentsCubit(
      comments,
      FakeFeed({id: fakePost(id, commentCount: commentCount)}),
    );
    await cubit.load(id);
    return cubit;
  }

  Future<void> pumpPage(WidgetTester tester, CommentsCubit cubit) async {
    await pumpApp(
      tester,
      BlocProvider<CommentsCubit>.value(
        value: cubit,
        child: const PostDetailPage(),
      ),
      // Tall surface so the comment list is laid out below the post header
      // (the lazy sliver only builds on-screen tiles).
      surfaceSize: const Size(420, 2200),
    );
    await tester.pump();
  }

  testWidgets('renders the post + its comments', (tester) async {
    final cubit = await loaded('post-001');
    addTearDown(cubit.close);
    await pumpPage(tester, cubit);

    expect(find.byType(CommentTile), findsWidgets);
    expect(find.byType(CommentInput), findsOneWidget);
  });

  testWidgets('shows the empty state for a post with no comments', (
    tester,
  ) async {
    final cubit = await loaded('post-004', commentCount: 0);
    addTearDown(cubit.close);
    await pumpPage(tester, cubit);

    expect(find.text('No comments yet'), findsOneWidget);
    expect(find.byType(CommentTile), findsNothing);
  });

  testWidgets('shows an error with retry, then loads on retry', (tester) async {
    final cubit = buildCommentsCubit(
      comments,
      FakeFeed({'post-001': fakePost('post-001')}),
    );
    addTearDown(cubit.close);
    comments.failNextLoad = true;
    await cubit.load('post-001');
    await pumpPage(tester, cubit);

    expect(find.text("Couldn't load comments"), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Retry'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppButton, 'Retry'));
    await tester.pump(); // retry() runs
    await tester.pump();
    expect(find.byType(CommentTile), findsWidgets);
  });
}
