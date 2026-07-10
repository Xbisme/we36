import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/social/fake_follow_requests_repository.dart';
import 'package:we36/features/settings/presentation/cubit/follow_requests_cubit.dart';
import 'package:we36/features/settings/presentation/pages/follow_requests_page.dart';
import 'package:we36/features/settings/presentation/widgets/request_tile.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('FollowRequestsPage renders seeded requests (US2)', (
    tester,
  ) async {
    await pumpApp(
      tester,
      BlocProvider(
        create: (_) => FollowRequestsCubit(FakeFollowRequestsRepository()),
        child: const FollowRequestsPage(),
      ),
      surfaceSize: const Size(500, 1200),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RequestTile), findsNWidgets(2));
    expect(find.text('Approve'), findsNWidgets(2));
    expect(find.text('Decline'), findsNWidgets(2));
  });
}
