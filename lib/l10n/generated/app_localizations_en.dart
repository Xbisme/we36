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

  @override
  String get composeTitle => 'New post';

  @override
  String get composeNext => 'Next';

  @override
  String get composeShare => 'Share';

  @override
  String get composeRecents => 'Recents';

  @override
  String get composeCarousel => 'Carousel';

  @override
  String get composeCaptionHint => 'Write a caption…';

  @override
  String get composeTagPeople => 'Tag people';

  @override
  String get composeAddLocation => 'Add location';

  @override
  String get composeTurnOffComments => 'Turn off commenting';

  @override
  String get composeFilterOriginal => 'Original';

  @override
  String get composeFilterWarm => 'Warm';

  @override
  String get composeFilterLux => 'Lux';

  @override
  String get composeFilterMono => 'Mono';

  @override
  String get composeFilterFade => 'Fade';

  @override
  String get composeAdjustBrightness => 'Brightness';

  @override
  String get composeAdjustContrast => 'Contrast';

  @override
  String get composeAdjustWarmth => 'Warmth';

  @override
  String get composeUploading => 'Sharing…';

  @override
  String get composeCancel => 'Cancel';

  @override
  String get composeRetry => 'Retry';

  @override
  String get composePublished => 'Posted!';

  @override
  String get composeUploadFailed => 'Couldn\'t share your post.';

  @override
  String get composePermissionTitle => 'Allow photo access';

  @override
  String get composePermissionBody =>
      'We36 needs access to your photos to create a post.';

  @override
  String get composeOpenSettings => 'Open Settings';

  @override
  String get composeEmptyLibrary => 'No photos yet';

  @override
  String composeMaxReached(int max) {
    return 'You can add up to $max photos.';
  }

  @override
  String get composeDiscardTitle => 'Discard post?';

  @override
  String get composeDiscardKeep => 'Keep editing';

  @override
  String get composeDiscardDiscard => 'Discard';

  @override
  String get composeCrop => 'Crop';

  @override
  String get composeCropDone => 'Done';

  @override
  String get composeFilters => 'Filters';

  @override
  String get composeAdjust => 'Adjust';

  @override
  String get storyShare => 'Share';

  @override
  String get storyYourStory => 'Your story';

  @override
  String get storyCloseFriends => 'Close friends';

  @override
  String get storyAddText => 'Add text';

  @override
  String get storyStickers => 'Stickers';

  @override
  String get storyUploading => 'Sharing…';

  @override
  String get storyPublished => 'Added to your story!';

  @override
  String get storyUploadFailed => 'Couldn\'t share your story.';

  @override
  String get storyDiscardTitle => 'Discard story?';

  @override
  String get storyDiscardKeep => 'Keep editing';

  @override
  String get storyDiscardDiscard => 'Discard';

  @override
  String get postTitle => 'Post';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentAddHint => 'Add a comment…';

  @override
  String get commentPost => 'Post';

  @override
  String get commentReply => 'Reply';

  @override
  String commentViewReplies(String count) {
    return 'View $count replies';
  }

  @override
  String commentReplyingTo(String handle) {
    return 'Replying to $handle';
  }

  @override
  String get commentReplyCancel => 'Cancel reply';

  @override
  String get commentDelete => 'Delete';

  @override
  String get commentReport => 'Report';

  @override
  String get commentActionsCancel => 'Cancel';

  @override
  String get commentDeleteConfirmTitle => 'Delete comment?';

  @override
  String get commentDeleteConfirmBody =>
      'This comment and its replies will be removed.';

  @override
  String get commentDeleteConfirm => 'Delete';

  @override
  String get commentDeleteCancel => 'Cancel';

  @override
  String get commentsDisabledNotice => 'Comments are turned off';

  @override
  String get commentsEmpty => 'No comments yet';

  @override
  String get commentsEmptyHint => 'Be the first to comment.';

  @override
  String get commentsError => 'Couldn\'t load comments';

  @override
  String get commentsOffline => 'Comments unavailable offline';

  @override
  String get commentRetry => 'Retry';

  @override
  String get commentAddFailed => 'Couldn\'t post your comment.';

  @override
  String get commentLikeFailed => 'Couldn\'t update the like.';

  @override
  String get commentDeleteFailed => 'Couldn\'t delete the comment.';

  @override
  String get commentReported => 'Thanks — we\'ll review this comment.';

  @override
  String get reelsTitle => 'Reels';

  @override
  String get reelsEmpty => 'No reels yet';

  @override
  String get reelsEmptyHint => 'Reels you follow will show up here.';

  @override
  String get reelsError => 'Couldn\'t load reels';

  @override
  String get reelRetry => 'Retry';

  @override
  String get reelProcessing => 'Processing…';

  @override
  String get reelLikeFailed => 'Couldn\'t update the like.';

  @override
  String get reelSaveFailed => 'Couldn\'t update saved.';

  @override
  String get reelShareAck => 'Sharing is coming soon.';

  @override
  String get reelFollowAck => 'You\'ll be able to follow soon.';

  @override
  String get reelReport => 'Report';

  @override
  String get reelReported => 'Thanks — we\'ll review this reel.';

  @override
  String get reelDelete => 'Delete';

  @override
  String get reelDeleteConfirm => 'Delete this reel?';

  @override
  String get reelDeleted => 'Reel deleted.';

  @override
  String get reelDeleteFailed => 'Couldn\'t delete the reel.';

  @override
  String get reelComposeTitle => 'New reel';

  @override
  String get reelComposePick => 'Pick a video';

  @override
  String get reelComposeCaptionHint => 'Write a caption…';

  @override
  String get reelComposePublish => 'Share';

  @override
  String get reelComposeUploading => 'Uploading…';

  @override
  String get reelComposeCancel => 'Cancel';

  @override
  String get reelComposeTooLong => 'Videos must be 90 seconds or shorter.';

  @override
  String get reelComposeTooLarge => 'Video is too large (max 150 MB).';

  @override
  String get reelComposeDiscard => 'Discard this reel?';

  @override
  String get reelPublishFailed => 'Couldn\'t publish your reel.';

  @override
  String get createPostLabel => 'New post';

  @override
  String get createReelLabel => 'New reel';

  @override
  String get createStoryLabel => 'New story';
}
