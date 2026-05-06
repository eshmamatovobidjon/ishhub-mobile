// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'IshHub';

  @override
  String get navFeed => 'Lenta';

  @override
  String get navJobs => 'Ishlar';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profil';

  @override
  String get notificationsTooltip => 'Bildirishnomalar';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileActivateWorker => 'Ustachi profilini ochish';

  @override
  String get profileWorkerActive => 'Ustachi profili faol';

  @override
  String get profileTrustTitle => 'Ishonch profili';

  @override
  String profileTrustScore(String score) {
    return 'Ishonch $score';
  }

  @override
  String profileTrustRatings(int count) {
    return '$count ta baho';
  }

  @override
  String profileTrustCompleted(int count) {
    return '$count ta yakunlangan';
  }

  @override
  String get profileTrustUnavailable =>
      'Ishonch ko\'rsatkichi ilk ishlardan keyin ko\'rinadi.';

  @override
  String get profileWorkerSkillsTitle => 'Moslash uchun ko\'nikmalar';

  @override
  String get profileWorkerNoSkills => 'Hali ko\'nikma tanlanmagan';

  @override
  String get profileWorkerSkillsUnavailable =>
      'Ko\'nikmalarni yuklab bo\'lmadi';

  @override
  String get profileStreetModeTitle => 'Ko\'chada rejim';

  @override
  String get profileStreetModeSubtitle =>
      'Yaqin atrofdagi mijozlar sizni topa olsin';

  @override
  String get profileAvailabilityOnTitle => 'Hozir mavjud';

  @override
  String get profileAvailabilityOffTitle => 'Mavjudlik o\'chirilgan';

  @override
  String profileAvailabilityNoLocation(String radius) {
    return 'Radius $radius km · joylashuv belgilanmagan';
  }

  @override
  String profileAvailabilitySummary(String radius) {
    return 'Radius $radius km · joylashuv tayyor';
  }

  @override
  String get profilePreferencesTitle => 'Sozlamalar';

  @override
  String get profileSignOut => 'Chiqish';

  @override
  String get themeTitle => 'Mavzu';

  @override
  String get themeSubtitle => 'Ilova ko\'rinishini tanlang';

  @override
  String get themeDialogTitle => 'Ko\'rinishni tanlang';

  @override
  String get themeDialogSubtitle =>
      'IshHub ko\'zingizga va kun tartibingizga moslashadi.';

  @override
  String get themeSystemTitle => 'Tizim';

  @override
  String get themeSystemDescription => 'Telefoningiz sozlamasiga ergashadi';

  @override
  String get themeLightTitle => 'Yorug\'';

  @override
  String get themeLightDescription => 'Kunduzgi, ochiq va ravshan ko\'rinish';

  @override
  String get themeDarkTitle => 'Qorong\'i';

  @override
  String get themeDarkDescription =>
      'Tungi ishlar uchun yumshoq qorong\'i muhit';

  @override
  String get languageTitle => 'Til';

  @override
  String get languageSubtitle => 'Ilova tilini tanlang';

  @override
  String get languageDialogTitle => 'Tilni tanlang';

  @override
  String get languageDialogSubtitle =>
      'Interfeys darhol tanlangan tilda ko\'rinadi.';

  @override
  String get languageUzbekTitle => 'O\'zbekcha';

  @override
  String get languageUzbekDescription => 'Mahalliy bozor uchun asosiy til';

  @override
  String get languageRussianTitle => 'Русский';

  @override
  String get languageRussianDescription => 'Русский интерфейс приложения';

  @override
  String get languageEnglishTitle => 'English';

  @override
  String get languageEnglishDescription => 'Use IshHub in English';

  @override
  String get selectedOption => 'Tanlangan';

  @override
  String get profileSetupTitle => 'Profil sozlash';

  @override
  String get profileSetupHeadline => 'IshHub profilingizni ishga tayyorlang';

  @override
  String get profileSetupSubtitle =>
      'Mijozlar va ustachilar siz bilan ishlashdan oldin shu ma\'lumotlarni ko\'radi.';

  @override
  String get profileSetupNameLabel => 'To\'liq ism';

  @override
  String get profileSetupNameRequired => 'Kamida 2 ta belgi kiriting';

  @override
  String get profileSetupCityLabel => 'Shahar';

  @override
  String get profileSetupDistrictLabel => 'Tuman yoki mahalla';

  @override
  String get profileSetupLocationTitle => 'Yaxshiroq moslash uchun joylashuv';

  @override
  String get profileSetupLocationSubtitle =>
      'Hozir GPS ishlating yoki faqat shahar va tuman bilan davom eting.';

  @override
  String get profileSetupLocationReady =>
      'Yaqin ishlar uchun joylashuv saqlandi.';

  @override
  String get profileSetupUseLocation => 'GPS';

  @override
  String get profileSetupAvatarLaterTitle => 'Rasm keyingi bosqichda';

  @override
  String get profileSetupAvatarLaterSubtitle =>
      'Hozircha ilovada bosh harflaringiz ko\'rinadi. Rasm yuklash shu joyga ulanadi.';

  @override
  String get profileSetupContinue => 'Davom etish';

  @override
  String get commonNetworkError => 'Tarmoq xatosi';

  @override
  String get commonNetworkErrorRetry => 'Tarmoq xatosi. Qayta urinib ko\'ring.';

  @override
  String get commonCancel => 'Bekor qilish';

  @override
  String get asyncEmpty => 'Hozircha bo\'sh';

  @override
  String get asyncRetry => 'Qayta urinish';

  @override
  String get authPhoneRequired => 'Telefon raqamingizni kiriting';

  @override
  String get authWelcomeTitle => 'IshHub\'ga xush kelibsiz';

  @override
  String get authWelcomeSubtitle =>
      'Kirish uchun telefon raqamingizni kiriting';

  @override
  String get authPhoneLabel => 'Telefon';

  @override
  String get authPhoneHint => '+998901234567';

  @override
  String get authSendCode => 'Kodni yuborish';

  @override
  String get authCodeRequired => 'Kodni to\'liq kiriting';

  @override
  String get authOtpHint => '• • • • • •';

  @override
  String get authCodeResent => 'Kod qayta yuborildi';

  @override
  String get authOtpTitle => 'Tasdiqlash kodi';

  @override
  String authOtpSentTo(String phone) {
    return '$phone raqamiga yuborildi';
  }

  @override
  String get authVerify => 'Tasdiqlash';

  @override
  String get authResendCode => 'Kodni qayta yuborish';

  @override
  String get rolePickerDescription =>
      'Bu sizga ish topish va takliflar yuborish imkonini beradi.';

  @override
  String get rolePickerClientTitle => 'Menga ustachilar kerak';

  @override
  String get rolePickerClientSubtitle =>
      'Ish e\'lon qiling, takliflarni solishtiring va jarayonni boshqaring';

  @override
  String get rolePickerWorkerTitle => 'Ustachi sifatida ishlayman';

  @override
  String get rolePickerWorkerSubtitle =>
      'Ishlarni topish uchun ustachi profilini oching';

  @override
  String get workerSetupTitle => 'Ustachi sozlash';

  @override
  String get workerSetupHeadline => 'Ish yutadigan profilingizni yarating';

  @override
  String get workerSetupSubtitle =>
      'Haqiqiy ko\'nikmalarni tanlang, qisqa bio yozing va tarif kiriting. Shunda moslash va mijoz ishonchi kuchayadi.';

  @override
  String get workerSetupSkillSearchLabel => 'Ko\'nikmalarni qidirish';

  @override
  String get workerSetupSkillsRequired => 'Kamida bitta ko\'nikma tanlang';

  @override
  String get workerSetupBioLabel => 'Bio';

  @override
  String get workerSetupBioHint =>
      'masalan: Santexnika, eshik va mayda elektr ishlarini ta\'mirlayman. Asboblarim bilan kelaman.';

  @override
  String get workerSetupRateLabel => 'Asosiy tarif (UZS)';

  @override
  String get workerSetupRateUnitLabel => 'Birlik';

  @override
  String get workerSetupStreetModeTitle => 'Sozlashdan keyin Ko\'chada rejim';

  @override
  String get workerSetupStreetModeSubtitle =>
      'Profil faol bo\'lgach, yaqin atrofdagi mavjudlikni yoqishingiz mumkin.';

  @override
  String get workerSetupAvailabilityTitle => 'Mijozlar sizni qayerdan topsin?';

  @override
  String get workerSetupAvailabilitySubtitle =>
      'Yaqin ishlarni yaxshiroq tartiblash uchun joylashuvni saqlang. GPS bo\'lmasa ham profil ochiladi.';

  @override
  String get workerSetupLocationReady =>
      'Joylashuv tayyor. Lenta yaqin ishlarni tartiblay oladi.';

  @override
  String get workerSetupUseLocation => 'Hozirgi joylashuvni olish';

  @override
  String workerSetupRadius(String radius) {
    return 'Xizmat radiusi: $radius km';
  }

  @override
  String get workerSetupAvailableNowTitle =>
      'Sozlashdan keyin Ko\'chada rejimni yoqish';

  @override
  String get workerSetupAvailableNowSubtitle =>
      'Yaqin mijozlar sizni darhol topa oladi.';

  @override
  String get workerSetupAvailableNowNeedsLocation =>
      'Avval joylashuvni tanlang.';

  @override
  String get workerSetupFinish => 'Ustachi profilini ochish';

  @override
  String get feedMapTooltip => 'Xarita';

  @override
  String get feedListTooltip => 'Ro\'yxat';

  @override
  String get feedFiltersTooltip => 'Filtrlar';

  @override
  String get feedFiltersTitle => 'Filtrlar';

  @override
  String feedSearchRadius(String radius) {
    return 'Qidiruv radiusi: $radius km';
  }

  @override
  String get feedKeywordLabel => 'Kalit so\'z';

  @override
  String get feedKeywordHint => 'masalan: santexnik';

  @override
  String get feedApplyFilters => 'Qo\'llash';

  @override
  String get feedDistanceFallback => 'Yangi ishlar ko\'rsatilmoqda';

  @override
  String feedSkillMatch(int count) {
    return '$count ta ko\'nikma mos';
  }

  @override
  String feedMatchScore(int percent) {
    return '$percent% mos';
  }

  @override
  String get feedOpenToOffer => 'Taklif yuborish uchun tafsilotni oching';

  @override
  String get feedStreetModePromptTitle =>
      'Yaqin ishlar uchun Ko\'chada rejimni yoqing';

  @override
  String get feedStreetModePromptSubtitle =>
      'Ungacha Lenta masofani aniq ko\'rsatmasdan yangi ochiq ishlarni chiqaradi.';

  @override
  String get feedEmpty =>
      'Hozircha sizga mos ish topilmadi.\nFiltrlarni o\'zgartirib ko\'ring.';

  @override
  String get feedActivateWorkerTitle =>
      'Ish topish uchun ustachi profilini oching';

  @override
  String get feedBecomeWorker => 'Ustachi bo\'lish';

  @override
  String get findWorkersTitle => 'Ustachi topish';

  @override
  String get findWorkersUnnamedWorker => 'Ustachi';

  @override
  String get findWorkersHeader => 'Yaqindagi mavjud ustachilar';

  @override
  String findWorkersHeaderSubtitle(String radius) {
    return '$radius km ichida · faqat Ko\'chada rejim';
  }

  @override
  String get findWorkersUseCurrentLocation => 'Hozirgi joylashuv';

  @override
  String get findWorkersLocationTitle => 'Yaqin ustachilarni toping';

  @override
  String get findWorkersLocationSubtitle =>
      'Atrofingizdagi mavjud ustachilarni ko\'rish uchun joylashuvingizdan foydalaning.';

  @override
  String get findWorkersEmpty =>
      'Yaqin atrofda hozir mavjud ustachi topilmadi.\nRadiusni kengaytiring yoki boshqa ko\'nikma kiriting.';

  @override
  String get findWorkersClosestNow => 'Hozir eng yaqinlar';

  @override
  String findWorkersCount(int count) {
    return '$count ta ustachi';
  }

  @override
  String findWorkersDistance(String distance) {
    return '$distance km uzoqda';
  }

  @override
  String findWorkersRate(String amount, String unit) {
    return '$amount UZS · $unit';
  }

  @override
  String findWorkersTrust(String score) {
    return 'Ishonch $score';
  }

  @override
  String get findWorkersNewBadge => 'Yangi';

  @override
  String get findWorkersFreshNow => 'Hozir yangilandi';

  @override
  String get findWorkersFreshRecent => 'Yaqinda yangilandi';

  @override
  String get findWorkersFreshStale => 'Hali yaqin bo\'lishi mumkin';

  @override
  String get findWorkersFreshUnknown => 'Mavjudlik yoqilgan';

  @override
  String get contactWorkerAction => 'Ustachiga yozish';

  @override
  String contactWorkerTitle(String worker) {
    return '$worker bilan aloqa';
  }

  @override
  String contactWorkerDefaultMessage(String worker) {
    return 'Salom, $worker. Sizni yaqin atrofda topdim. Ish haqida gaplashsak bo\'ladimi?';
  }

  @override
  String get contactWorkerMessageLabel => 'Birinchi xabar';

  @override
  String get contactWorkerSend => 'Chatni boshlash';

  @override
  String get contactWorkerSending => 'Chat ochilmoqda...';

  @override
  String get contactWorkerUnavailable =>
      'Bu ustachi hozir mavjud emas. Ro\'yxat yangilandi.';

  @override
  String get contactWorkerLocationRequired =>
      'Ustachiga yozishdan oldin qidiruv joyini tanlang.';

  @override
  String get contactWorkerMessageRequired => 'Qisqa birinchi xabar yozing.';

  @override
  String get findWorkersPostJobAction => 'Shu ustachi uchun ish e\'lon qilish';

  @override
  String get findWorkersFiltersTitle => 'Ustachi filtrlari';

  @override
  String get findWorkersSearchLabel => 'Ko\'nikma yoki kalit so\'z';

  @override
  String get findWorkersSearchHint => 'masalan: farrosh';

  @override
  String get jobsMineTitle => 'Mening ishlarim';

  @override
  String get jobsHubTitle => 'Ish markazi';

  @override
  String get jobsTabActiveWork => 'Faol ishlar';

  @override
  String get jobsTabPostedByMe => 'Men e\'lon qilganlar';

  @override
  String get jobsTabHistory => 'Tarix';

  @override
  String get jobsActiveEmpty =>
      'Hozircha faol tayinlangan ishlar yo\'q.\nMijoz sizni tanlaganda yoki tez ishni qabul qilganingizda, u shu yerda ko\'rinadi.';

  @override
  String get jobsPostedEmpty =>
      'Hozircha ish e\'lon qilmagansiz.\nYangi ish e\'lon qiling.';

  @override
  String get jobsHistoryEmpty =>
      'Yakunlangan va bekor qilingan tayinlangan ishlar shu yerda ko\'rinadi.';

  @override
  String get jobsOpenJob => 'Ishni ochish';

  @override
  String feedActiveWorkTitle(int count) {
    return '$count ta faol tayinlangan ish';
  }

  @override
  String get feedActiveWorkSubtitle =>
      'Tayinlangan ishni davom ettirish uchun Ishlar bo\'limini oching.';

  @override
  String jobsError(String error) {
    return 'Xatolik: $error';
  }

  @override
  String get jobsEmpty =>
      'Hozircha ishlaringiz yo\'q.\nYangi ish e\'lon qiling.';

  @override
  String get jobsNew => 'Yangi ish';

  @override
  String get chatTitle => 'Suhbatlar';

  @override
  String get jobUntitled => '(nomsiz)';

  @override
  String get urgencyUrgent => 'Shoshilinch';

  @override
  String get urgencyToday => 'Bugun';

  @override
  String get urgencyFlexible => 'Erkin';

  @override
  String get pricingFixed => 'Belgilangan';

  @override
  String get pricingHourly => 'Soatlik';

  @override
  String get pricingNegotiable => 'Kelishiladi';

  @override
  String get statusDraft => 'Qoralama';

  @override
  String get statusOpen => 'Ochiq';

  @override
  String get statusPosted => 'E\'lon qilingan';

  @override
  String get statusMatching => 'Moslashmoqda';

  @override
  String get statusAssigned => 'Tayinlangan';

  @override
  String get statusInProgress => 'Jarayonda';

  @override
  String get statusCompleted => 'Yakunlangan';

  @override
  String get statusCancelled => 'Bekor qilingan';

  @override
  String get statusDisputed => 'Nizo ochilgan';

  @override
  String get statusPending => 'Kutilmoqda';

  @override
  String get statusAccepted => 'Qabul qilingan';

  @override
  String get statusDeclined => 'Rad etilgan';

  @override
  String get statusWithdrawn => 'Qaytarib olingan';

  @override
  String get statusCountered => 'Qarshi taklif yuborilgan';

  @override
  String get statusArrived => 'Yetib kelgan';

  @override
  String get statusStarted => 'Boshlangan';

  @override
  String get statusDone => 'Tugagan';

  @override
  String get statusConfirmed => 'Tasdiqlangan';

  @override
  String get categoryCleaning => 'Tozalash';

  @override
  String get categoryConstruction => 'Qurilish';

  @override
  String get categoryRepair => 'Ta\'mir';

  @override
  String get categoryDelivery => 'Yetkazib berish';

  @override
  String get categoryFarming => 'Dehqonchilik';

  @override
  String get categoryGardening => 'Bog\'dorchilik';

  @override
  String get categoryPainting => 'Bo\'yash';

  @override
  String get categoryCooking => 'Oshpazlik';

  @override
  String get categoryTeaching => 'O\'qitish';

  @override
  String get categoryDesign => 'Dizayn';

  @override
  String get categoryLoading => 'Yuk ortish';

  @override
  String get categoryOther => 'Boshqa';

  @override
  String get timeNow => 'hozir';

  @override
  String timeMinutesAgo(int count) {
    return '$count daq';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count soat';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count kun';
  }

  @override
  String timeWeeksAgo(int count) {
    return '$count hafta';
  }

  @override
  String get createJobTitle => 'Yangi ish';

  @override
  String get createJobIntro => 'Tasvirlab bering, AI tafsilotlarni to\'ldiradi';

  @override
  String get createJobBodyLabel => 'Ish haqida';

  @override
  String get createJobBodyHint =>
      'masalan: Vannada kran oqib turibdi, ertaga keling';

  @override
  String get createJobAddressLabel => 'Manzil (ixtiyoriy)';

  @override
  String createJobPhotosCount(int count) {
    return 'Rasmlar ($count/6)';
  }

  @override
  String get createJobAnalyze => 'AI bilan tahlil qilish';

  @override
  String get createJobLocationFailed => 'Joylashuvni olib bo\'lmadi';

  @override
  String get createJobMaxPhotos => 'Maksimum 6 ta rasm';

  @override
  String get createJobUploadFailed => 'Yuklab bo\'lmadi';

  @override
  String get createJobInputRequired => 'Matn yoki kamida 1 ta rasm kiriting';

  @override
  String get createJobLocationRequired => 'Joylashuvni belgilang';

  @override
  String get createJobLocationSelect => 'Joylashuvni belgilang';

  @override
  String get createJobLocationSelected => 'Joylashuv tanlandi';

  @override
  String get draftReviewTitle => 'Ko\'rib chiqish';

  @override
  String get draftPublished => 'Ish e\'lon qilindi';

  @override
  String get draftAiFailed => 'AI tahlili amalga oshmadi';

  @override
  String get draftTitleLabel => 'Sarlavha';

  @override
  String get draftTitleRequired => 'Sarlavha kerak';

  @override
  String get draftDescriptionLabel => 'Tavsif';

  @override
  String get draftCategoryLabel => 'Kategoriya';

  @override
  String get draftUrgencyLabel => 'Muddati';

  @override
  String get draftPricingLabel => 'Narx turi';

  @override
  String get draftHourlyRateLabel => 'Soatlik tarif (UZS)';

  @override
  String get draftEstimatedBudgetLabel => 'Taxminiy byudjet (ixtiyoriy)';

  @override
  String get draftBudgetLabel => 'Byudjet (UZS)';

  @override
  String get draftNegotiableBudgetHelp =>
      'Ishchilar bilan kelishish uchun taxminiy summa';

  @override
  String get draftWorkersNeededLabel => 'Ustachilar soni';

  @override
  String get draftPhotosLabel => 'Rasmlar';

  @override
  String get draftPublish => 'E\'lon qilish';

  @override
  String get draftProcessingTitle => 'AI ishingizni tahlil qilmoqda...';

  @override
  String get draftProcessingSubtitle => 'Bu odatda 5-10 soniya oladi.';

  @override
  String draftConfidence(int percent) {
    return 'AI ishonchi: $percent%';
  }

  @override
  String galleryTitle(int index, int total) {
    return '$index / $total';
  }

  @override
  String get offerAmountRequired => 'Narxni kiriting';

  @override
  String get offerHoursInvalid => 'To\'g\'ri soat kiriting';

  @override
  String get offerSent => 'Taklif yuborildi';

  @override
  String get offerSendFailed => 'Yuborib bo\'lmadi';

  @override
  String get offerComposeTitle => 'Taklif yuborish';

  @override
  String offerJobRecap(String title, String price) {
    return '$title uchun · $price';
  }

  @override
  String get offerPricingTypeLabel => 'Narx turi';

  @override
  String get offerHourlyRateLabel => 'Soatlik tarif (UZS)';

  @override
  String get offerTotalAmountLabel => 'Umumiy summa (UZS)';

  @override
  String get offerEstimatedHoursLabel => 'Taxminiy soat (ixtiyoriy)';

  @override
  String get offerNoteLabel => 'Izoh (ixtiyoriy)';

  @override
  String get offerNoteHint => 'masalan: Bugun soat 14:00 da kelaman';

  @override
  String get offerQuickToday => 'Bugun kela olaman';

  @override
  String get offerQuickTools => 'Asboblarim bor';

  @override
  String get offerSubmit => 'Yuborish';

  @override
  String get jobDetailTitle => 'Ish tafsiloti';

  @override
  String get jobDetailPrice => 'Narx';

  @override
  String get jobDetailNegotiablePrice => 'Narx kelishiladi';

  @override
  String get jobDetailAddress => 'Manzil';

  @override
  String get jobDetailDate => 'Sana';

  @override
  String get jobDetailWorkersNeeded => 'Ustachilar soni';

  @override
  String get jobDetailIncomingOffers => 'Kelgan takliflar';

  @override
  String get jobDetailMyOffers => 'Mening takliflarim';

  @override
  String get jobDetailOffersError => 'Takliflarni olishda xato';

  @override
  String get jobDetailNoOffers => 'Hozircha takliflar yo\'q';

  @override
  String get jobDetailActionFailed => 'Amal bajarilmadi';

  @override
  String get jobCancelAction => 'Ishni bekor qilish';

  @override
  String get jobCancelConfirmTitle => 'Bu ish bekor qilinsinmi?';

  @override
  String get jobCancelPostedBody =>
      'Bu ishga hali ustachi tayinlanmagan. Ish bekor qilinadi va lentadan olib tashlanadi.';

  @override
  String get jobCancelAssignedBody =>
      'Ustachi allaqachon tayinlangan. Unga xabar beriladi va ish lentaga qaytmaydi.';

  @override
  String get jobCancelReasonLabel => 'Sabab (ixtiyoriy)';

  @override
  String get jobCancelKeepAction => 'Ishni qoldirish';

  @override
  String get jobCancelConfirmAction => 'Ishni bekor qilish';

  @override
  String get jobCancelSuccess => 'Ish bekor qilindi';

  @override
  String offerDurationEstimate(String hours) {
    return 'Taxmin: $hours soat';
  }

  @override
  String get offerPerHourSuffix => '/soat';

  @override
  String get offerDecline => 'Rad etish';

  @override
  String get offerAccept => 'Qabul qilish';

  @override
  String get offerWithdraw => 'Qaytarib olish';

  @override
  String get offerOpenChat => 'Suhbatga o\'tish';

  @override
  String get offerApplicantUnnamed => 'Ustachi';

  @override
  String get offerTrustNew => 'Yangi';

  @override
  String offerTrustScore(String score) {
    return 'Ishonch $score';
  }

  @override
  String offerTrustRatings(int count) {
    return '$count ta baho';
  }

  @override
  String offerTrustCompleted(int count) {
    return '$count ta tugagan';
  }

  @override
  String get offerAvailableNow => 'Hozir mavjud';

  @override
  String get offerAcceptedAssignmentReady =>
      'Taklif qabul qilindi. Ish tayinlandi.';

  @override
  String get assignmentMine => 'Mening tayinlovim';

  @override
  String get assignmentArrivedAction => 'Yetib keldim';

  @override
  String get assignmentStartedAction => 'Ishni boshladim';

  @override
  String get assignmentDoneAction => 'Tugatdim';

  @override
  String get assignmentConfirmAction => 'Tasdiqlash';

  @override
  String get assignmentCancelAction => 'Tayinlovni bekor qilish';

  @override
  String get assignmentCancelConfirmTitle => 'Bu tayinlov bekor qilinsinmi?';

  @override
  String get assignmentCancelConfirmBody =>
      'Mijozga xabar beriladi va bu ish faol ishlaringizdan olib tashlanadi.';

  @override
  String get assignmentCancelKeepAction => 'Tayinlovni qoldirish';

  @override
  String get assignmentCancelConfirmAction => 'Tayinlovni bekor qilish';

  @override
  String get assignmentCancelSuccess => 'Tayinlov bekor qilindi';

  @override
  String get assignmentCancelClientRecoveryTitle => 'Ustachi bekor qildi';

  @override
  String get assignmentCancelClientRecoveryBody =>
      'Ishingiz yana ochildi. Yangi takliflarni kutishingiz yoki yaqin atrofdagi boshqa ustachini topishingiz mumkin.';

  @override
  String get assignmentCancelFindWorkerAction => 'Boshqa ustachi topish';

  @override
  String get assignmentArrivedStamp => 'Yetib keldi';

  @override
  String get assignmentStartedStamp => 'Boshladi';

  @override
  String get assignmentDoneStamp => 'Tugatdi';

  @override
  String get assignmentConfirmedStamp => 'Tasdiqlandi';

  @override
  String assignmentStamp(String label, String date) {
    return '$label: $date';
  }

  @override
  String get chatEmpty =>
      'Hozircha suhbatlar yo\'q.\nTaklif yuborgandan so\'ng suhbatlar shu yerda paydo bo\'ladi.';

  @override
  String get chatSendFailed => 'Yuborib bo\'lmadi';

  @override
  String get chatMessageHint => 'Xabar yozing... (@yordam - AI yordamchi)';

  @override
  String get chatVoiceMessage => 'Ovozli xabar';

  @override
  String get chatAiName => 'Yordam AI';

  @override
  String get chatStartHint =>
      'Suhbatni boshlang. Narx yoki vaqt haqida kelishish uchun @yordam deb yozing - AI yordam beradi.';

  @override
  String get chatAgreementAction => 'Kelishuv yaratish';

  @override
  String get chatAgreementCreateTitle => 'Kelishuv yaratish';

  @override
  String get chatAgreementSubtitle =>
      'Ish boshlanishidan oldin narx va vazifani belgilang.';

  @override
  String get chatAgreementCardTitle => 'Ish kelishuvi';

  @override
  String get chatAgreementPrivacy =>
      'Kelishuv qabul qilinmaguncha telefon yashirin qoladi.';

  @override
  String get chatAgreementAlreadyAssigned =>
      'Kelishuv qabul qilindi. Ishlar bo\'limida davom eting.';

  @override
  String get chatAgreementDescriptionLabel => 'Ish hajmi';

  @override
  String get chatAgreementDescriptionHint => 'Aniq nima bajarilishi kerak?';

  @override
  String get chatAgreementDescriptionRequired => 'Ishni tasvirlang';

  @override
  String get chatAgreementNoteHint => 'masalan: To\'lov ish tugagach naqd';

  @override
  String get chatAgreementSent => 'Kelishuv yuborildi';

  @override
  String get chatAgreementSendFailed => 'Kelishuvni yuborib bo\'lmadi';

  @override
  String get chatAgreementAccepted => 'Kelishuv qabul qilindi. Ish tayinlandi.';

  @override
  String get chatAgreementDeclined => 'Kelishuv rad etildi';

  @override
  String get chatCounterAction => 'Qarshi taklif';

  @override
  String get chatCounterCreateTitle => 'Qarshi taklif';

  @override
  String get chatCounterSubtitle =>
      'Yangilangan shartlarni shu suhbatga yuboring.';

  @override
  String get chatCounterNoteHint => 'masalan: Bugun shu narxda bajaraman';

  @override
  String get chatCounterSent => 'Qarshi taklif yuborildi';

  @override
  String get chatCounterSendFailed => 'Qarshi taklifni yuborib bo\'lmadi';

  @override
  String get chatCallAction => 'Qo\'ng\'iroq';

  @override
  String get chatContactUnlocked =>
      'Bu qabul qilingan ish uchun qo\'ng\'iroq ochildi.';

  @override
  String get chatContactUnavailable => 'Aloqa hali mavjud emas.';

  @override
  String get chatCallFailed => 'Telefon qo\'ng\'irog\'ini ochib bo\'lmadi.';

  @override
  String get chatQuickLocation => 'Manzil';

  @override
  String get chatQuickPrice => 'Narx';

  @override
  String get chatQuickYordam => '@yordam';

  @override
  String get chatQuickLocationMessage => 'Aniq manzilni shu yerda yuboraman.';

  @override
  String get chatQuickPriceMessage =>
      'Boshlashdan oldin narxni kelishib olamizmi?';

  @override
  String get chatQuickYordamMessage =>
      '@yordam bu ish uchun adolatli shartlarni taklif qil';

  @override
  String get safetyMenuTooltip => 'Xavfsizlik amallari';

  @override
  String get safetyBlockAction => 'Bloklash';

  @override
  String get safetyUnblockAction => 'Blokdan chiqarish';

  @override
  String get safetyReportAction => 'Shikoyat qilish';

  @override
  String safetyBlockTitle(String name) {
    return '$name bloklansinmi?';
  }

  @override
  String get safetyBlockConfirm =>
      'U sizga qayta xabar yozolmaydi yoki aloqa qila olmaydi. Mavjud chat dalil uchun ko\'rinib turadi.';

  @override
  String safetyBlocked(String name) {
    return '$name bloklandi';
  }

  @override
  String safetyUnblocked(String name) {
    return '$name blokdan chiqarildi';
  }

  @override
  String safetyBlockedComposer(String name) {
    return 'Siz $name ni blokladingiz. Xabar yozish o\'chirilgan.';
  }

  @override
  String safetyBlockedByThemComposer(String name) {
    return '$name sizni blokladi. Bu chatni o\'qiy olasiz, lekin xabar yozish o\'chirilgan.';
  }

  @override
  String safetyMutualBlockedComposer(String name) {
    return 'Siz va $name bir-biringizni bloklagansiz. Chat ko\'rinib turadi, lekin xabar yozish o\'chirilgan.';
  }

  @override
  String safetyReportTitle(String name) {
    return '$name ustidan shikoyat';
  }

  @override
  String get safetyReportSubtitle =>
      'Shikoyatlar IshHubga xavfli, spam yoki platformadan tashqariga olib chiqish holatlarini ko\'rib chiqishga yordam beradi.';

  @override
  String get safetyReportReasonLabel => 'Sabab';

  @override
  String get safetyReportDetailsLabel => 'Tafsilotlar';

  @override
  String get safetyReportSubmit => 'Shikoyat yuborish';

  @override
  String get safetyReportSent => 'Shikoyat yuborildi';

  @override
  String get safetyReportReasonAbuse => 'Haqoratli muomala';

  @override
  String get safetyReportReasonSpam => 'Spam';

  @override
  String get safetyReportReasonFraud => 'Firibgarlik';

  @override
  String get safetyReportReasonOffPlatform =>
      'Platformadan tashqariga o\'tishga majburlash';

  @override
  String get safetyReportReasonSafety => 'Xavfsizlik xavotiri';

  @override
  String get safetyReportReasonOther => 'Boshqa';

  @override
  String get streetModeTitle => 'Ko\'chada rejim';

  @override
  String get streetPermissionDenied => 'Joylashuv ruxsati berilmadi';

  @override
  String get streetPermissionSettings => 'Sozlamalardan ruxsat bering';

  @override
  String get streetServiceDisabled => 'Joylashuv xizmati o\'chirilgan';

  @override
  String get streetLocationRequired => 'Avval joylashuvni tanlang';

  @override
  String get streetEnabled => 'Ko\'chada rejim yoqildi';

  @override
  String get streetDisabled => 'Rejim o\'chirildi';

  @override
  String get streetGetLocation => 'Hozirgi joylashuvni olish';

  @override
  String streetSearchRadius(String radius) {
    return 'Qidiruv radiusi: $radius km';
  }

  @override
  String get streetTurnOff => 'Rejimni o\'chirish';

  @override
  String get streetTurnOn => 'Ko\'chada rejimni yoqish';

  @override
  String get streetActiveStatus => 'Hozir mijozlar sizni topa oladi';

  @override
  String get streetInactiveStatus => 'Rejim o\'chirilgan';

  @override
  String get streetNoSavedLocation => 'Hali joylashuv saqlanmagan';

  @override
  String streetSavedLocation(String radius) {
    return 'Saqlangan radius: $radius km';
  }

  @override
  String streetLastUpdated(String time) {
    return 'Yangilandi: $time';
  }

  @override
  String get streetActivateWorkerNeeded =>
      'Bu funksiya uchun ustachi profilini oching';

  @override
  String get streetActivateWorker => 'Ochish';

  @override
  String get notificationsTitle => 'Bildirishnomalar';

  @override
  String get notificationsMarkAllRead => 'Hammasini o\'qildi';

  @override
  String get notificationsEmpty => 'Hozircha bildirishnomalar yo\'q';

  @override
  String get notificationFallbackTitle => 'Bildirishnoma';

  @override
  String get closeoutUploadFailed => 'Dalilni yuklab bo\'lmadi';

  @override
  String get closeoutMissingContext =>
      'Buni ish tafsilotlari oynasidan oching.';

  @override
  String get paymentRecordTitle => 'To\'lovni qayd etish';

  @override
  String paymentAmountLabel(String currency) {
    return 'Summa ($currency)';
  }

  @override
  String get paymentAmountRequired => 'To\'g\'ri summani kiriting';

  @override
  String get paymentMethodLabel => 'To\'lov usuli';

  @override
  String get paymentMethodCash => 'Naqd';

  @override
  String get paymentMethodCardTransfer => 'O\'tkazma';

  @override
  String get paymentMethodOther => 'Boshqa';

  @override
  String get paymentNoteLabel => 'Izoh (ixtiyoriy)';

  @override
  String get paymentAddReceipt => 'Chek rasmini qo\'shish';

  @override
  String get paymentChangeReceipt => 'Chek rasmini almashtirish';

  @override
  String get paymentRecordAction => 'To\'ladim';

  @override
  String paymentRecordFootnote(String amount, String currency) {
    return 'Siz $amount $currency to\'lovni qayd etyapsiz. Pul mijoz va ustachi orasida to\'g\'ridan-to\'g\'ri beriladi.';
  }

  @override
  String get paymentRecorded => 'To\'lov qayd etildi';

  @override
  String get paymentConfirmAction => 'Oldim deb tasdiqlash';

  @override
  String get paymentDisputeAction => 'To\'lov bo\'yicha nizo';

  @override
  String get paymentDisputeTitle => 'To\'lov bo\'yicha nizo';

  @override
  String get paymentDisputeReasonLabel => 'Nima bo\'ldi?';

  @override
  String get paymentDisputeSubmit => 'Nizoni yuborish';

  @override
  String get paymentStatusRecorded => 'Ustachi tasdig\'i kutilmoqda';

  @override
  String get paymentStatusConfirmed => 'To\'lov tasdiqlandi';

  @override
  String get paymentStatusDisputed => 'To\'lov bo\'yicha nizo bor';

  @override
  String get ratingTitle => 'Tajribani baholash';

  @override
  String get ratingSubmitted => 'Baho yuborildi';

  @override
  String ratingStars(int count) {
    return '$count yulduz';
  }

  @override
  String get ratingTagsLabel => 'Tez teglar';

  @override
  String get ratingCommentLabel => 'Fikr (ixtiyoriy)';

  @override
  String get ratingSubmitAction => 'Baholash';

  @override
  String get ratingTagClearInstructions => 'Aniq tushuntirdi';

  @override
  String get ratingTagRespectful => 'Hurmatli';

  @override
  String get ratingTagPaidOnTime => 'Vaqtida to\'ladi';

  @override
  String get ratingTagPunctual => 'Vaqtida keldi';

  @override
  String get ratingTagSkilled => 'Malakali';

  @override
  String get ratingTagFriendly => 'Xushmuomala';

  @override
  String get ratingTagWouldHireAgain => 'Yana chaqiraman';

  @override
  String get disputeOpenTitle => 'Nizo ochish';

  @override
  String get disputeOpenAction => 'Muammo bildirish';

  @override
  String get disputeEvidenceLimit => 'Ko\'pi bilan 6 ta dalil rasmi';

  @override
  String get disputeMissingCounterparty => 'Ikkinchi tomonni topib bo\'lmadi';

  @override
  String get disputeOpened => 'Nizo ochildi';

  @override
  String get disputeReasonLabel => 'Sabab';

  @override
  String get disputeDescriptionLabel => 'Tafsilotlar';

  @override
  String get disputeDescriptionRequired => 'Kamida 10 ta belgi kiriting';

  @override
  String get disputeEvidenceLabel => 'Dalillar';

  @override
  String get disputeSubmitAction => 'Nizo ochish';

  @override
  String get disputeReasonNotPaid => 'To\'lanmadi';

  @override
  String get disputeReasonUnderpaid => 'Kam to\'landi';

  @override
  String get disputeReasonWorkNotDone => 'Ish bajarilmadi';

  @override
  String get disputeReasonPoorQuality => 'Sifati past';

  @override
  String get disputeReasonNoShow => 'Kelmagan';

  @override
  String get disputeReasonDamagedProperty => 'Mulk shikastlandi';

  @override
  String get disputeReasonAbusiveBehavior => 'Qo\'pol muomala';

  @override
  String get disputeReasonOther => 'Boshqa';

  @override
  String get disputeDetailTitle => 'Nizo';

  @override
  String disputeOpenedAt(String date) {
    return 'Ochilgan vaqt: $date';
  }

  @override
  String get disputeAiBriefTitle => 'AI xulosa';

  @override
  String get disputeAiBriefPending => 'AI xulosa tayyorlanmoqda.';

  @override
  String get disputeResolutionTitle => 'Yechim';

  @override
  String get disputeBannerTitle => 'Bu ish bo\'yicha nizo ochilgan';

  @override
  String get disputeStatusOpen => 'Ochiq';

  @override
  String get disputeStatusAiTriaged => 'AI xulosa tayyor';

  @override
  String get disputeStatusUnderReview => 'Ko\'rib chiqilmoqda';

  @override
  String get disputeStatusResolved => 'Hal qilindi';

  @override
  String get disputeStatusCancelled => 'Bekor qilingan';

  @override
  String get disputeOutcomePending => 'Kutilmoqda';

  @override
  String get disputeOutcomeForOpener => 'Ochgan tomon foydasiga';

  @override
  String get disputeOutcomeAgainstRespondent => 'Javobgar tomonga qarshi';

  @override
  String get disputeOutcomeSplit => 'Qisman';

  @override
  String get disputeOutcomeDismissed => 'Rad etildi';
}
