// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'IshHub';

  @override
  String get navFeed => 'Feed';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileActivateWorker => 'Open worker profile';

  @override
  String get profileWorkerActive => 'Worker profile active';

  @override
  String get profileTrustTitle => 'Trust profile';

  @override
  String profileTrustScore(String score) {
    return 'Trust $score';
  }

  @override
  String profileTrustRatings(int count) {
    return '$count ratings';
  }

  @override
  String profileTrustCompleted(int count) {
    return '$count completed';
  }

  @override
  String get profileTrustUnavailable =>
      'Trust score will appear after your first jobs.';

  @override
  String get profileWorkerSkillsTitle => 'Skills clients can match';

  @override
  String get profileWorkerNoSkills => 'No skills selected yet';

  @override
  String get profileWorkerSkillsUnavailable => 'Could not load skills';

  @override
  String get profileStreetModeTitle => 'Street Mode';

  @override
  String get profileStreetModeSubtitle => 'Let nearby clients find you';

  @override
  String get profileAvailabilityOnTitle => 'Available now';

  @override
  String get profileAvailabilityOffTitle => 'Availability is off';

  @override
  String profileAvailabilityNoLocation(String radius) {
    return 'Radius $radius km · location not set';
  }

  @override
  String profileAvailabilitySummary(String radius) {
    return 'Radius $radius km · saved location ready';
  }

  @override
  String get profilePreferencesTitle => 'Settings';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSubtitle => 'Choose the app appearance';

  @override
  String get themeDialogTitle => 'Choose appearance';

  @override
  String get themeDialogSubtitle => 'IshHub adapts to your eyes and your day.';

  @override
  String get themeSystemTitle => 'System';

  @override
  String get themeSystemDescription => 'Follows your phone setting';

  @override
  String get themeLightTitle => 'Light';

  @override
  String get themeLightDescription => 'Bright, clear daytime interface';

  @override
  String get themeDarkTitle => 'Dark';

  @override
  String get themeDarkDescription => 'Soft dark mode for evening work';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose the app language';

  @override
  String get languageDialogTitle => 'Choose language';

  @override
  String get languageDialogSubtitle => 'The interface updates immediately.';

  @override
  String get languageUzbekTitle => 'O\'zbekcha';

  @override
  String get languageUzbekDescription =>
      'Primary language for the local market';

  @override
  String get languageRussianTitle => 'Русский';

  @override
  String get languageRussianDescription => 'Use IshHub in Russian';

  @override
  String get languageEnglishTitle => 'English';

  @override
  String get languageEnglishDescription => 'Use IshHub in English';

  @override
  String get selectedOption => 'Selected';

  @override
  String get profileSetupTitle => 'Profile setup';

  @override
  String get profileSetupHeadline => 'Make your IshHub identity usable';

  @override
  String get profileSetupSubtitle =>
      'Clients and workers see this before they decide to work with you.';

  @override
  String get profileSetupNameLabel => 'Full name';

  @override
  String get profileSetupNameRequired => 'Enter at least 2 characters';

  @override
  String get profileSetupCityLabel => 'City';

  @override
  String get profileSetupDistrictLabel => 'District or neighborhood';

  @override
  String get profileSetupLocationTitle => 'Location for better matching';

  @override
  String get profileSetupLocationSubtitle =>
      'Use GPS now or continue with city and district only.';

  @override
  String get profileSetupLocationReady => 'Location saved for nearby ranking.';

  @override
  String get profileSetupUseLocation => 'Use GPS';

  @override
  String get profileSetupAvatarLaterTitle => 'Photo comes next';

  @override
  String get profileSetupAvatarLaterSubtitle =>
      'For now, your initials are shown everywhere. Avatar upload will attach here.';

  @override
  String get profileSetupContinue => 'Continue';

  @override
  String get commonNetworkError => 'Network error';

  @override
  String get commonNetworkErrorRetry => 'Network error. Please try again.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get asyncEmpty => 'Nothing here yet';

  @override
  String get asyncRetry => 'Try again';

  @override
  String get authPhoneRequired => 'Enter your phone number';

  @override
  String get authWelcomeTitle => 'Welcome to IshHub';

  @override
  String get authWelcomeSubtitle => 'Enter your phone number to sign in';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authPhoneHint => '+998901234567';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authCodeRequired => 'Enter the full code';

  @override
  String get authOtpHint => '• • • • • •';

  @override
  String get authCodeResent => 'Code sent again';

  @override
  String get authOtpTitle => 'Verification code';

  @override
  String authOtpSentTo(String phone) {
    return 'Sent to $phone';
  }

  @override
  String get authVerify => 'Verify';

  @override
  String get authResendCode => 'Resend code';

  @override
  String get rolePickerDescription =>
      'This lets you find jobs and send offers.';

  @override
  String get rolePickerClientTitle => 'I need workers';

  @override
  String get rolePickerClientSubtitle =>
      'Post jobs, compare offers, and manage work';

  @override
  String get rolePickerWorkerTitle => 'I work as a worker';

  @override
  String get rolePickerWorkerSubtitle => 'Open a worker profile to find jobs';

  @override
  String get workerSetupTitle => 'Worker setup';

  @override
  String get workerSetupHeadline => 'Build the profile that wins work';

  @override
  String get workerSetupSubtitle =>
      'Choose real skills, add a short bio, and set a rate so matching and clients can trust the offer.';

  @override
  String get workerSetupSkillSearchLabel => 'Search skills';

  @override
  String get workerSetupSkillsRequired => 'Choose at least one skill';

  @override
  String get workerSetupBioLabel => 'Bio';

  @override
  String get workerSetupBioHint =>
      'for example: I repair plumbing, doors, and small electrical issues. I can come with my own tools.';

  @override
  String get workerSetupRateLabel => 'Default rate (UZS)';

  @override
  String get workerSetupRateUnitLabel => 'Unit';

  @override
  String get workerSetupStreetModeTitle => 'Street Mode after setup';

  @override
  String get workerSetupStreetModeSubtitle =>
      'Once the profile is active, you can turn on live availability nearby.';

  @override
  String get workerSetupAvailabilityTitle => 'Where can clients find you?';

  @override
  String get workerSetupAvailabilitySubtitle =>
      'Save a location for nearby ranking. You can still activate without GPS.';

  @override
  String get workerSetupLocationReady =>
      'Location ready. Your feed can rank nearby jobs.';

  @override
  String get workerSetupUseLocation => 'Use current location';

  @override
  String workerSetupRadius(String radius) {
    return 'Service radius: $radius km';
  }

  @override
  String get workerSetupAvailableNowTitle => 'Turn on Street Mode after setup';

  @override
  String get workerSetupAvailableNowSubtitle =>
      'Nearby clients can find you immediately.';

  @override
  String get workerSetupAvailableNowNeedsLocation =>
      'Choose a location before turning this on.';

  @override
  String get workerSetupFinish => 'Open worker profile';

  @override
  String get feedMapTooltip => 'Map';

  @override
  String get feedListTooltip => 'List';

  @override
  String get feedFiltersTooltip => 'Filters';

  @override
  String get feedFiltersTitle => 'Filters';

  @override
  String feedSearchRadius(String radius) {
    return 'Search radius: $radius km';
  }

  @override
  String get feedKeywordLabel => 'Keyword';

  @override
  String get feedKeywordHint => 'for example: plumber';

  @override
  String get feedApplyFilters => 'Apply';

  @override
  String get feedDistanceFallback => 'Showing recent jobs';

  @override
  String feedSkillMatch(int count) {
    return '$count skill match';
  }

  @override
  String feedMatchScore(int percent) {
    return '$percent% match';
  }

  @override
  String get feedOpenToOffer => 'Open details to send an offer';

  @override
  String get feedStreetModePromptTitle =>
      'Turn on Street Mode for nearby ranking';

  @override
  String get feedStreetModePromptSubtitle =>
      'Until then, Feed shows recent open jobs without claiming distance.';

  @override
  String get feedEmpty => 'No matching jobs yet.\nTry changing the filters.';

  @override
  String get feedActivateWorkerTitle => 'Open a worker profile to find jobs';

  @override
  String get feedBecomeWorker => 'Become a worker';

  @override
  String get findWorkersTitle => 'Find workers';

  @override
  String get findWorkersUnnamedWorker => 'Worker';

  @override
  String get findWorkersHeader => 'Workers near you now';

  @override
  String findWorkersHeaderSubtitle(String radius) {
    return 'Within $radius km · Street Mode only';
  }

  @override
  String get findWorkersUseCurrentLocation => 'Use current location';

  @override
  String get findWorkersLocationTitle => 'Find nearby workers';

  @override
  String get findWorkersLocationSubtitle =>
      'Use your current location to see available workers around you.';

  @override
  String get findWorkersEmpty =>
      'No available workers nearby yet.\nTry a wider radius or different skill.';

  @override
  String get findWorkersClosestNow => 'Closest now';

  @override
  String findWorkersCount(int count) {
    return '$count workers';
  }

  @override
  String findWorkersDistance(String distance) {
    return '$distance km away';
  }

  @override
  String findWorkersRate(String amount, String unit) {
    return '$amount UZS · $unit';
  }

  @override
  String findWorkersTrust(String score) {
    return 'Trust $score';
  }

  @override
  String get findWorkersNewBadge => 'New';

  @override
  String get findWorkersFreshNow => 'Updated now';

  @override
  String get findWorkersFreshRecent => 'Updated recently';

  @override
  String get findWorkersFreshStale => 'May still be nearby';

  @override
  String get findWorkersFreshUnknown => 'Availability on';

  @override
  String get contactWorkerAction => 'Contact worker';

  @override
  String contactWorkerTitle(String worker) {
    return 'Contact $worker';
  }

  @override
  String contactWorkerDefaultMessage(String worker) {
    return 'Hi $worker, I found you nearby. Can we discuss a job?';
  }

  @override
  String get contactWorkerMessageLabel => 'First message';

  @override
  String get contactWorkerSend => 'Start chat';

  @override
  String get contactWorkerSending => 'Opening chat...';

  @override
  String get contactWorkerUnavailable =>
      'This worker is no longer available. The list was refreshed.';

  @override
  String get contactWorkerLocationRequired =>
      'Choose a search location before contacting a worker.';

  @override
  String get contactWorkerMessageRequired => 'Write a short first message.';

  @override
  String get findWorkersPostJobAction => 'Post a job for this worker';

  @override
  String get findWorkersFiltersTitle => 'Worker filters';

  @override
  String get findWorkersSearchLabel => 'Skill or keyword';

  @override
  String get findWorkersSearchHint => 'for example: cleaner';

  @override
  String get jobsMineTitle => 'My jobs';

  @override
  String get jobsHubTitle => 'Work hub';

  @override
  String get jobsTabActiveWork => 'Active work';

  @override
  String get jobsTabPostedByMe => 'Posted by me';

  @override
  String get jobsTabHistory => 'History';

  @override
  String get jobsActiveEmpty =>
      'No active assigned jobs yet.\nWhen a client accepts you or you accept an instant job, it appears here.';

  @override
  String get jobsPostedEmpty =>
      'You have not posted any jobs yet.\nPost a new job.';

  @override
  String get jobsHistoryEmpty =>
      'Completed and cancelled assigned jobs will appear here.';

  @override
  String get jobsOpenJob => 'Open job';

  @override
  String feedActiveWorkTitle(int count) {
    return 'Active assigned jobs: $count';
  }

  @override
  String get feedActiveWorkSubtitle =>
      'Open Jobs to continue your assigned work.';

  @override
  String jobsError(String error) {
    return 'Error: $error';
  }

  @override
  String get jobsEmpty => 'You do not have any jobs yet.\nPost a new job.';

  @override
  String get jobsNew => 'New job';

  @override
  String get chatTitle => 'Chats';

  @override
  String get jobUntitled => '(untitled)';

  @override
  String get urgencyUrgent => 'Urgent';

  @override
  String get urgencyToday => 'Today';

  @override
  String get urgencyFlexible => 'Flexible';

  @override
  String get pricingFixed => 'Fixed';

  @override
  String get pricingHourly => 'Hourly';

  @override
  String get pricingNegotiable => 'Negotiable';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusPosted => 'Posted';

  @override
  String get statusMatching => 'Matching';

  @override
  String get statusAssigned => 'Assigned';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusDisputed => 'Disputed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusDeclined => 'Declined';

  @override
  String get statusWithdrawn => 'Withdrawn';

  @override
  String get statusCountered => 'Countered';

  @override
  String get statusArrived => 'Arrived';

  @override
  String get statusStarted => 'Started';

  @override
  String get statusDone => 'Done';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get categoryCleaning => 'Cleaning';

  @override
  String get categoryConstruction => 'Construction';

  @override
  String get categoryRepair => 'Repair';

  @override
  String get categoryDelivery => 'Delivery';

  @override
  String get categoryFarming => 'Farming';

  @override
  String get categoryGardening => 'Gardening';

  @override
  String get categoryPainting => 'Painting';

  @override
  String get categoryCooking => 'Cooking';

  @override
  String get categoryTeaching => 'Teaching';

  @override
  String get categoryDesign => 'Design';

  @override
  String get categoryLoading => 'Loading';

  @override
  String get categoryOther => 'Other';

  @override
  String get timeNow => 'now';

  @override
  String timeMinutesAgo(int count) {
    return '$count min';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count hr';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count d';
  }

  @override
  String timeWeeksAgo(int count) {
    return '$count wk';
  }

  @override
  String get createJobTitle => 'New job';

  @override
  String get createJobIntro => 'Describe it and AI will fill in the details';

  @override
  String get createJobBodyLabel => 'About the job';

  @override
  String get createJobBodyHint =>
      'for example: The bathroom faucet is leaking, come tomorrow';

  @override
  String get createJobAddressLabel => 'Address (optional)';

  @override
  String createJobPhotosCount(int count) {
    return 'Photos ($count/6)';
  }

  @override
  String get createJobAnalyze => 'Analyze with AI';

  @override
  String get createJobLocationFailed => 'Could not get location';

  @override
  String get createJobMaxPhotos => 'Maximum 6 photos';

  @override
  String get createJobUploadFailed => 'Could not upload';

  @override
  String get createJobInputRequired => 'Enter text or add at least 1 photo';

  @override
  String get createJobLocationRequired => 'Choose a location';

  @override
  String get createJobLocationSelect => 'Choose a location';

  @override
  String get createJobLocationSelected => 'Location selected';

  @override
  String get draftReviewTitle => 'Review';

  @override
  String get draftPublished => 'Job published';

  @override
  String get draftAiFailed => 'AI analysis did not finish';

  @override
  String get draftTitleLabel => 'Title';

  @override
  String get draftTitleRequired => 'Title is required';

  @override
  String get draftDescriptionLabel => 'Description';

  @override
  String get draftCategoryLabel => 'Category';

  @override
  String get draftUrgencyLabel => 'Timing';

  @override
  String get draftPricingLabel => 'Pricing type';

  @override
  String get draftHourlyRateLabel => 'Hourly rate (UZS)';

  @override
  String get draftEstimatedBudgetLabel => 'Estimated budget (optional)';

  @override
  String get draftBudgetLabel => 'Budget (UZS)';

  @override
  String get draftNegotiableBudgetHelp =>
      'Estimated amount for negotiating with workers';

  @override
  String get draftWorkersNeededLabel => 'Workers needed';

  @override
  String get draftPhotosLabel => 'Photos';

  @override
  String get draftPublish => 'Publish';

  @override
  String get draftProcessingTitle => 'AI is analyzing your job...';

  @override
  String get draftProcessingSubtitle => 'This usually takes 5-10 seconds.';

  @override
  String draftConfidence(int percent) {
    return 'AI confidence: $percent%';
  }

  @override
  String galleryTitle(int index, int total) {
    return '$index / $total';
  }

  @override
  String get offerAmountRequired => 'Enter a price';

  @override
  String get offerHoursInvalid => 'Enter valid hours';

  @override
  String get offerSent => 'Offer sent';

  @override
  String get offerSendFailed => 'Could not send';

  @override
  String get offerComposeTitle => 'Send offer';

  @override
  String offerJobRecap(String title, String price) {
    return 'For $title · $price';
  }

  @override
  String get offerPricingTypeLabel => 'Pricing type';

  @override
  String get offerHourlyRateLabel => 'Hourly rate (UZS)';

  @override
  String get offerTotalAmountLabel => 'Total amount (UZS)';

  @override
  String get offerEstimatedHoursLabel => 'Estimated hours (optional)';

  @override
  String get offerNoteLabel => 'Note (optional)';

  @override
  String get offerNoteHint => 'for example: I can come today at 14:00';

  @override
  String get offerQuickToday => 'Can come today';

  @override
  String get offerQuickTools => 'Tools included';

  @override
  String get offerSubmit => 'Send';

  @override
  String get jobDetailTitle => 'Job details';

  @override
  String get jobDetailPrice => 'Price';

  @override
  String get jobDetailNegotiablePrice => 'Price is negotiable';

  @override
  String get jobDetailAddress => 'Address';

  @override
  String get jobDetailDate => 'Date';

  @override
  String get jobDetailWorkersNeeded => 'Workers needed';

  @override
  String get jobDetailIncomingOffers => 'Incoming offers';

  @override
  String get jobDetailMyOffers => 'My offers';

  @override
  String get jobDetailOffersError => 'Could not load offers';

  @override
  String get jobDetailNoOffers => 'No offers yet';

  @override
  String get jobDetailActionFailed => 'Action failed';

  @override
  String get jobCancelAction => 'Cancel job';

  @override
  String get jobCancelConfirmTitle => 'Cancel this job?';

  @override
  String get jobCancelPostedBody =>
      'This job has no assigned worker yet. It will be cancelled and removed from the feed.';

  @override
  String get jobCancelAssignedBody =>
      'A worker is already assigned. They will be notified, and this job will not return to the feed.';

  @override
  String get jobCancelReasonLabel => 'Reason (optional)';

  @override
  String get jobCancelKeepAction => 'Keep job';

  @override
  String get jobCancelConfirmAction => 'Cancel job';

  @override
  String get jobCancelSuccess => 'Job cancelled';

  @override
  String offerDurationEstimate(String hours) {
    return 'Estimate: $hours hours';
  }

  @override
  String get offerPerHourSuffix => '/hr';

  @override
  String get offerDecline => 'Decline';

  @override
  String get offerAccept => 'Accept';

  @override
  String get offerWithdraw => 'Withdraw';

  @override
  String get offerOpenChat => 'Open chat';

  @override
  String get offerApplicantUnnamed => 'Worker';

  @override
  String get offerTrustNew => 'New';

  @override
  String offerTrustScore(String score) {
    return 'Trust $score';
  }

  @override
  String offerTrustRatings(int count) {
    return '$count ratings';
  }

  @override
  String offerTrustCompleted(int count) {
    return '$count done';
  }

  @override
  String get offerAvailableNow => 'Available now';

  @override
  String get offerAcceptedAssignmentReady =>
      'Offer accepted. The job is now assigned.';

  @override
  String get assignmentMine => 'My assignment';

  @override
  String get assignmentArrivedAction => 'I arrived';

  @override
  String get assignmentStartedAction => 'Started work';

  @override
  String get assignmentDoneAction => 'Done';

  @override
  String get assignmentConfirmAction => 'Confirm';

  @override
  String get assignmentCancelAction => 'Cancel assignment';

  @override
  String get assignmentCancelConfirmTitle => 'Cancel this assignment?';

  @override
  String get assignmentCancelConfirmBody =>
      'The client will be notified and this job will leave your active work.';

  @override
  String get assignmentCancelKeepAction => 'Keep assignment';

  @override
  String get assignmentCancelConfirmAction => 'Cancel assignment';

  @override
  String get assignmentCancelSuccess => 'Assignment cancelled';

  @override
  String get assignmentCancelClientRecoveryTitle => 'Worker cancelled';

  @override
  String get assignmentCancelClientRecoveryBody =>
      'Your job is open again. You can wait for new offers or look for another nearby worker.';

  @override
  String get assignmentCancelFindWorkerAction => 'Find another worker';

  @override
  String get assignmentArrivedStamp => 'Arrived';

  @override
  String get assignmentStartedStamp => 'Started';

  @override
  String get assignmentDoneStamp => 'Done';

  @override
  String get assignmentConfirmedStamp => 'Confirmed';

  @override
  String assignmentStamp(String label, String date) {
    return '$label: $date';
  }

  @override
  String get chatEmpty =>
      'No chats yet.\nChats will appear here after you send an offer.';

  @override
  String get chatSendFailed => 'Could not send';

  @override
  String get chatMessageHint => 'Write a message... (@yordam - AI assistant)';

  @override
  String get chatVoiceMessage => 'Voice message';

  @override
  String get chatAiName => 'Yordam AI';

  @override
  String get chatStartHint =>
      'Start the chat. Type @yordam to get AI help negotiating price or timing.';

  @override
  String get chatAgreementAction => 'Create agreement';

  @override
  String get chatAgreementCreateTitle => 'Create agreement';

  @override
  String get chatAgreementSubtitle =>
      'Set the price and scope before work starts.';

  @override
  String get chatAgreementCardTitle => 'Work agreement';

  @override
  String get chatAgreementPrivacy =>
      'Phone stays hidden until an agreement is accepted.';

  @override
  String get chatAgreementAlreadyAssigned =>
      'Agreement accepted. Continue from Jobs.';

  @override
  String get chatAgreementDescriptionLabel => 'Scope of work';

  @override
  String get chatAgreementDescriptionHint => 'What exactly should be done?';

  @override
  String get chatAgreementDescriptionRequired => 'Describe the work';

  @override
  String get chatAgreementNoteHint => 'for example: Cash after completion';

  @override
  String get chatAgreementSent => 'Agreement sent';

  @override
  String get chatAgreementSendFailed => 'Could not send agreement';

  @override
  String get chatAgreementAccepted =>
      'Agreement accepted. The job is now assigned.';

  @override
  String get chatAgreementDeclined => 'Agreement declined';

  @override
  String get chatCounterAction => 'Counter';

  @override
  String get chatCounterCreateTitle => 'Counter offer';

  @override
  String get chatCounterSubtitle => 'Send updated terms back into this chat.';

  @override
  String get chatCounterNoteHint =>
      'for example: I can do it today for this price';

  @override
  String get chatCounterSent => 'Counter offer sent';

  @override
  String get chatCounterSendFailed => 'Could not send counter offer';

  @override
  String get chatCallAction => 'Call';

  @override
  String get chatContactUnlocked => 'Call is unlocked for this accepted job.';

  @override
  String get chatContactUnavailable => 'Contact is not available yet.';

  @override
  String get chatCallFailed => 'Could not open the phone dialer.';

  @override
  String get chatQuickLocation => 'Location';

  @override
  String get chatQuickPrice => 'Price';

  @override
  String get chatQuickYordam => '@yordam';

  @override
  String get chatQuickLocationMessage => 'I can share the exact location here.';

  @override
  String get chatQuickPriceMessage =>
      'Can we agree on the price before starting?';

  @override
  String get chatQuickYordamMessage =>
      '@yordam suggest fair terms for this job';

  @override
  String get safetyMenuTooltip => 'Safety actions';

  @override
  String get safetyBlockAction => 'Block';

  @override
  String get safetyUnblockAction => 'Unblock';

  @override
  String get safetyReportAction => 'Report';

  @override
  String safetyBlockTitle(String name) {
    return 'Block $name?';
  }

  @override
  String get safetyBlockConfirm =>
      'They will not be able to message or contact you again. Existing chat stays visible for your records.';

  @override
  String safetyBlocked(String name) {
    return 'Blocked $name';
  }

  @override
  String safetyUnblocked(String name) {
    return 'Unblocked $name';
  }

  @override
  String safetyBlockedComposer(String name) {
    return 'You blocked $name. Messaging is disabled.';
  }

  @override
  String safetyBlockedByThemComposer(String name) {
    return '$name blocked you. You can still read this chat, but messaging is disabled.';
  }

  @override
  String safetyMutualBlockedComposer(String name) {
    return 'You and $name blocked each other. This chat stays readable, but messaging is disabled.';
  }

  @override
  String safetyReportTitle(String name) {
    return 'Report $name';
  }

  @override
  String get safetyReportSubtitle =>
      'Reports help IshHub review unsafe, spammy, or off-platform behavior.';

  @override
  String get safetyReportReasonLabel => 'Reason';

  @override
  String get safetyReportDetailsLabel => 'Details';

  @override
  String get safetyReportSubmit => 'Send report';

  @override
  String get safetyReportSent => 'Report sent';

  @override
  String get safetyReportReasonAbuse => 'Abusive behavior';

  @override
  String get safetyReportReasonSpam => 'Spam';

  @override
  String get safetyReportReasonFraud => 'Fraud or scam';

  @override
  String get safetyReportReasonOffPlatform => 'Pressure to go off-platform';

  @override
  String get safetyReportReasonSafety => 'Safety concern';

  @override
  String get safetyReportReasonOther => 'Other';

  @override
  String get streetModeTitle => 'Street Mode';

  @override
  String get streetPermissionDenied => 'Location permission was denied';

  @override
  String get streetPermissionSettings => 'Allow location access in settings';

  @override
  String get streetServiceDisabled => 'Location service is disabled';

  @override
  String get streetLocationRequired => 'Choose a location first';

  @override
  String get streetEnabled => 'Street Mode is on';

  @override
  String get streetDisabled => 'Mode is off';

  @override
  String get streetGetLocation => 'Use current location';

  @override
  String streetSearchRadius(String radius) {
    return 'Search radius: $radius km';
  }

  @override
  String get streetTurnOff => 'Turn mode off';

  @override
  String get streetTurnOn => 'Turn Street Mode on';

  @override
  String get streetActiveStatus => 'Clients nearby can find you now';

  @override
  String get streetInactiveStatus => 'Mode is off';

  @override
  String get streetNoSavedLocation => 'No saved location yet';

  @override
  String streetSavedLocation(String radius) {
    return 'Saved radius: $radius km';
  }

  @override
  String streetLastUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get streetActivateWorkerNeeded =>
      'Open a worker profile to use this feature';

  @override
  String get streetActivateWorker => 'Open';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationFallbackTitle => 'Notification';

  @override
  String get closeoutUploadFailed => 'Could not upload evidence';

  @override
  String get closeoutMissingContext => 'Open this from the job details screen.';

  @override
  String get paymentRecordTitle => 'Record payment';

  @override
  String paymentAmountLabel(String currency) {
    return 'Amount ($currency)';
  }

  @override
  String get paymentAmountRequired => 'Enter a valid amount';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodCardTransfer => 'Transfer';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get paymentNoteLabel => 'Note (optional)';

  @override
  String get paymentAddReceipt => 'Add receipt photo';

  @override
  String get paymentChangeReceipt => 'Change receipt photo';

  @override
  String get paymentRecordAction => 'I paid';

  @override
  String paymentRecordFootnote(String amount, String currency) {
    return 'You are recording $amount $currency. Money is paid directly between client and worker.';
  }

  @override
  String get paymentRecorded => 'Payment recorded';

  @override
  String get paymentConfirmAction => 'Confirm received';

  @override
  String get paymentDisputeAction => 'Dispute payment';

  @override
  String get paymentDisputeTitle => 'Dispute payment';

  @override
  String get paymentDisputeReasonLabel => 'What happened?';

  @override
  String get paymentDisputeSubmit => 'Submit dispute';

  @override
  String get paymentStatusRecorded => 'Waiting for worker confirmation';

  @override
  String get paymentStatusConfirmed => 'Payment confirmed';

  @override
  String get paymentStatusDisputed => 'Payment disputed';

  @override
  String get ratingTitle => 'Rate experience';

  @override
  String get ratingSubmitted => 'Rating submitted';

  @override
  String ratingStars(int count) {
    return '$count stars';
  }

  @override
  String get ratingTagsLabel => 'Quick tags';

  @override
  String get ratingCommentLabel => 'Review (optional)';

  @override
  String get ratingSubmitAction => 'Rate';

  @override
  String get ratingTagClearInstructions => 'Clear instructions';

  @override
  String get ratingTagRespectful => 'Respectful';

  @override
  String get ratingTagPaidOnTime => 'Paid on time';

  @override
  String get ratingTagPunctual => 'Punctual';

  @override
  String get ratingTagSkilled => 'Skilled';

  @override
  String get ratingTagFriendly => 'Friendly';

  @override
  String get ratingTagWouldHireAgain => 'Would hire again';

  @override
  String get disputeOpenTitle => 'Open dispute';

  @override
  String get disputeOpenAction => 'Report issue';

  @override
  String get disputeEvidenceLimit => 'Maximum 6 evidence photos';

  @override
  String get disputeMissingCounterparty => 'Could not find the other party';

  @override
  String get disputeOpened => 'Dispute opened';

  @override
  String get disputeReasonLabel => 'Reason';

  @override
  String get disputeDescriptionLabel => 'Details';

  @override
  String get disputeDescriptionRequired => 'Add at least 10 characters';

  @override
  String get disputeEvidenceLabel => 'Evidence';

  @override
  String get disputeSubmitAction => 'Open dispute';

  @override
  String get disputeReasonNotPaid => 'Not paid';

  @override
  String get disputeReasonUnderpaid => 'Underpaid';

  @override
  String get disputeReasonWorkNotDone => 'Work not done';

  @override
  String get disputeReasonPoorQuality => 'Poor quality';

  @override
  String get disputeReasonNoShow => 'No-show';

  @override
  String get disputeReasonDamagedProperty => 'Damaged property';

  @override
  String get disputeReasonAbusiveBehavior => 'Abusive behavior';

  @override
  String get disputeReasonOther => 'Other';

  @override
  String get disputeDetailTitle => 'Dispute';

  @override
  String disputeOpenedAt(String date) {
    return 'Opened $date';
  }

  @override
  String get disputeAiBriefTitle => 'AI brief';

  @override
  String get disputeAiBriefPending => 'The AI brief is being prepared.';

  @override
  String get disputeResolutionTitle => 'Resolution';

  @override
  String get disputeBannerTitle => 'Dispute open on this job';

  @override
  String get disputeStatusOpen => 'Open';

  @override
  String get disputeStatusAiTriaged => 'AI brief ready';

  @override
  String get disputeStatusUnderReview => 'Under review';

  @override
  String get disputeStatusResolved => 'Resolved';

  @override
  String get disputeStatusCancelled => 'Cancelled';

  @override
  String get disputeOutcomePending => 'Pending';

  @override
  String get disputeOutcomeForOpener => 'For opener';

  @override
  String get disputeOutcomeAgainstRespondent => 'Against respondent';

  @override
  String get disputeOutcomeSplit => 'Split';

  @override
  String get disputeOutcomeDismissed => 'Dismissed';
}
