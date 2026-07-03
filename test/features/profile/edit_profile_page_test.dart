import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_state.dart';
import 'package:we36/features/profile/presentation/edit_profile_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #010 T049: the edit page renders pre-filled fields, gates Save on the username
/// status, and confirms discarding unsaved edits. Stub cubit — no drift.
class StubEditProfileCubit extends Cubit<EditProfileState>
    implements EditProfileCubit {
  StubEditProfileCubit(super.initialState);
  @override
  Future<void> load() async {}
  @override
  void updateDisplayName(String value) {}
  @override
  void updatePronouns(String value) {}
  @override
  void updateWebsite(String value) {}
  @override
  void updateBio(String value) {}
  @override
  Future<void> updateUsername(String value) async {}
  @override
  Future<bool> changeAvatar(Uint8List bytes) async => true;
  @override
  Future<bool> save() async => true;
}

EditProfileState _editing({
  UsernameStatus status = UsernameStatus.idle,
  bool dirty = true,
}) => EditProfileState.editing(
  displayName: 'Demo',
  username: 'demo',
  originalUsername: 'demo',
  bio: 'hi',
  usernameStatus: status,
  dirty: dirty,
);

void main() {
  setUp(() => GetIt.I.registerLazySingleton<ToastService>(ToastService.new));
  tearDown(GetIt.I.reset);

  Widget host(EditProfileState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<EditProfileCubit>.value(
      value: StubEditProfileCubit(state),
      child: const EditProfilePage(),
    ),
  );

  testWidgets('renders pre-filled fields', (tester) async {
    await tester.pumpWidget(host(_editing()));
    await tester.pump();
    expect(find.byType(AppTextField), findsNWidgets(5));
    expect(find.text('Change profile photo'), findsOneWidget);
    expect(find.text('Demo'), findsOneWidget); // name field pre-filled
  });

  testWidgets('a taken username disables Save', (tester) async {
    await tester.pumpWidget(host(_editing(status: UsernameStatus.taken)));
    await tester.pump();
    final saveButton = tester.widget<IconButton>(
      find.byType(IconButton).last,
    );
    expect(saveButton.onPressed, isNull);
  });

  testWidgets('backing out with unsaved edits confirms discard', (
    tester,
  ) async {
    await tester.pumpWidget(host(_editing()));
    await tester.pump();
    await tester.tap(find.byType(IconButton).first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Discard changes?'), findsOneWidget);
  });
}
