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

  /// Sign up screen title
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignUpTitle;

  /// Sign up primary button
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpCta;

  /// Sign up terms note
  ///
  /// In en, this message translates to:
  /// **'By signing up you agree to our Terms and Privacy Policy.'**
  String get authSignUpTerms;

  /// Sign up footer prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccountQuestion;

  /// Link from sign up to sign in
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLogInLink;

  /// Profile setup screen title
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get authProfileSetupTitle;

  /// Profile setup subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose a username and how your name appears.'**
  String get authProfileSetupSubtitle;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// Username field hint
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get authUsernameHint;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayNameLabel;

  /// Display name field hint
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authDisplayNameHint;

  /// Bio field label (optional)
  ///
  /// In en, this message translates to:
  /// **'Bio (optional)'**
  String get authBioLabel;

  /// Bio field hint
  ///
  /// In en, this message translates to:
  /// **'Tell people about yourself'**
  String get authBioHint;

  /// Profile setup primary button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinueCta;

  /// Username availability: checking
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get authUsernameChecking;

  /// Username availability: available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get authUsernameAvailable;

  /// Username availability: taken
  ///
  /// In en, this message translates to:
  /// **'That username is taken.'**
  String get authUsernameTaken;

  /// Username format rule / invalid
  ///
  /// In en, this message translates to:
  /// **'3–30 chars: lowercase letters, numbers, . or _'**
  String get authUsernameInvalid;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authForgotTitle;

  /// Forgot password subtitle (email step)
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code.'**
  String get authForgotSubtitle;

  /// Send reset code button
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authSendCodeCta;

  /// OTP step title
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get authCodeTitle;

  /// OTP step subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to {email}.'**
  String authCodeSubtitle(String email);

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// Reset password button
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetCta;

  /// Resend code action (enabled)
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// Resend cooldown countdown
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String authResendIn(int seconds);

  /// Toast after a successful reset
  ///
  /// In en, this message translates to:
  /// **'Password reset. Please sign in.'**
  String get authResetDone;

  /// Dev-only OTP hint
  ///
  /// In en, this message translates to:
  /// **'Dev code: {code}'**
  String authDevCode(String code);

  /// Onboarding skip action
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardSkip;

  /// Onboarding primary action → Sign up
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardGetStarted;

  /// Onboarding slide 1 title
  ///
  /// In en, this message translates to:
  /// **'Capture every moment'**
  String get onboardTitle1;

  /// Onboarding slide 1 body
  ///
  /// In en, this message translates to:
  /// **'Share photos and videos with the people who matter.'**
  String get onboardBody1;

  /// Onboarding slide 2 title
  ///
  /// In en, this message translates to:
  /// **'Reels, stories & feed'**
  String get onboardTitle2;

  /// Onboarding slide 2 body
  ///
  /// In en, this message translates to:
  /// **'Discover and create in one playful place.'**
  String get onboardBody2;

  /// Onboarding slide 3 title
  ///
  /// In en, this message translates to:
  /// **'Keep up with friends'**
  String get onboardTitle3;

  /// Onboarding slide 3 body
  ///
  /// In en, this message translates to:
  /// **'Message, react, and stay close.'**
  String get onboardBody3;

  /// Home feed empty state title (no posts from followed accounts)
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get feedEmptyTitle;

  /// Home feed empty state body
  ///
  /// In en, this message translates to:
  /// **'Follow people to see their posts here.'**
  String get feedEmptyBody;

  /// Home feed error state title (first load failed, no cache)
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your feed'**
  String get feedErrorTitle;

  /// Retry action on the feed error state
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get feedRetry;

  /// Post like count label (count is pre-abbreviated, e.g. 38.4k)
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String feedLikesCount(String count);

  /// Toast when an optimistic like is rolled back
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update your like. Try again.'**
  String get feedLikeFailed;

  /// Toast when an optimistic save is rolled back
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save this post. Try again.'**
  String get feedSaveFailed;

  /// Home header Activity (notifications) button label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get feedActivity;

  /// Home header Messages button label
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get feedMessages;

  /// Post comments entry text
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String feedViewAllComments(String count);

  /// Story viewer reply field placeholder (inert in #004)
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get storySendMessage;

  /// Toast when an optimistic story like is rolled back
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t like this story.'**
  String get storyLikeFailed;

  /// Soft message when an opened story expired/was removed
  ///
  /// In en, this message translates to:
  /// **'This story is no longer available.'**
  String get storyUnavailable;

  /// Story viewer close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get storyClose;

  /// Toast for inert story controls (reply/share) not yet available
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get storyComingSoon;

  /// Create Post flow top-bar title (Screens 11–13)
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get composeTitle;

  /// Advance to the next compose step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get composeNext;

  /// Publish the post (caption step)
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get composeShare;

  /// Gallery source label on the pick step
  ///
  /// In en, this message translates to:
  /// **'Recents'**
  String get composeRecents;

  /// Badge shown when multiple photos are selected
  ///
  /// In en, this message translates to:
  /// **'Carousel'**
  String get composeCarousel;

  /// Caption field placeholder
  ///
  /// In en, this message translates to:
  /// **'Write a caption…'**
  String get composeCaptionHint;

  /// Caption-step row: tag people
  ///
  /// In en, this message translates to:
  /// **'Tag people'**
  String get composeTagPeople;

  /// Caption-step row: add location
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get composeAddLocation;

  /// Caption-step toggle to disable comments
  ///
  /// In en, this message translates to:
  /// **'Turn off commenting'**
  String get composeTurnOffComments;

  /// Edit-step filter name
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get composeFilterOriginal;

  /// Edit-step filter name
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get composeFilterWarm;

  /// Edit-step filter name
  ///
  /// In en, this message translates to:
  /// **'Lux'**
  String get composeFilterLux;

  /// Edit-step filter name
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get composeFilterMono;

  /// Edit-step filter name
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get composeFilterFade;

  /// Edit-step adjustment slider
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get composeAdjustBrightness;

  /// Edit-step adjustment slider
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get composeAdjustContrast;

  /// Edit-step adjustment slider
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get composeAdjustWarmth;

  /// Publish-in-progress status
  ///
  /// In en, this message translates to:
  /// **'Sharing…'**
  String get composeUploading;

  /// Cancel the in-flight upload
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get composeCancel;

  /// Retry a failed publish
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get composeRetry;

  /// Toast after a successful publish
  ///
  /// In en, this message translates to:
  /// **'Posted!'**
  String get composePublished;

  /// Toast when publish fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share your post.'**
  String get composeUploadFailed;

  /// Empty state title when library permission is denied
  ///
  /// In en, this message translates to:
  /// **'Allow photo access'**
  String get composePermissionTitle;

  /// Empty state body when library permission is denied
  ///
  /// In en, this message translates to:
  /// **'We36 needs access to your photos to create a post.'**
  String get composePermissionBody;

  /// Button opening system settings for permissions
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get composeOpenSettings;

  /// Empty state when the device has no photos
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get composeEmptyLibrary;

  /// Message when the carousel photo cap is reached
  ///
  /// In en, this message translates to:
  /// **'You can add up to {max} photos.'**
  String composeMaxReached(int max);

  /// Keep/discard dialog title on back-out
  ///
  /// In en, this message translates to:
  /// **'Discard post?'**
  String get composeDiscardTitle;

  /// Keep the in-progress draft
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get composeDiscardKeep;

  /// Discard the in-progress draft
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get composeDiscardDiscard;
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
