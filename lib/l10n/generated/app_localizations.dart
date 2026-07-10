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

  /// Edit-step: enter crop mode
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get composeCrop;

  /// Confirm the crop rectangle
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get composeCropDone;

  /// Edit-step tab: preset filters
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get composeFilters;

  /// Edit-step tab: brightness/contrast/warmth
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get composeAdjust;

  /// Story compose: publish the story
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get storyShare;

  /// Story audience: visible to followers
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get storyYourStory;

  /// Story audience: visible to close friends only
  ///
  /// In en, this message translates to:
  /// **'Close friends'**
  String get storyCloseFriends;

  /// Story compose: add a text overlay
  ///
  /// In en, this message translates to:
  /// **'Add text'**
  String get storyAddText;

  /// Story compose: open the sticker tray
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get storyStickers;

  /// Story compose: upload in progress
  ///
  /// In en, this message translates to:
  /// **'Sharing…'**
  String get storyUploading;

  /// Story compose: publish success toast
  ///
  /// In en, this message translates to:
  /// **'Added to your story!'**
  String get storyPublished;

  /// Story compose: publish failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share your story.'**
  String get storyUploadFailed;

  /// Discard dialog title on back-out
  ///
  /// In en, this message translates to:
  /// **'Discard story?'**
  String get storyDiscardTitle;

  /// Keep the in-progress story
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get storyDiscardKeep;

  /// Discard the in-progress story
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get storyDiscardDiscard;

  /// Post detail screen title (#006)
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postTitle;

  /// Comments screen/pane title
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// Comment input placeholder
  ///
  /// In en, this message translates to:
  /// **'Add a comment…'**
  String get commentAddHint;

  /// Submit a comment button
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get commentPost;

  /// Reply to a comment action
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get commentReply;

  /// Expand a comment's replies
  ///
  /// In en, this message translates to:
  /// **'View {count} replies'**
  String commentViewReplies(String count);

  /// Reply-to banner above the input
  ///
  /// In en, this message translates to:
  /// **'Replying to {handle}'**
  String commentReplyingTo(String handle);

  /// Dismiss the reply-to banner
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get commentReplyCancel;

  /// Delete own comment (action sheet)
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commentDelete;

  /// Report another's comment (action sheet)
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get commentReport;

  /// Cancel the comment action sheet
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commentActionsCancel;

  /// Confirm-delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete comment?'**
  String get commentDeleteConfirmTitle;

  /// Confirm-delete dialog body
  ///
  /// In en, this message translates to:
  /// **'This comment and its replies will be removed.'**
  String get commentDeleteConfirmBody;

  /// Confirm delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commentDeleteConfirm;

  /// Cancel delete
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commentDeleteCancel;

  /// Shown when a post disables comments
  ///
  /// In en, this message translates to:
  /// **'Comments are turned off'**
  String get commentsDisabledNotice;

  /// Empty comment list
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get commentsEmpty;

  /// Empty comment list subtitle
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment.'**
  String get commentsEmptyHint;

  /// Comment list first-load error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load comments'**
  String get commentsError;

  /// Offline comment list notice
  ///
  /// In en, this message translates to:
  /// **'Comments unavailable offline'**
  String get commentsOffline;

  /// Retry loading comments
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commentRetry;

  /// Add-comment failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t post your comment.'**
  String get commentAddFailed;

  /// Comment like failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the like.'**
  String get commentLikeFailed;

  /// Delete-comment failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the comment.'**
  String get commentDeleteFailed;

  /// Report acknowledgement toast
  ///
  /// In en, this message translates to:
  /// **'Thanks — we\'ll review this comment.'**
  String get commentReported;

  /// Reels tab title
  ///
  /// In en, this message translates to:
  /// **'Reels'**
  String get reelsTitle;

  /// Empty reels feed
  ///
  /// In en, this message translates to:
  /// **'No reels yet'**
  String get reelsEmpty;

  /// Empty reels feed subtitle
  ///
  /// In en, this message translates to:
  /// **'Reels you follow will show up here.'**
  String get reelsEmptyHint;

  /// Reels feed first-load error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load reels'**
  String get reelsError;

  /// Retry loading reels
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get reelRetry;

  /// Badge on a reel whose video is still processing
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get reelProcessing;

  /// Reel like failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the like.'**
  String get reelLikeFailed;

  /// Reel save failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update saved.'**
  String get reelSaveFailed;

  /// Surface-only share acknowledgement
  ///
  /// In en, this message translates to:
  /// **'Sharing is coming soon.'**
  String get reelShareAck;

  /// Surface-only follow acknowledgement
  ///
  /// In en, this message translates to:
  /// **'You\'ll be able to follow soon.'**
  String get reelFollowAck;

  /// Report a reel action
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reelReport;

  /// Reel report acknowledgement toast
  ///
  /// In en, this message translates to:
  /// **'Thanks — we\'ll review this reel.'**
  String get reelReported;

  /// Delete own reel action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get reelDelete;

  /// Delete-reel confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete this reel?'**
  String get reelDeleteConfirm;

  /// Reel delete success toast
  ///
  /// In en, this message translates to:
  /// **'Reel deleted.'**
  String get reelDeleted;

  /// Reel delete failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the reel.'**
  String get reelDeleteFailed;

  /// Create-reel screen title
  ///
  /// In en, this message translates to:
  /// **'New reel'**
  String get reelComposeTitle;

  /// Create-reel pick prompt
  ///
  /// In en, this message translates to:
  /// **'Pick a video'**
  String get reelComposePick;

  /// Create-reel caption field hint
  ///
  /// In en, this message translates to:
  /// **'Write a caption…'**
  String get reelComposeCaptionHint;

  /// Publish reel button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get reelComposePublish;

  /// Reel upload in progress
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get reelComposeUploading;

  /// Cancel reel upload
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reelComposeCancel;

  /// Video exceeds max duration
  ///
  /// In en, this message translates to:
  /// **'Videos must be 90 seconds or shorter.'**
  String get reelComposeTooLong;

  /// Video exceeds max size
  ///
  /// In en, this message translates to:
  /// **'Video is too large (max 150 MB).'**
  String get reelComposeTooLarge;

  /// Discard-compose confirmation
  ///
  /// In en, this message translates to:
  /// **'Discard this reel?'**
  String get reelComposeDiscard;

  /// Reel publish failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t publish your reel.'**
  String get reelPublishFailed;

  /// Create menu: new post
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get createPostLabel;

  /// Create menu: new reel
  ///
  /// In en, this message translates to:
  /// **'New reel'**
  String get createReelLabel;

  /// Create menu: new story
  ///
  /// In en, this message translates to:
  /// **'New story'**
  String get createStoryLabel;

  /// Follow account label (read-only in search, #009)
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// Already-following label
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Pending follow request label (private account)
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// Search results: blended tab
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get searchTabTop;

  /// Search results: accounts tab
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get searchTabAccounts;

  /// Search results: hashtags tab
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get searchTabTags;

  /// Search results: places tab
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get searchTabPlaces;

  /// Top view: switch to a single-type tab
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get searchSeeMore;

  /// Empty search results for a term
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// Search first-load error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search'**
  String get searchError;

  /// Retry a failed discovery load
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get discoveryRetry;

  /// Recent searches section title
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentTitle;

  /// Clear all recent searches
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get recentClearAll;

  /// Remove one recent search (a11y)
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get recentRemove;

  /// Empty recents state
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get recentsEmpty;

  /// Empty explore grid
  ///
  /// In en, this message translates to:
  /// **'Nothing to explore yet'**
  String get exploreEmpty;

  /// Empty explore subtitle
  ///
  /// In en, this message translates to:
  /// **'Posts and reels to discover will show up here.'**
  String get exploreEmptyHint;

  /// Explore first-load error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load Explore'**
  String get exploreError;

  /// Explore offline-from-cache indication
  ///
  /// In en, this message translates to:
  /// **'Offline — showing saved content'**
  String get discoveryOffline;

  /// Suffix for a hashtag/place post count
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get postsLabel;

  /// Surface-only follow button on a hashtag page
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get hashtagFollow;

  /// Surface-only follow-hashtag acknowledgement
  ///
  /// In en, this message translates to:
  /// **'Following topics is coming soon.'**
  String get hashtagFollowAck;

  /// A11y label marking a grid tile as a reel
  ///
  /// In en, this message translates to:
  /// **'Reel'**
  String get reelTileLabel;

  /// A11y label marking a grid tile as a photo
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoTileLabel;

  /// Follow control — not following
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profileFollow;

  /// Follow control — following
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowing;

  /// Follow control — pending request
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get profileRequested;

  /// Indicator that the account follows the viewer
  ///
  /// In en, this message translates to:
  /// **'Follows you'**
  String get profileFollowsYou;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;

  /// No description provided for @profileShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get profileShareProfile;

  /// No description provided for @profileShareAck.
  ///
  /// In en, this message translates to:
  /// **'Profile link copied.'**
  String get profileShareAck;

  /// No description provided for @profileMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get profileMessage;

  /// No description provided for @profileMessageAck.
  ///
  /// In en, this message translates to:
  /// **'Messaging is coming soon.'**
  String get profileMessageAck;

  /// No description provided for @profileReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get profileReport;

  /// No description provided for @profileBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get profileBlock;

  /// No description provided for @profileReportAck.
  ///
  /// In en, this message translates to:
  /// **'Thanks — we\'ll review this account.'**
  String get profileReportAck;

  /// No description provided for @profileBlockAck.
  ///
  /// In en, this message translates to:
  /// **'Blocking is coming soon.'**
  String get profileBlockAck;

  /// No description provided for @statPosts.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get statPosts;

  /// No description provided for @statFollowers.
  ///
  /// In en, this message translates to:
  /// **'followers'**
  String get statFollowers;

  /// No description provided for @statFollowing.
  ///
  /// In en, this message translates to:
  /// **'following'**
  String get statFollowing;

  /// No description provided for @profileTabPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profileTabPosts;

  /// No description provided for @profileTabTagged.
  ///
  /// In en, this message translates to:
  /// **'Tagged'**
  String get profileTabTagged;

  /// No description provided for @profilePrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'This account is private'**
  String get profilePrivateTitle;

  /// No description provided for @profilePrivateBody.
  ///
  /// In en, this message translates to:
  /// **'Follow this account to see their photos and reels.'**
  String get profilePrivateBody;

  /// No description provided for @profilePrivateListNotice.
  ///
  /// In en, this message translates to:
  /// **'This account is private.'**
  String get profilePrivateListNotice;

  /// No description provided for @profileEmptyPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get profileEmptyPosts;

  /// No description provided for @profileEmptyTagged.
  ///
  /// In en, this message translates to:
  /// **'No tagged posts yet'**
  String get profileEmptyTagged;

  /// No description provided for @profileEmptyFollowers.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get profileEmptyFollowers;

  /// No description provided for @profileEmptyFollowing.
  ///
  /// In en, this message translates to:
  /// **'Not following anyone yet'**
  String get profileEmptyFollowing;

  /// No description provided for @profileError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this profile'**
  String get profileError;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t available.'**
  String get profileNotFound;

  /// No description provided for @followFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update follow. Try again.'**
  String get followFailed;

  /// No description provided for @followListFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followListFollowers;

  /// No description provided for @followListFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followListFollowing;

  /// No description provided for @followListSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get followListSearchHint;

  /// No description provided for @followListEmptySearch.
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get followListEmptySearch;

  /// No description provided for @unfollowConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Unfollow?'**
  String get unfollowConfirmTitle;

  /// No description provided for @unfollowConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Unfollow @{username}?'**
  String unfollowConfirmBody(String username);

  /// No description provided for @unfollowConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollowConfirmAction;

  /// No description provided for @withdrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw request?'**
  String get withdrawConfirmTitle;

  /// No description provided for @withdrawConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Withdraw your follow request to @{username}?'**
  String withdrawConfirmBody(String username);

  /// No description provided for @withdrawConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdrawConfirmAction;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editName;

  /// No description provided for @editUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editUsername;

  /// No description provided for @editPronouns.
  ///
  /// In en, this message translates to:
  /// **'Pronouns'**
  String get editPronouns;

  /// No description provided for @editWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get editWebsite;

  /// No description provided for @editBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editBio;

  /// No description provided for @editChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get editChangePhoto;

  /// No description provided for @editSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editSave;

  /// No description provided for @editSavedAck.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get editSavedAck;

  /// No description provided for @editSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Try again.'**
  String get editSaveFailed;

  /// No description provided for @editNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty.'**
  String get editNameRequired;

  /// No description provided for @editWebsiteInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid website.'**
  String get editWebsiteInvalid;

  /// No description provided for @editUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'That username is taken.'**
  String get editUsernameTaken;

  /// No description provided for @editDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get editDiscardTitle;

  /// No description provided for @editDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved changes will be lost.'**
  String get editDiscardBody;

  /// No description provided for @editDiscardAction.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get editDiscardAction;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedAllSaved.
  ///
  /// In en, this message translates to:
  /// **'All saved'**
  String get savedAllSaved;

  /// No description provided for @profileTabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileTabSaved;

  /// No description provided for @collectionSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 saved} =1{1 saved} other{{count} saved}}'**
  String collectionSavedCount(int count);

  /// No description provided for @collectionNew.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get collectionNew;

  /// No description provided for @saveToCollection.
  ///
  /// In en, this message translates to:
  /// **'Save to collection'**
  String get saveToCollection;

  /// No description provided for @saveToCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to collection'**
  String get saveToCollectionTitle;

  /// No description provided for @collectionCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get collectionCreateTitle;

  /// No description provided for @collectionRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename collection'**
  String get collectionRenameTitle;

  /// No description provided for @collectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Collection name'**
  String get collectionNameHint;

  /// No description provided for @collectionNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty.'**
  String get collectionNameEmpty;

  /// No description provided for @collectionNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long.'**
  String get collectionNameTooLong;

  /// No description provided for @collectionCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get collectionCreateAction;

  /// No description provided for @collectionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get collectionRename;

  /// No description provided for @collectionSetCover.
  ///
  /// In en, this message translates to:
  /// **'Set cover'**
  String get collectionSetCover;

  /// No description provided for @collectionRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove from collection'**
  String get collectionRemoveItem;

  /// No description provided for @collectionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete collection'**
  String get collectionDelete;

  /// No description provided for @collectionDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete collection?'**
  String get collectionDeleteTitle;

  /// No description provided for @collectionDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be deleted. Your saved posts stay in All saved.'**
  String collectionDeleteBody(String name);

  /// No description provided for @collectionDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get collectionDeleteAction;

  /// No description provided for @unsaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved?'**
  String get unsaveConfirmTitle;

  /// No description provided for @unsaveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This will also remove it from 1 collection.} other{This will also remove it from {count} collections.}}'**
  String unsaveConfirmBody(int count);

  /// No description provided for @unsaveConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get unsaveConfirmAction;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save posts and reels to find them here.'**
  String get savedEmptyBody;

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posts in this collection yet'**
  String get collectionEmpty;

  /// No description provided for @savedError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved collections'**
  String get savedError;

  /// No description provided for @collectionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this collection'**
  String get collectionError;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get saveFailed;

  /// No description provided for @collectionCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the collection. Try again.'**
  String get collectionCreateFailed;

  /// No description provided for @collectionUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the collection. Try again.'**
  String get collectionUpdateFailed;

  /// No description provided for @collectionDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the collection. Try again.'**
  String get collectionDeleteFailed;

  /// No description provided for @dmTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get dmTitle;

  /// No description provided for @dmNewMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get dmNewMessage;

  /// No description provided for @dmActiveNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get dmActiveNow;

  /// No description provided for @dmTyping.
  ///
  /// In en, this message translates to:
  /// **'typing…'**
  String get dmTyping;

  /// No description provided for @dmMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message…'**
  String get dmMessageHint;

  /// No description provided for @dmTo.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get dmTo;

  /// No description provided for @dmSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get dmSuggested;

  /// No description provided for @dmSearchConversations.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get dmSearchConversations;

  /// No description provided for @dmSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get dmSending;

  /// No description provided for @dmSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get dmSent;

  /// No description provided for @dmDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get dmDelivered;

  /// No description provided for @dmSeen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get dmSeen;

  /// No description provided for @dmFailed.
  ///
  /// In en, this message translates to:
  /// **'Not delivered'**
  String get dmFailed;

  /// No description provided for @dmRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dmRetry;

  /// No description provided for @dmPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get dmPhoto;

  /// No description provided for @dmSticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get dmSticker;

  /// No description provided for @dmSharedPost.
  ///
  /// In en, this message translates to:
  /// **'Shared a post'**
  String get dmSharedPost;

  /// No description provided for @dmSharedUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This content is unavailable'**
  String get dmSharedUnavailable;

  /// No description provided for @dmEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get dmEmptyTitle;

  /// No description provided for @dmEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation from someone\'s profile or tap + to send a new message.'**
  String get dmEmptyBody;

  /// No description provided for @dmThreadEmpty.
  ///
  /// In en, this message translates to:
  /// **'Say hi 👋'**
  String get dmThreadEmpty;

  /// No description provided for @dmSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No people found'**
  String get dmSearchEmpty;

  /// No description provided for @dmError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your messages'**
  String get dmError;

  /// No description provided for @dmThreadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this conversation'**
  String get dmThreadError;

  /// No description provided for @dmOffline.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get dmOffline;

  /// No description provided for @dmSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send. Tap to retry.'**
  String get dmSendFailed;

  /// No description provided for @dmBlocked.
  ///
  /// In en, this message translates to:
  /// **'You can\'t message this account.'**
  String get dmBlocked;

  /// Activity (Notifications) screen title, #013
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activitySectionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get activitySectionNew;

  /// No description provided for @activitySectionThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get activitySectionThisWeek;

  /// No description provided for @activitySectionEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get activitySectionEarlier;

  /// No description provided for @activityEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get activityEmptyTitle;

  /// No description provided for @activityEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When people like, comment on, or follow you, you\'ll see it here.'**
  String get activityEmptyBody;

  /// No description provided for @activityError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your activity'**
  String get activityError;

  /// No description provided for @activityRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get activityRetry;

  /// No description provided for @notifActionLike.
  ///
  /// In en, this message translates to:
  /// **'liked your post'**
  String get notifActionLike;

  /// No description provided for @notifActionComment.
  ///
  /// In en, this message translates to:
  /// **'commented on your post'**
  String get notifActionComment;

  /// No description provided for @notifActionReply.
  ///
  /// In en, this message translates to:
  /// **'replied to your comment'**
  String get notifActionReply;

  /// No description provided for @notifActionMention.
  ///
  /// In en, this message translates to:
  /// **'mentioned you in a comment'**
  String get notifActionMention;

  /// No description provided for @notifActionFollow.
  ///
  /// In en, this message translates to:
  /// **'started following you'**
  String get notifActionFollow;

  /// No description provided for @notifActionFollowRequest.
  ///
  /// In en, this message translates to:
  /// **'requested to follow you'**
  String get notifActionFollowRequest;

  /// No description provided for @notifActionFollowAccepted.
  ///
  /// In en, this message translates to:
  /// **'accepted your follow request'**
  String get notifActionFollowAccepted;

  /// No description provided for @notifActionGeneric.
  ///
  /// In en, this message translates to:
  /// **'sent you a notification'**
  String get notifActionGeneric;

  /// No description provided for @notifAndOthers.
  ///
  /// In en, this message translates to:
  /// **'and {count} others'**
  String notifAndOthers(String count);

  /// No description provided for @notifTargetUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This content is unavailable'**
  String get notifTargetUnavailable;

  /// No description provided for @notifFollowBack.
  ///
  /// In en, this message translates to:
  /// **'Follow back'**
  String get notifFollowBack;

  /// No description provided for @pushPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get pushPromptTitle;

  /// No description provided for @pushPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Get notified when people like, comment on, or follow you.'**
  String get pushPromptBody;

  /// No description provided for @pushPromptAllow.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get pushPromptAllow;

  /// No description provided for @pushPromptDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get pushPromptDismiss;

  /// No description provided for @pushEnableAffordance.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get pushEnableAffordance;

  /// #014 Settings hub title (Screen 30)
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get settingsPrivacySecurity;

  /// No description provided for @settingsFollowRequests.
  ///
  /// In en, this message translates to:
  /// **'Follow requests'**
  String get settingsFollowRequests;

  /// No description provided for @settingsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get settingsBlocked;

  /// No description provided for @settingsCloseFriends.
  ///
  /// In en, this message translates to:
  /// **'Close friends'**
  String get settingsCloseFriends;

  /// No description provided for @settingsNotificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get settingsNotificationPrefs;

  /// No description provided for @settingsTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get settingsTwoFactor;

  /// No description provided for @settingsDataExport.
  ///
  /// In en, this message translates to:
  /// **'Download your data'**
  String get settingsDataExport;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// About: app version + build
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String settingsAboutVersion(String version, String build);

  /// No description provided for @settingsLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogOut;

  /// No description provided for @settingsLogOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get settingsLogOutConfirmTitle;

  /// No description provided for @settingsLogOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to use We36.'**
  String get settingsLogOutConfirmBody;

  /// No description provided for @settingsLogOutConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogOutConfirmAction;

  /// No description provided for @settingsPrivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Private account'**
  String get settingsPrivateAccount;

  /// No description provided for @settingsPrivateAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'When your account is private, only people you approve can see your posts and stories.'**
  String get settingsPrivateAccountDesc;

  /// No description provided for @settingsActivityStatus.
  ///
  /// In en, this message translates to:
  /// **'Show activity status'**
  String get settingsActivityStatus;

  /// No description provided for @settingsActivityStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Let people you follow and message see when you\'re active. When this is off, you won\'t see their activity status either.'**
  String get settingsActivityStatusDesc;

  /// No description provided for @settingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update your settings. Try again.'**
  String get settingsUpdateFailed;

  /// No description provided for @followRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow requests'**
  String get followRequestsTitle;

  /// No description provided for @followRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get followRequestsEmpty;

  /// No description provided for @followRequestsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When someone asks to follow your private account, they\'ll show up here.'**
  String get followRequestsEmptyBody;

  /// No description provided for @followRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your follow requests'**
  String get followRequestsError;

  /// No description provided for @followRequestApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get followRequestApprove;

  /// No description provided for @followRequestDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get followRequestDecline;

  /// No description provided for @followRequestActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete that. Try again.'**
  String get followRequestActionFailed;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportTitle;

  /// No description provided for @reportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonNudity.
  ///
  /// In en, this message translates to:
  /// **'Nudity or sexual content'**
  String get reportReasonNudity;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonHate.
  ///
  /// In en, this message translates to:
  /// **'Hate speech'**
  String get reportReasonHate;

  /// No description provided for @reportReasonViolence.
  ///
  /// In en, this message translates to:
  /// **'Violence'**
  String get reportReasonViolence;

  /// No description provided for @reportReasonSelfHarm.
  ///
  /// In en, this message translates to:
  /// **'Self-harm'**
  String get reportReasonSelfHarm;

  /// No description provided for @reportReasonFalseInfo.
  ///
  /// In en, this message translates to:
  /// **'False information'**
  String get reportReasonFalseInfo;

  /// No description provided for @reportReasonIp.
  ///
  /// In en, this message translates to:
  /// **'Intellectual-property violation'**
  String get reportReasonIp;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reportReasonOther;

  /// No description provided for @reportAck.
  ///
  /// In en, this message translates to:
  /// **'Thanks — we\'ll review this.'**
  String get reportAck;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send your report. Try again.'**
  String get reportFailed;

  /// No description provided for @blockAction.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get blockAction;

  /// No description provided for @blockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Block @{name}?'**
  String blockConfirmTitle(String name);

  /// No description provided for @blockConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to find your profile, posts or story, and you won\'t see theirs. They won\'t be notified.'**
  String get blockConfirmBody;

  /// No description provided for @blockAck.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blockAck;

  /// No description provided for @unblockAction.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblockAction;

  /// No description provided for @unblockFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t unblock. Try again.'**
  String get unblockFailed;

  /// No description provided for @blockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get blockedTitle;

  /// No description provided for @blockedEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t blocked anyone'**
  String get blockedEmpty;

  /// No description provided for @blockedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Accounts you block will appear here.'**
  String get blockedEmptyBody;

  /// No description provided for @blockedError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load blocked accounts'**
  String get blockedError;

  /// No description provided for @closeFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share stories with only these people. They\'re never notified that they\'re on your list.'**
  String get closeFriendsSubtitle;

  /// No description provided for @closeFriendsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No close friends yet'**
  String get closeFriendsEmpty;

  /// No description provided for @closeFriendsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add people to share Close Friends stories with them.'**
  String get closeFriendsEmptyBody;

  /// No description provided for @closeFriendsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your close friends'**
  String get closeFriendsError;

  /// No description provided for @closeFriendsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get closeFriendsAdd;

  /// No description provided for @closeFriendsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get closeFriendsRemove;

  /// No description provided for @closeFriendsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add close friends'**
  String get closeFriendsAddTitle;

  /// No description provided for @closeFriendsPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one to add right now'**
  String get closeFriendsPickerEmpty;

  /// No description provided for @closeFriendsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update close friends. Try again.'**
  String get closeFriendsUpdateFailed;

  /// No description provided for @settingsSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsSystemDefault;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsLanguageVietnamese;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @twoFactorEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security. Two-factor authentication asks for a code when you log in on a new device. Setup is coming soon.'**
  String get twoFactorEntryBody;

  /// No description provided for @dataExportEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Request a copy of your We36 data — your posts, profile info, and activity. This can take a little while and is coming soon.'**
  String get dataExportEntryBody;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;
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
