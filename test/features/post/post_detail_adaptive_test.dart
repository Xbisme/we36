import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
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

  Future<CommentsCubit> loaded() async {
    final cubit = buildCommentsCubit(
      comments,
      FakeFeed({'post-001': fakePost('post-001', commentCount: 5)}),
    );
    await cubit.load('post-001');
    return cubit;
  }

  Future<void> pumpAt(
    WidgetTester tester,
    CommentsCubit cubit,
    Size size,
  ) async {
    await pumpApp(
      tester,
      BlocProvider<CommentsCubit>.value(
        value: cubit,
        child: const PostDetailPage(),
      ),
      surfaceSize: size,
    );
    await tester.pump();
  }

  final mediaPane = find.byKey(const Key('post-media-pane'));

  testWidgets('phone width → single column, no media pane', (tester) async {
    final cubit = await loaded();
    addTearDown(cubit.close);
    await pumpAt(tester, cubit, const Size(420, 2200));

    expect(mediaPane, findsNothing);
    expect(find.byType(CommentInput), findsOneWidget);
    expect(find.byType(CommentTile), findsWidgets);
  });

  testWidgets('tablet width → two-column split with a media pane', (
    tester,
  ) async {
    final cubit = await loaded();
    addTearDown(cubit.close);
    await pumpAt(tester, cubit, const Size(1200, 1600));

    expect(mediaPane, findsOneWidget);
    // Same behavior: comments + input present in the right pane.
    expect(find.byType(CommentInput), findsOneWidget);
    expect(find.byType(CommentTile), findsWidgets);
  });
}
