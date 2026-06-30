import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title / wordmark text
  ///
  /// In en, this message translates to:
  /// **'We36'**
  String get appTitle;

  /// Primary destination: Home feed
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Primary destination: Explore
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// Primary destination: Reels
  ///
  /// In en, this message translates to:
  /// **'Reels'**
  String get navReels;

  /// Primary destination: Direct messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// Primary destination: Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Sidebar rail item: Notifications (Activity)
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// Sidebar rail item: Create post/story/reel
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get navCreate;

  /// Stories rail: the current user's add-story tile
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get yourStory;

  /// Follow a user
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get actionFollow;

  /// State when already following a user
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get actionFollowing;

  /// Open a direct message with a user
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get actionMessage;

  /// Share action
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Retry a failed operation
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// Cancel / dismiss
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// PostCard link to the comments screen
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String viewAllComments(String count);

  /// Home right-rail header on wide layouts
  ///
  /// In en, this message translates to:
  /// **'Suggestions for you'**
  String get suggestionsTitle;

  /// Search bar placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// Dev harness: component gallery title
  ///
  /// In en, this message translates to:
  /// **'Component gallery'**
  String get devGalleryTitle;

  /// Dev harness: 4-state demo title
  ///
  /// In en, this message translates to:
  /// **'Four-state demo'**
  String get devStatesTitle;

  /// Dev harness: master/detail demo title
  ///
  /// In en, this message translates to:
  /// **'Two-pane demo'**
  String get devTwoPaneTitle;

  /// AppState.initial label
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get stateInitial;

  /// AppState.loading label
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get stateLoading;

  /// AppState.loaded label
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get stateLoaded;

  /// AppState.error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get stateError;

  /// Two-pane empty detail placeholder
  ///
  /// In en, this message translates to:
  /// **'Select an item'**
  String get selectAnItem;

  /// AppFailure.unauthenticated
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get errUnauthenticated;

  /// AppFailure.sessionExpired
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get errSessionExpired;

  /// AppFailure.invalidCredentials
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errInvalidCredentials;

  /// AppFailure.oauthCancelled
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get errOauthCancelled;

  /// AppFailure.oauthFailed
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get errOauthFailed;

  /// AppFailure.forbidden
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this.'**
  String get errForbidden;

  /// AppFailure.notFound
  ///
  /// In en, this message translates to:
  /// **'This content isn\'t available.'**
  String get errNotFound;

  /// AppFailure.accountSuspended
  ///
  /// In en, this message translates to:
  /// **'This account is suspended.'**
  String get errAccountSuspended;

  /// AppFailure.validation
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get errValidation;

  /// AppFailure.conflict
  ///
  /// In en, this message translates to:
  /// **'That\'s already taken.'**
  String get errConflict;

  /// AppFailure.rateLimited
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get errRateLimited;

  /// AppFailure.uploadFailed
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Please try again.'**
  String get errUploadFailed;

  /// AppFailure.mediaTooLarge
  ///
  /// In en, this message translates to:
  /// **'That file is too large.'**
  String get errMediaTooLarge;

  /// AppFailure.unsupportedMedia
  ///
  /// In en, this message translates to:
  /// **'That file type isn\'t supported.'**
  String get errUnsupportedMedia;

  /// AppFailure.cameraUnavailable
  ///
  /// In en, this message translates to:
  /// **'The camera isn\'t available.'**
  String get errCameraUnavailable;

  /// AppFailure.permissionDenied
  ///
  /// In en, this message translates to:
  /// **'Permission is needed to do that.'**
  String get errPermissionDenied;

  /// AppFailure.realtimeDisconnected
  ///
  /// In en, this message translates to:
  /// **'You\'re offline from live updates.'**
  String get errRealtimeDisconnected;

  /// AppFailure.messageFailed
  ///
  /// In en, this message translates to:
  /// **'Message failed to send.'**
  String get errMessageFailed;

  /// AppFailure.networkError
  ///
  /// In en, this message translates to:
  /// **'Network problem. Please check your connection.'**
  String get errNetwork;

  /// AppFailure.serverError
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side.'**
  String get errServer;

  /// AppFailure.timeout
  ///
  /// In en, this message translates to:
  /// **'That took too long. Please try again.'**
  String get errTimeout;

  /// AppFailure.offline
  ///
  /// In en, this message translates to:
  /// **'You\'re offline.'**
  String get errOffline;

  /// AppFailure.unknown
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errUnknown;

  /// Email field label (auth)
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Password field label (auth)
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// Email field hint (auth)
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get authEmailHint;

  /// Sign in screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// Sign in screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInSubtitle;

  /// Sign in primary button
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authSignInCta;

  /// Link to the forgot-password flow
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordLink;

  /// Divider label between password and OAuth
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOrDivider;

  /// Google OAuth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// Apple OAuth button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// Sign in footer prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccountQuestion;

  /// Link from sign in to sign up
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccountLink;

  /// Sign out action
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authSignOut;

  /// Client-side email validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get authEmailInvalid;

  /// Client-side password length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get authPasswordTooShort;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
