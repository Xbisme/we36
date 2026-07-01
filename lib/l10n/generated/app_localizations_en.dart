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

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignInSubtitle => 'Sign in to continue';

  @override
  String get authSignInCta => 'Log in';

  @override
  String get authForgotPasswordLink => 'Forgot password?';

  @override
  String get authOrDivider => 'or';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authNoAccountQuestion => 'Don\'t have an account?';

  @override
  String get authCreateAccountLink => 'Create account';

  @override
  String get authSignOut => 'Log out';

  @override
  String get authEmailInvalid => 'Enter a valid email.';

  @override
  String get authPasswordTooShort => 'Password must be at least 8 characters.';

  @override
  String get authSignUpTitle => 'Create your account';

  @override
  String get authSignUpCta => 'Sign up';

  @override
  String get authSignUpTerms =>
      'By signing up you agree to our Terms and Privacy Policy.';

  @override
  String get authHaveAccountQuestion => 'Already have an account?';

  @override
  String get authLogInLink => 'Log in';

  @override
  String get authProfileSetupTitle => 'Set up your profile';

  @override
  String get authProfileSetupSubtitle =>
      'Choose a username and how your name appears.';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authUsernameHint => 'username';

  @override
  String get authDisplayNameLabel => 'Display name';

  @override
  String get authDisplayNameHint => 'Your name';

  @override
  String get authBioLabel => 'Bio (optional)';

  @override
  String get authBioHint => 'Tell people about yourself';

  @override
  String get authContinueCta => 'Continue';

  @override
  String get authUsernameChecking => 'Checking…';

  @override
  String get authUsernameAvailable => 'Available';

  @override
  String get authUsernameTaken => 'That username is taken.';

  @override
  String get authUsernameInvalid =>
      '3–30 chars: lowercase letters, numbers, . or _';

  @override
  String get authForgotTitle => 'Reset password';

  @override
  String get authForgotSubtitle =>
      'Enter your email and we\'ll send you a code.';

  @override
  String get authSendCodeCta => 'Send code';

  @override
  String get authCodeTitle => 'Enter the code';

  @override
  String authCodeSubtitle(String email) {
    return 'Enter the 6-digit code we sent to $email.';
  }

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authResetCta => 'Reset password';

  @override
  String get authResendCode => 'Resend code';

  @override
  String authResendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get authResetDone => 'Password reset. Please sign in.';

  @override
  String authDevCode(String code) {
    return 'Dev code: $code';
  }

  @override
  String get onboardSkip => 'Skip';

  @override
  String get onboardGetStarted => 'Get started';

  @override
  String get onboardTitle1 => 'Capture every moment';

  @override
  String get onboardBody1 =>
      'Share photos and videos with the people who matter.';

  @override
  String get onboardTitle2 => 'Reels, stories & feed';

  @override
  String get onboardBody2 => 'Discover and create in one playful place.';

  @override
  String get onboardTitle3 => 'Keep up with friends';

  @override
  String get onboardBody3 => 'Message, react, and stay close.';

  @override
  String get feedEmptyTitle => 'No posts yet';

  @override
  String get feedEmptyBody => 'Follow people to see their posts here.';

  @override
  String get feedErrorTitle => 'Couldn\'t load your feed';

  @override
  String get feedRetry => 'Try again';

  @override
  String feedLikesCount(String count) {
    return '$count likes';
  }

  @override
  String get feedLikeFailed => 'Couldn\'t update your like. Try again.';

  @override
  String get feedSaveFailed => 'Couldn\'t save this post. Try again.';

  @override
  String get feedActivity => 'Activity';

  @override
  String get feedMessages => 'Messages';

  @override
  String feedViewAllComments(String count) {
    return 'View all $count comments';
  }

  @override
  String get storySendMessage => 'Send message';

  @override
  String get storyLikeFailed => 'Couldn\'t like this story.';

  @override
  String get storyUnavailable => 'This story is no longer available.';

  @override
  String get storyClose => 'Close';

  @override
  String get storyComingSoon => 'Coming soon';
}
