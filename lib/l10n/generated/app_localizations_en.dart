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

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get requested => 'Requested';

  @override
  String get searchTabTop => 'Top';

  @override
  String get searchTabAccounts => 'Accounts';

  @override
  String get searchTabTags => 'Tags';

  @override
  String get searchTabPlaces => 'Places';

  @override
  String get searchSeeMore => 'See more';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchError => 'Couldn\'t search';

  @override
  String get discoveryRetry => 'Retry';

  @override
  String get recentTitle => 'Recent';

  @override
  String get recentClearAll => 'Clear all';

  @override
  String get recentRemove => 'Remove';

  @override
  String get recentsEmpty => 'No recent searches';

  @override
  String get exploreEmpty => 'Nothing to explore yet';

  @override
  String get exploreEmptyHint =>
      'Posts and reels to discover will show up here.';

  @override
  String get exploreError => 'Couldn\'t load Explore';

  @override
  String get discoveryOffline => 'Offline — showing saved content';

  @override
  String get postsLabel => 'posts';

  @override
  String get hashtagFollow => 'Follow';

  @override
  String get hashtagFollowAck => 'Following topics is coming soon.';

  @override
  String get reelTileLabel => 'Reel';

  @override
  String get photoTileLabel => 'Photo';

  @override
  String get profileFollow => 'Follow';

  @override
  String get profileFollowing => 'Following';

  @override
  String get profileRequested => 'Requested';

  @override
  String get profileFollowsYou => 'Follows you';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileShareProfile => 'Share profile';

  @override
  String get profileShareAck => 'Profile link copied.';

  @override
  String get profileMessage => 'Message';

  @override
  String get profileMessageAck => 'Messaging is coming soon.';

  @override
  String get profileReport => 'Report';

  @override
  String get profileBlock => 'Block';

  @override
  String get profileReportAck => 'Thanks — we\'ll review this account.';

  @override
  String get profileBlockAck => 'Blocking is coming soon.';

  @override
  String get statPosts => 'posts';

  @override
  String get statFollowers => 'followers';

  @override
  String get statFollowing => 'following';

  @override
  String get profileTabPosts => 'Posts';

  @override
  String get profileTabTagged => 'Tagged';

  @override
  String get profilePrivateTitle => 'This account is private';

  @override
  String get profilePrivateBody =>
      'Follow this account to see their photos and reels.';

  @override
  String get profilePrivateListNotice => 'This account is private.';

  @override
  String get profileEmptyPosts => 'No posts yet';

  @override
  String get profileEmptyTagged => 'No tagged posts yet';

  @override
  String get profileEmptyFollowers => 'No followers yet';

  @override
  String get profileEmptyFollowing => 'Not following anyone yet';

  @override
  String get profileError => 'Couldn\'t load this profile';

  @override
  String get profileNotFound => 'This account isn\'t available.';

  @override
  String get followFailed => 'Couldn\'t update follow. Try again.';

  @override
  String get followListFollowers => 'Followers';

  @override
  String get followListFollowing => 'Following';

  @override
  String get followListSearchHint => 'Search';

  @override
  String get followListEmptySearch => 'No accounts found';

  @override
  String get unfollowConfirmTitle => 'Unfollow?';

  @override
  String unfollowConfirmBody(String username) {
    return 'Unfollow @$username?';
  }

  @override
  String get unfollowConfirmAction => 'Unfollow';

  @override
  String get withdrawConfirmTitle => 'Withdraw request?';

  @override
  String withdrawConfirmBody(String username) {
    return 'Withdraw your follow request to @$username?';
  }

  @override
  String get withdrawConfirmAction => 'Withdraw';

  @override
  String get editName => 'Name';

  @override
  String get editUsername => 'Username';

  @override
  String get editPronouns => 'Pronouns';

  @override
  String get editWebsite => 'Website';

  @override
  String get editBio => 'Bio';

  @override
  String get editChangePhoto => 'Change profile photo';

  @override
  String get editSave => 'Save';

  @override
  String get editSavedAck => 'Profile updated.';

  @override
  String get editSaveFailed => 'Couldn\'t save your profile. Try again.';

  @override
  String get editNameRequired => 'Name can\'t be empty.';

  @override
  String get editWebsiteInvalid => 'Enter a valid website.';

  @override
  String get editUsernameTaken => 'That username is taken.';

  @override
  String get editDiscardTitle => 'Discard changes?';

  @override
  String get editDiscardBody => 'Your unsaved changes will be lost.';

  @override
  String get editDiscardAction => 'Discard';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedAllSaved => 'All saved';

  @override
  String get profileTabSaved => 'Saved';

  @override
  String collectionSavedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved',
      one: '1 saved',
      zero: '0 saved',
    );
    return '$_temp0';
  }

  @override
  String get collectionNew => 'New collection';

  @override
  String get saveToCollection => 'Save to collection';

  @override
  String get saveToCollectionTitle => 'Save to collection';

  @override
  String get collectionCreateTitle => 'New collection';

  @override
  String get collectionRenameTitle => 'Rename collection';

  @override
  String get collectionNameHint => 'Collection name';

  @override
  String get collectionNameEmpty => 'Name can\'t be empty.';

  @override
  String get collectionNameTooLong => 'Name is too long.';

  @override
  String get collectionCreateAction => 'Create';

  @override
  String get collectionRename => 'Rename';

  @override
  String get collectionSetCover => 'Set cover';

  @override
  String get collectionRemoveItem => 'Remove from collection';

  @override
  String get collectionDelete => 'Delete collection';

  @override
  String get collectionDeleteTitle => 'Delete collection?';

  @override
  String collectionDeleteBody(String name) {
    return '\"$name\" will be deleted. Your saved posts stay in All saved.';
  }

  @override
  String get collectionDeleteAction => 'Delete';

  @override
  String get unsaveConfirmTitle => 'Remove from Saved?';

  @override
  String unsaveConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This will also remove it from $count collections.',
      one: 'This will also remove it from 1 collection.',
    );
    return '$_temp0';
  }

  @override
  String get unsaveConfirmAction => 'Remove';

  @override
  String get savedEmptyTitle => 'Nothing saved yet';

  @override
  String get savedEmptyBody => 'Save posts and reels to find them here.';

  @override
  String get collectionEmpty => 'No posts in this collection yet';

  @override
  String get savedError => 'Couldn\'t load your saved collections';

  @override
  String get collectionError => 'Couldn\'t load this collection';

  @override
  String get saveFailed => 'Couldn\'t save. Try again.';

  @override
  String get collectionCreateFailed =>
      'Couldn\'t create the collection. Try again.';

  @override
  String get collectionUpdateFailed =>
      'Couldn\'t update the collection. Try again.';

  @override
  String get collectionDeleteFailed =>
      'Couldn\'t delete the collection. Try again.';

  @override
  String get dmTitle => 'Messages';

  @override
  String get dmNewMessage => 'New message';

  @override
  String get dmActiveNow => 'Active now';

  @override
  String get dmTyping => 'typing…';

  @override
  String get dmMessageHint => 'Message…';

  @override
  String get dmTo => 'To:';

  @override
  String get dmSuggested => 'Suggested';

  @override
  String get dmSearchConversations => 'Search';

  @override
  String get dmSending => 'Sending';

  @override
  String get dmSent => 'Sent';

  @override
  String get dmDelivered => 'Delivered';

  @override
  String get dmSeen => 'Seen';

  @override
  String get dmFailed => 'Not delivered';

  @override
  String get dmRetry => 'Retry';

  @override
  String get dmPhoto => 'Photo';

  @override
  String get dmSticker => 'Sticker';

  @override
  String get dmSharedPost => 'Shared a post';

  @override
  String get dmSharedUnavailable => 'This content is unavailable';

  @override
  String get dmEmptyTitle => 'No messages yet';

  @override
  String get dmEmptyBody =>
      'Start a conversation from someone\'s profile or tap + to send a new message.';

  @override
  String get dmThreadEmpty => 'Say hi 👋';

  @override
  String get dmSearchEmpty => 'No people found';

  @override
  String get dmError => 'Couldn\'t load your messages';

  @override
  String get dmThreadError => 'Couldn\'t load this conversation';

  @override
  String get dmOffline => 'Connecting…';

  @override
  String get dmSendFailed => 'Couldn\'t send. Tap to retry.';

  @override
  String get dmBlocked => 'You can\'t message this account.';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activitySectionNew => 'New';

  @override
  String get activitySectionThisWeek => 'This week';

  @override
  String get activitySectionEarlier => 'Earlier';

  @override
  String get activityEmptyTitle => 'No activity yet';

  @override
  String get activityEmptyBody =>
      'When people like, comment on, or follow you, you\'ll see it here.';

  @override
  String get activityError => 'Couldn\'t load your activity';

  @override
  String get activityRetry => 'Try again';

  @override
  String get notifActionLike => 'liked your post';

  @override
  String get notifActionComment => 'commented on your post';

  @override
  String get notifActionReply => 'replied to your comment';

  @override
  String get notifActionMention => 'mentioned you in a comment';

  @override
  String get notifActionFollow => 'started following you';

  @override
  String get notifActionFollowRequest => 'requested to follow you';

  @override
  String get notifActionFollowAccepted => 'accepted your follow request';

  @override
  String get notifActionGeneric => 'sent you a notification';

  @override
  String notifAndOthers(String count) {
    return 'and $count others';
  }

  @override
  String get notifTargetUnavailable => 'This content is unavailable';

  @override
  String get notifFollowBack => 'Follow back';

  @override
  String get pushPromptTitle => 'Turn on notifications';

  @override
  String get pushPromptBody =>
      'Get notified when people like, comment on, or follow you.';

  @override
  String get pushPromptAllow => 'Turn on';

  @override
  String get pushPromptDismiss => 'Not now';

  @override
  String get pushEnableAffordance => 'Turn on notifications';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsEditProfile => 'Edit profile';

  @override
  String get settingsPrivacySecurity => 'Privacy & security';

  @override
  String get settingsFollowRequests => 'Follow requests';

  @override
  String get settingsBlocked => 'Blocked accounts';

  @override
  String get settingsCloseFriends => 'Close friends';

  @override
  String get settingsNotificationPrefs => 'Notification preferences';

  @override
  String get settingsTwoFactor => 'Two-factor authentication';

  @override
  String get settingsDataExport => 'Download your data';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String settingsAboutVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get settingsLogOut => 'Log out';

  @override
  String get settingsLogOutConfirmTitle => 'Log out?';

  @override
  String get settingsLogOutConfirmBody =>
      'You\'ll need to sign in again to use We36.';

  @override
  String get settingsLogOutConfirmAction => 'Log out';

  @override
  String get settingsPrivateAccount => 'Private account';

  @override
  String get settingsPrivateAccountDesc =>
      'When your account is private, only people you approve can see your posts and stories.';

  @override
  String get settingsActivityStatus => 'Show activity status';

  @override
  String get settingsActivityStatusDesc =>
      'Let people you follow and message see when you\'re active. When this is off, you won\'t see their activity status either.';

  @override
  String get settingsUpdateFailed =>
      'Couldn\'t update your settings. Try again.';

  @override
  String get followRequestsTitle => 'Follow requests';

  @override
  String get followRequestsEmpty => 'No pending requests';

  @override
  String get followRequestsEmptyBody =>
      'When someone asks to follow your private account, they\'ll show up here.';

  @override
  String get followRequestsError => 'Couldn\'t load your follow requests';

  @override
  String get followRequestApprove => 'Approve';

  @override
  String get followRequestDecline => 'Decline';

  @override
  String get followRequestActionFailed => 'Couldn\'t complete that. Try again.';

  @override
  String get reportTitle => 'Report';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonNudity => 'Nudity or sexual content';

  @override
  String get reportReasonHarassment => 'Harassment or bullying';

  @override
  String get reportReasonHate => 'Hate speech';

  @override
  String get reportReasonViolence => 'Violence';

  @override
  String get reportReasonSelfHarm => 'Self-harm';

  @override
  String get reportReasonFalseInfo => 'False information';

  @override
  String get reportReasonIp => 'Intellectual-property violation';

  @override
  String get reportReasonOther => 'Something else';

  @override
  String get reportAck => 'Thanks — we\'ll review this.';

  @override
  String get reportFailed => 'Couldn\'t send your report. Try again.';

  @override
  String get blockAction => 'Block';

  @override
  String blockConfirmTitle(String name) {
    return 'Block @$name?';
  }

  @override
  String get blockConfirmBody =>
      'They won\'t be able to find your profile, posts or story, and you won\'t see theirs. They won\'t be notified.';

  @override
  String get blockAck => 'Blocked';

  @override
  String get unblockAction => 'Unblock';

  @override
  String get unblockFailed => 'Couldn\'t unblock. Try again.';

  @override
  String get blockedTitle => 'Blocked accounts';

  @override
  String get blockedEmpty => 'You haven\'t blocked anyone';

  @override
  String get blockedEmptyBody => 'Accounts you block will appear here.';

  @override
  String get blockedError => 'Couldn\'t load blocked accounts';

  @override
  String get closeFriendsSubtitle =>
      'Share stories with only these people. They\'re never notified that they\'re on your list.';

  @override
  String get closeFriendsEmpty => 'No close friends yet';

  @override
  String get closeFriendsEmptyBody =>
      'Add people to share Close Friends stories with them.';

  @override
  String get closeFriendsError => 'Couldn\'t load your close friends';

  @override
  String get closeFriendsAdd => 'Add';

  @override
  String get closeFriendsRemove => 'Remove';

  @override
  String get closeFriendsAddTitle => 'Add close friends';

  @override
  String get closeFriendsPickerEmpty => 'No one to add right now';

  @override
  String get closeFriendsUpdateFailed =>
      'Couldn\'t update close friends. Try again.';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get twoFactorEntryBody =>
      'Add an extra layer of security. Two-factor authentication asks for a code when you log in on a new device. Setup is coming soon.';

  @override
  String get dataExportEntryBody =>
      'Request a copy of your We36 data — your posts, profile info, and activity. This can take a little while and is coming soon.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get notifPrefLikes => 'Likes';

  @override
  String get notifPrefComments => 'Comments';

  @override
  String get notifPrefMentions => 'Mentions';

  @override
  String get notifPrefFollows => 'New followers';

  @override
  String get notifPrefFollowRequests => 'Follow requests';

  @override
  String get notifPrefDirectMessages => 'Direct messages';

  @override
  String get notifPrefPauseAll => 'Pause all';

  @override
  String get notifPrefPauseAllDesc =>
      'Temporarily stop all push notifications.';
}
