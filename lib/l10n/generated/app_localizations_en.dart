// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'We36';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navReels => 'Reels';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navCreate => 'Create';

  @override
  String get yourStory => 'Your story';

  @override
  String get actionFollow => 'Follow';

  @override
  String get actionFollowing => 'Following';

  @override
  String get actionMessage => 'Message';

  @override
  String get actionShare => 'Share';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionCancel => 'Cancel';

  @override
  String viewAllComments(String count) {
    return 'View all $count comments';
  }

  @override
  String get suggestionsTitle => 'Suggestions for you';

  @override
  String get searchHint => 'Search';

  @override
  String get devGalleryTitle => 'Component gallery';

  @override
  String get devStatesTitle => 'Four-state demo';

  @override
  String get devTwoPaneTitle => 'Two-pane demo';

  @override
  String get stateInitial => 'Initial';

  @override
  String get stateLoading => 'Loading';

  @override
  String get stateLoaded => 'Loaded';

  @override
  String get stateError => 'Error';

  @override
  String get selectAnItem => 'Select an item';

  @override
  String get errUnauthenticated => 'Please sign in to continue.';

  @override
  String get errSessionExpired => 'Your session expired. Please sign in again.';

  @override
  String get errInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errOauthCancelled => 'Sign-in was cancelled.';

  @override
  String get errOauthFailed => 'Sign-in failed. Please try again.';

  @override
  String get errForbidden => 'You don\'t have access to this.';

  @override
  String get errNotFound => 'This content isn\'t available.';

  @override
  String get errAccountSuspended => 'This account is suspended.';

  @override
  String get errValidation => 'Please check the highlighted fields.';

  @override
  String get errConflict => 'That\'s already taken.';

  @override
  String get errRateLimited => 'Too many attempts. Please wait a moment.';

  @override
  String get errUploadFailed => 'Upload failed. Please try again.';

  @override
  String get errMediaTooLarge => 'That file is too large.';

  @override
  String get errUnsupportedMedia => 'That file type isn\'t supported.';

  @override
  String get errCameraUnavailable => 'The camera isn\'t available.';

  @override
  String get errPermissionDenied => 'Permission is needed to do that.';

  @override
  String get errRealtimeDisconnected => 'You\'re offline from live updates.';

  @override
  String get errMessageFailed => 'Message failed to send.';

  @override
  String get errNetwork => 'Network problem. Please check your connection.';

  @override
  String get errServer => 'Something went wrong on our side.';

  @override
  String get errTimeout => 'That took too long. Please try again.';

  @override
  String get errOffline => 'You\'re offline.';

  @override
  String get errUnknown => 'Something went wrong.';
}
