import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

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
    Locale('uz'),
    Locale('ru'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In uz, this message translates to:
  /// **'IshHub'**
  String get appName;

  /// No description provided for @navFeed.
  ///
  /// In uz, this message translates to:
  /// **'Lenta'**
  String get navFeed;

  /// No description provided for @navJobs.
  ///
  /// In uz, this message translates to:
  /// **'Ishlar'**
  String get navJobs;

  /// No description provided for @navChat.
  ///
  /// In uz, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @notificationsTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get notificationsTooltip;

  /// No description provided for @profileTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileActivateWorker.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi profilini ochish'**
  String get profileActivateWorker;

  /// No description provided for @profileWorkerActive.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi profili faol'**
  String get profileWorkerActive;

  /// No description provided for @profileTrustTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ishonch profili'**
  String get profileTrustTitle;

  /// No description provided for @profileTrustScore.
  ///
  /// In uz, this message translates to:
  /// **'Ishonch {score}'**
  String profileTrustScore(String score);

  /// No description provided for @profileTrustRatings.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta baho'**
  String profileTrustRatings(int count);

  /// No description provided for @profileTrustCompleted.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta yakunlangan'**
  String profileTrustCompleted(int count);

  /// No description provided for @profileTrustUnavailable.
  ///
  /// In uz, this message translates to:
  /// **'Ishonch ko\'rsatkichi ilk ishlardan keyin ko\'rinadi.'**
  String get profileTrustUnavailable;

  /// No description provided for @profileWorkerSkillsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Moslash uchun ko\'nikmalar'**
  String get profileWorkerSkillsTitle;

  /// No description provided for @profileWorkerNoSkills.
  ///
  /// In uz, this message translates to:
  /// **'Hali ko\'nikma tanlanmagan'**
  String get profileWorkerNoSkills;

  /// No description provided for @profileWorkerSkillsUnavailable.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'nikmalarni yuklab bo\'lmadi'**
  String get profileWorkerSkillsUnavailable;

  /// No description provided for @profileStreetModeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'chada rejim'**
  String get profileStreetModeTitle;

  /// No description provided for @profileStreetModeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin atrofdagi mijozlar sizni topa olsin'**
  String get profileStreetModeSubtitle;

  /// No description provided for @profileAvailabilityOnTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozir mavjud'**
  String get profileAvailabilityOnTitle;

  /// No description provided for @profileAvailabilityOffTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mavjudlik o\'chirilgan'**
  String get profileAvailabilityOffTitle;

  /// No description provided for @profileAvailabilityNoLocation.
  ///
  /// In uz, this message translates to:
  /// **'Radius {radius} km · joylashuv belgilanmagan'**
  String profileAvailabilityNoLocation(String radius);

  /// No description provided for @profileAvailabilitySummary.
  ///
  /// In uz, this message translates to:
  /// **'Radius {radius} km · joylashuv tayyor'**
  String profileAvailabilitySummary(String radius);

  /// No description provided for @profilePreferencesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get profilePreferencesTitle;

  /// No description provided for @profileSignOut.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get profileSignOut;

  /// No description provided for @themeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mavzu'**
  String get themeTitle;

  /// No description provided for @themeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilova ko\'rinishini tanlang'**
  String get themeSubtitle;

  /// No description provided for @themeDialogTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'rinishni tanlang'**
  String get themeDialogTitle;

  /// No description provided for @themeDialogSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'IshHub ko\'zingizga va kun tartibingizga moslashadi.'**
  String get themeDialogSubtitle;

  /// No description provided for @themeSystemTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tizim'**
  String get themeSystemTitle;

  /// No description provided for @themeSystemDescription.
  ///
  /// In uz, this message translates to:
  /// **'Telefoningiz sozlamasiga ergashadi'**
  String get themeSystemDescription;

  /// No description provided for @themeLightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yorug\''**
  String get themeLightTitle;

  /// No description provided for @themeLightDescription.
  ///
  /// In uz, this message translates to:
  /// **'Kunduzgi, ochiq va ravshan ko\'rinish'**
  String get themeLightDescription;

  /// No description provided for @themeDarkTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qorong\'i'**
  String get themeDarkTitle;

  /// No description provided for @themeDarkDescription.
  ///
  /// In uz, this message translates to:
  /// **'Tungi ishlar uchun yumshoq qorong\'i muhit'**
  String get themeDarkDescription;

  /// No description provided for @languageTitle.
  ///
  /// In uz, this message translates to:
  /// **'Til'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilova tilini tanlang'**
  String get languageSubtitle;

  /// No description provided for @languageDialogTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tilni tanlang'**
  String get languageDialogTitle;

  /// No description provided for @languageDialogSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Interfeys darhol tanlangan tilda ko\'rinadi.'**
  String get languageDialogSubtitle;

  /// No description provided for @languageUzbekTitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekcha'**
  String get languageUzbekTitle;

  /// No description provided for @languageUzbekDescription.
  ///
  /// In uz, this message translates to:
  /// **'Mahalliy bozor uchun asosiy til'**
  String get languageUzbekDescription;

  /// No description provided for @languageRussianTitle.
  ///
  /// In uz, this message translates to:
  /// **'Русский'**
  String get languageRussianTitle;

  /// No description provided for @languageRussianDescription.
  ///
  /// In uz, this message translates to:
  /// **'Русский интерфейс приложения'**
  String get languageRussianDescription;

  /// No description provided for @languageEnglishTitle.
  ///
  /// In uz, this message translates to:
  /// **'English'**
  String get languageEnglishTitle;

  /// No description provided for @languageEnglishDescription.
  ///
  /// In uz, this message translates to:
  /// **'Use IshHub in English'**
  String get languageEnglishDescription;

  /// No description provided for @selectedOption.
  ///
  /// In uz, this message translates to:
  /// **'Tanlangan'**
  String get selectedOption;

  /// No description provided for @profileSetupTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil sozlash'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupHeadline.
  ///
  /// In uz, this message translates to:
  /// **'IshHub profilingizni ishga tayyorlang'**
  String get profileSetupHeadline;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Mijozlar va ustachilar siz bilan ishlashdan oldin shu ma\'lumotlarni ko\'radi.'**
  String get profileSetupSubtitle;

  /// No description provided for @profileSetupNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'To\'liq ism'**
  String get profileSetupNameLabel;

  /// No description provided for @profileSetupNameRequired.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 2 ta belgi kiriting'**
  String get profileSetupNameRequired;

  /// No description provided for @profileSetupCityLabel.
  ///
  /// In uz, this message translates to:
  /// **'Shahar'**
  String get profileSetupCityLabel;

  /// No description provided for @profileSetupDistrictLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tuman yoki mahalla'**
  String get profileSetupDistrictLabel;

  /// No description provided for @profileSetupLocationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaxshiroq moslash uchun joylashuv'**
  String get profileSetupLocationTitle;

  /// No description provided for @profileSetupLocationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozir GPS ishlating yoki faqat shahar va tuman bilan davom eting.'**
  String get profileSetupLocationSubtitle;

  /// No description provided for @profileSetupLocationReady.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin ishlar uchun joylashuv saqlandi.'**
  String get profileSetupLocationReady;

  /// No description provided for @profileSetupUseLocation.
  ///
  /// In uz, this message translates to:
  /// **'GPS'**
  String get profileSetupUseLocation;

  /// No description provided for @profileSetupAvatarLaterTitle.
  ///
  /// In uz, this message translates to:
  /// **'Rasm keyingi bosqichda'**
  String get profileSetupAvatarLaterTitle;

  /// No description provided for @profileSetupAvatarLaterSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ilovada bosh harflaringiz ko\'rinadi. Rasm yuklash shu joyga ulanadi.'**
  String get profileSetupAvatarLaterSubtitle;

  /// No description provided for @profileSetupContinue.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get profileSetupContinue;

  /// No description provided for @commonNetworkError.
  ///
  /// In uz, this message translates to:
  /// **'Tarmoq xatosi'**
  String get commonNetworkError;

  /// No description provided for @commonNetworkErrorRetry.
  ///
  /// In uz, this message translates to:
  /// **'Tarmoq xatosi. Qayta urinib ko\'ring.'**
  String get commonNetworkErrorRetry;

  /// No description provided for @asyncEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha bo\'sh'**
  String get asyncEmpty;

  /// No description provided for @asyncRetry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get asyncRetry;

  /// No description provided for @authPhoneRequired.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamingizni kiriting'**
  String get authPhoneRequired;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In uz, this message translates to:
  /// **'IshHub\'ga xush kelibsiz'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Kirish uchun telefon raqamingizni kiriting'**
  String get authWelcomeSubtitle;

  /// No description provided for @authPhoneLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In uz, this message translates to:
  /// **'+998901234567'**
  String get authPhoneHint;

  /// No description provided for @authSendCode.
  ///
  /// In uz, this message translates to:
  /// **'Kodni yuborish'**
  String get authSendCode;

  /// No description provided for @authCodeRequired.
  ///
  /// In uz, this message translates to:
  /// **'Kodni to\'liq kiriting'**
  String get authCodeRequired;

  /// No description provided for @authOtpHint.
  ///
  /// In uz, this message translates to:
  /// **'• • • • • •'**
  String get authOtpHint;

  /// No description provided for @authCodeResent.
  ///
  /// In uz, this message translates to:
  /// **'Kod qayta yuborildi'**
  String get authCodeResent;

  /// No description provided for @authOtpTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash kodi'**
  String get authOtpTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In uz, this message translates to:
  /// **'{phone} raqamiga yuborildi'**
  String authOtpSentTo(String phone);

  /// No description provided for @authVerify.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get authVerify;

  /// No description provided for @authResendCode.
  ///
  /// In uz, this message translates to:
  /// **'Kodni qayta yuborish'**
  String get authResendCode;

  /// No description provided for @rolePickerDescription.
  ///
  /// In uz, this message translates to:
  /// **'Bu sizga ish topish va takliflar yuborish imkonini beradi.'**
  String get rolePickerDescription;

  /// No description provided for @rolePickerClientTitle.
  ///
  /// In uz, this message translates to:
  /// **'Menga ustachilar kerak'**
  String get rolePickerClientTitle;

  /// No description provided for @rolePickerClientSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ish e\'lon qiling, takliflarni solishtiring va jarayonni boshqaring'**
  String get rolePickerClientSubtitle;

  /// No description provided for @rolePickerWorkerTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi sifatida ishlayman'**
  String get rolePickerWorkerTitle;

  /// No description provided for @rolePickerWorkerSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ishlarni topish uchun ustachi profilini oching'**
  String get rolePickerWorkerSubtitle;

  /// No description provided for @workerSetupTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi sozlash'**
  String get workerSetupTitle;

  /// No description provided for @workerSetupHeadline.
  ///
  /// In uz, this message translates to:
  /// **'Ish yutadigan profilingizni yarating'**
  String get workerSetupHeadline;

  /// No description provided for @workerSetupSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Haqiqiy ko\'nikmalarni tanlang, qisqa bio yozing va tarif kiriting. Shunda moslash va mijoz ishonchi kuchayadi.'**
  String get workerSetupSubtitle;

  /// No description provided for @workerSetupSkillSearchLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'nikmalarni qidirish'**
  String get workerSetupSkillSearchLabel;

  /// No description provided for @workerSetupSkillsRequired.
  ///
  /// In uz, this message translates to:
  /// **'Kamida bitta ko\'nikma tanlang'**
  String get workerSetupSkillsRequired;

  /// No description provided for @workerSetupBioLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bio'**
  String get workerSetupBioLabel;

  /// No description provided for @workerSetupBioHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan: Santexnika, eshik va mayda elektr ishlarini ta\'mirlayman. Asboblarim bilan kelaman.'**
  String get workerSetupBioHint;

  /// No description provided for @workerSetupRateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy tarif (UZS)'**
  String get workerSetupRateLabel;

  /// No description provided for @workerSetupRateUnitLabel.
  ///
  /// In uz, this message translates to:
  /// **'Birlik'**
  String get workerSetupRateUnitLabel;

  /// No description provided for @workerSetupStreetModeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlashdan keyin Ko\'chada rejim'**
  String get workerSetupStreetModeTitle;

  /// No description provided for @workerSetupStreetModeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil faol bo\'lgach, yaqin atrofdagi mavjudlikni yoqishingiz mumkin.'**
  String get workerSetupStreetModeSubtitle;

  /// No description provided for @workerSetupAvailabilityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mijozlar sizni qayerdan topsin?'**
  String get workerSetupAvailabilityTitle;

  /// No description provided for @workerSetupAvailabilitySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin ishlarni yaxshiroq tartiblash uchun joylashuvni saqlang. GPS bo\'lmasa ham profil ochiladi.'**
  String get workerSetupAvailabilitySubtitle;

  /// No description provided for @workerSetupLocationReady.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuv tayyor. Lenta yaqin ishlarni tartiblay oladi.'**
  String get workerSetupLocationReady;

  /// No description provided for @workerSetupUseLocation.
  ///
  /// In uz, this message translates to:
  /// **'Hozirgi joylashuvni olish'**
  String get workerSetupUseLocation;

  /// No description provided for @workerSetupRadius.
  ///
  /// In uz, this message translates to:
  /// **'Xizmat radiusi: {radius} km'**
  String workerSetupRadius(String radius);

  /// No description provided for @workerSetupAvailableNowTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlashdan keyin Ko\'chada rejimni yoqish'**
  String get workerSetupAvailableNowTitle;

  /// No description provided for @workerSetupAvailableNowSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin mijozlar sizni darhol topa oladi.'**
  String get workerSetupAvailableNowSubtitle;

  /// No description provided for @workerSetupAvailableNowNeedsLocation.
  ///
  /// In uz, this message translates to:
  /// **'Avval joylashuvni tanlang.'**
  String get workerSetupAvailableNowNeedsLocation;

  /// No description provided for @workerSetupFinish.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi profilini ochish'**
  String get workerSetupFinish;

  /// No description provided for @feedMapTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Xarita'**
  String get feedMapTooltip;

  /// No description provided for @feedListTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Ro\'yxat'**
  String get feedListTooltip;

  /// No description provided for @feedFiltersTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Filtrlar'**
  String get feedFiltersTooltip;

  /// No description provided for @feedFiltersTitle.
  ///
  /// In uz, this message translates to:
  /// **'Filtrlar'**
  String get feedFiltersTitle;

  /// No description provided for @feedSearchRadius.
  ///
  /// In uz, this message translates to:
  /// **'Qidiruv radiusi: {radius} km'**
  String feedSearchRadius(String radius);

  /// No description provided for @feedKeywordLabel.
  ///
  /// In uz, this message translates to:
  /// **'Kalit so\'z'**
  String get feedKeywordLabel;

  /// No description provided for @feedKeywordHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan: santexnik'**
  String get feedKeywordHint;

  /// No description provided for @feedApplyFilters.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'llash'**
  String get feedApplyFilters;

  /// No description provided for @feedDistanceFallback.
  ///
  /// In uz, this message translates to:
  /// **'Yangi ishlar ko\'rsatilmoqda'**
  String get feedDistanceFallback;

  /// No description provided for @feedSkillMatch.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta ko\'nikma mos'**
  String feedSkillMatch(int count);

  /// No description provided for @feedMatchScore.
  ///
  /// In uz, this message translates to:
  /// **'{percent}% mos'**
  String feedMatchScore(int percent);

  /// No description provided for @feedOpenToOffer.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborish uchun tafsilotni oching'**
  String get feedOpenToOffer;

  /// No description provided for @feedStreetModePromptTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin ishlar uchun Ko\'chada rejimni yoqing'**
  String get feedStreetModePromptTitle;

  /// No description provided for @feedStreetModePromptSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ungacha Lenta masofani aniq ko\'rsatmasdan yangi ochiq ishlarni chiqaradi.'**
  String get feedStreetModePromptSubtitle;

  /// No description provided for @feedEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha sizga mos ish topilmadi.\nFiltrlarni o\'zgartirib ko\'ring.'**
  String get feedEmpty;

  /// No description provided for @feedActivateWorkerTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ish topish uchun ustachi profilini oching'**
  String get feedActivateWorkerTitle;

  /// No description provided for @feedBecomeWorker.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi bo\'lish'**
  String get feedBecomeWorker;

  /// No description provided for @findWorkersTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi topish'**
  String get findWorkersTitle;

  /// No description provided for @findWorkersUnnamedWorker.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi'**
  String get findWorkersUnnamedWorker;

  /// No description provided for @findWorkersHeader.
  ///
  /// In uz, this message translates to:
  /// **'Yaqindagi mavjud ustachilar'**
  String get findWorkersHeader;

  /// No description provided for @findWorkersHeaderSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'{radius} km ichida · faqat Ko\'chada rejim'**
  String findWorkersHeaderSubtitle(String radius);

  /// No description provided for @findWorkersUseCurrentLocation.
  ///
  /// In uz, this message translates to:
  /// **'Hozirgi joylashuv'**
  String get findWorkersUseCurrentLocation;

  /// No description provided for @findWorkersLocationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin ustachilarni toping'**
  String get findWorkersLocationTitle;

  /// No description provided for @findWorkersLocationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Atrofingizdagi mavjud ustachilarni ko\'rish uchun joylashuvingizdan foydalaning.'**
  String get findWorkersLocationSubtitle;

  /// No description provided for @findWorkersEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin atrofda hozir mavjud ustachi topilmadi.\nRadiusni kengaytiring yoki boshqa ko\'nikma kiriting.'**
  String get findWorkersEmpty;

  /// No description provided for @findWorkersClosestNow.
  ///
  /// In uz, this message translates to:
  /// **'Hozir eng yaqinlar'**
  String get findWorkersClosestNow;

  /// No description provided for @findWorkersCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta ustachi'**
  String findWorkersCount(int count);

  /// No description provided for @findWorkersDistance.
  ///
  /// In uz, this message translates to:
  /// **'{distance} km uzoqda'**
  String findWorkersDistance(String distance);

  /// No description provided for @findWorkersRate.
  ///
  /// In uz, this message translates to:
  /// **'{amount} UZS · {unit}'**
  String findWorkersRate(String amount, String unit);

  /// No description provided for @findWorkersTrust.
  ///
  /// In uz, this message translates to:
  /// **'Ishonch {score}'**
  String findWorkersTrust(String score);

  /// No description provided for @findWorkersNewBadge.
  ///
  /// In uz, this message translates to:
  /// **'Yangi'**
  String get findWorkersNewBadge;

  /// No description provided for @findWorkersFreshNow.
  ///
  /// In uz, this message translates to:
  /// **'Hozir yangilandi'**
  String get findWorkersFreshNow;

  /// No description provided for @findWorkersFreshRecent.
  ///
  /// In uz, this message translates to:
  /// **'Yaqinda yangilandi'**
  String get findWorkersFreshRecent;

  /// No description provided for @findWorkersFreshStale.
  ///
  /// In uz, this message translates to:
  /// **'Hali yaqin bo\'lishi mumkin'**
  String get findWorkersFreshStale;

  /// No description provided for @findWorkersFreshUnknown.
  ///
  /// In uz, this message translates to:
  /// **'Mavjudlik yoqilgan'**
  String get findWorkersFreshUnknown;

  /// No description provided for @findWorkersPostJobAction.
  ///
  /// In uz, this message translates to:
  /// **'Shu ustachi uchun ish e\'lon qilish'**
  String get findWorkersPostJobAction;

  /// No description provided for @findWorkersFiltersTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi filtrlari'**
  String get findWorkersFiltersTitle;

  /// No description provided for @findWorkersSearchLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'nikma yoki kalit so\'z'**
  String get findWorkersSearchLabel;

  /// No description provided for @findWorkersSearchHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan: farrosh'**
  String get findWorkersSearchHint;

  /// No description provided for @jobsMineTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mening ishlarim'**
  String get jobsMineTitle;

  /// No description provided for @jobsHubTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ish markazi'**
  String get jobsHubTitle;

  /// No description provided for @jobsTabActiveWork.
  ///
  /// In uz, this message translates to:
  /// **'Faol ishlar'**
  String get jobsTabActiveWork;

  /// No description provided for @jobsTabPostedByMe.
  ///
  /// In uz, this message translates to:
  /// **'Men e\'lon qilganlar'**
  String get jobsTabPostedByMe;

  /// No description provided for @jobsTabHistory.
  ///
  /// In uz, this message translates to:
  /// **'Tarix'**
  String get jobsTabHistory;

  /// No description provided for @jobsActiveEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha faol tayinlangan ishlar yo\'q.\nMijoz sizni tanlaganda yoki tez ishni qabul qilganingizda, u shu yerda ko\'rinadi.'**
  String get jobsActiveEmpty;

  /// No description provided for @jobsPostedEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ish e\'lon qilmagansiz.\nYangi ish e\'lon qiling.'**
  String get jobsPostedEmpty;

  /// No description provided for @jobsHistoryEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Yakunlangan va bekor qilingan tayinlangan ishlar shu yerda ko\'rinadi.'**
  String get jobsHistoryEmpty;

  /// No description provided for @jobsOpenJob.
  ///
  /// In uz, this message translates to:
  /// **'Ishni ochish'**
  String get jobsOpenJob;

  /// No description provided for @feedActiveWorkTitle.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta faol tayinlangan ish'**
  String feedActiveWorkTitle(int count);

  /// No description provided for @feedActiveWorkSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Tayinlangan ishni davom ettirish uchun Ishlar bo\'limini oching.'**
  String get feedActiveWorkSubtitle;

  /// No description provided for @jobsError.
  ///
  /// In uz, this message translates to:
  /// **'Xatolik: {error}'**
  String jobsError(String error);

  /// No description provided for @jobsEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ishlaringiz yo\'q.\nYangi ish e\'lon qiling.'**
  String get jobsEmpty;

  /// No description provided for @jobsNew.
  ///
  /// In uz, this message translates to:
  /// **'Yangi ish'**
  String get jobsNew;

  /// No description provided for @chatTitle.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlar'**
  String get chatTitle;

  /// No description provided for @jobUntitled.
  ///
  /// In uz, this message translates to:
  /// **'(nomsiz)'**
  String get jobUntitled;

  /// No description provided for @urgencyUrgent.
  ///
  /// In uz, this message translates to:
  /// **'Shoshilinch'**
  String get urgencyUrgent;

  /// No description provided for @urgencyToday.
  ///
  /// In uz, this message translates to:
  /// **'Bugun'**
  String get urgencyToday;

  /// No description provided for @urgencyFlexible.
  ///
  /// In uz, this message translates to:
  /// **'Erkin'**
  String get urgencyFlexible;

  /// No description provided for @pricingFixed.
  ///
  /// In uz, this message translates to:
  /// **'Belgilangan'**
  String get pricingFixed;

  /// No description provided for @pricingHourly.
  ///
  /// In uz, this message translates to:
  /// **'Soatlik'**
  String get pricingHourly;

  /// No description provided for @pricingNegotiable.
  ///
  /// In uz, this message translates to:
  /// **'Kelishiladi'**
  String get pricingNegotiable;

  /// No description provided for @statusDraft.
  ///
  /// In uz, this message translates to:
  /// **'Qoralama'**
  String get statusDraft;

  /// No description provided for @statusOpen.
  ///
  /// In uz, this message translates to:
  /// **'Ochiq'**
  String get statusOpen;

  /// No description provided for @statusPosted.
  ///
  /// In uz, this message translates to:
  /// **'E\'lon qilingan'**
  String get statusPosted;

  /// No description provided for @statusMatching.
  ///
  /// In uz, this message translates to:
  /// **'Moslashmoqda'**
  String get statusMatching;

  /// No description provided for @statusAssigned.
  ///
  /// In uz, this message translates to:
  /// **'Tayinlangan'**
  String get statusAssigned;

  /// No description provided for @statusInProgress.
  ///
  /// In uz, this message translates to:
  /// **'Jarayonda'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In uz, this message translates to:
  /// **'Yakunlangan'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilingan'**
  String get statusCancelled;

  /// No description provided for @statusDisputed.
  ///
  /// In uz, this message translates to:
  /// **'Nizo ochilgan'**
  String get statusDisputed;

  /// No description provided for @statusPending.
  ///
  /// In uz, this message translates to:
  /// **'Kutilmoqda'**
  String get statusPending;

  /// No description provided for @statusAccepted.
  ///
  /// In uz, this message translates to:
  /// **'Qabul qilingan'**
  String get statusAccepted;

  /// No description provided for @statusDeclined.
  ///
  /// In uz, this message translates to:
  /// **'Rad etilgan'**
  String get statusDeclined;

  /// No description provided for @statusWithdrawn.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarib olingan'**
  String get statusWithdrawn;

  /// No description provided for @statusArrived.
  ///
  /// In uz, this message translates to:
  /// **'Yetib kelgan'**
  String get statusArrived;

  /// No description provided for @statusStarted.
  ///
  /// In uz, this message translates to:
  /// **'Boshlangan'**
  String get statusStarted;

  /// No description provided for @statusDone.
  ///
  /// In uz, this message translates to:
  /// **'Tugagan'**
  String get statusDone;

  /// No description provided for @statusConfirmed.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlangan'**
  String get statusConfirmed;

  /// No description provided for @categoryCleaning.
  ///
  /// In uz, this message translates to:
  /// **'Tozalash'**
  String get categoryCleaning;

  /// No description provided for @categoryConstruction.
  ///
  /// In uz, this message translates to:
  /// **'Qurilish'**
  String get categoryConstruction;

  /// No description provided for @categoryRepair.
  ///
  /// In uz, this message translates to:
  /// **'Ta\'mir'**
  String get categoryRepair;

  /// No description provided for @categoryDelivery.
  ///
  /// In uz, this message translates to:
  /// **'Yetkazib berish'**
  String get categoryDelivery;

  /// No description provided for @categoryFarming.
  ///
  /// In uz, this message translates to:
  /// **'Dehqonchilik'**
  String get categoryFarming;

  /// No description provided for @categoryGardening.
  ///
  /// In uz, this message translates to:
  /// **'Bog\'dorchilik'**
  String get categoryGardening;

  /// No description provided for @categoryPainting.
  ///
  /// In uz, this message translates to:
  /// **'Bo\'yash'**
  String get categoryPainting;

  /// No description provided for @categoryCooking.
  ///
  /// In uz, this message translates to:
  /// **'Oshpazlik'**
  String get categoryCooking;

  /// No description provided for @categoryTeaching.
  ///
  /// In uz, this message translates to:
  /// **'O\'qitish'**
  String get categoryTeaching;

  /// No description provided for @categoryDesign.
  ///
  /// In uz, this message translates to:
  /// **'Dizayn'**
  String get categoryDesign;

  /// No description provided for @categoryLoading.
  ///
  /// In uz, this message translates to:
  /// **'Yuk ortish'**
  String get categoryLoading;

  /// No description provided for @categoryOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get categoryOther;

  /// No description provided for @timeNow.
  ///
  /// In uz, this message translates to:
  /// **'hozir'**
  String get timeNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In uz, this message translates to:
  /// **'{count} daq'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In uz, this message translates to:
  /// **'{count} soat'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In uz, this message translates to:
  /// **'{count} kun'**
  String timeDaysAgo(int count);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In uz, this message translates to:
  /// **'{count} hafta'**
  String timeWeeksAgo(int count);

  /// No description provided for @createJobTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi ish'**
  String get createJobTitle;

  /// No description provided for @createJobIntro.
  ///
  /// In uz, this message translates to:
  /// **'Tasvirlab bering, AI tafsilotlarni to\'ldiradi'**
  String get createJobIntro;

  /// No description provided for @createJobBodyLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ish haqida'**
  String get createJobBodyLabel;

  /// No description provided for @createJobBodyHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan: Vannada kran oqib turibdi, ertaga keling'**
  String get createJobBodyHint;

  /// No description provided for @createJobAddressLabel.
  ///
  /// In uz, this message translates to:
  /// **'Manzil (ixtiyoriy)'**
  String get createJobAddressLabel;

  /// No description provided for @createJobPhotosCount.
  ///
  /// In uz, this message translates to:
  /// **'Rasmlar ({count}/6)'**
  String createJobPhotosCount(int count);

  /// No description provided for @createJobAnalyze.
  ///
  /// In uz, this message translates to:
  /// **'AI bilan tahlil qilish'**
  String get createJobAnalyze;

  /// No description provided for @createJobLocationFailed.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni olib bo\'lmadi'**
  String get createJobLocationFailed;

  /// No description provided for @createJobMaxPhotos.
  ///
  /// In uz, this message translates to:
  /// **'Maksimum 6 ta rasm'**
  String get createJobMaxPhotos;

  /// No description provided for @createJobUploadFailed.
  ///
  /// In uz, this message translates to:
  /// **'Yuklab bo\'lmadi'**
  String get createJobUploadFailed;

  /// No description provided for @createJobInputRequired.
  ///
  /// In uz, this message translates to:
  /// **'Matn yoki kamida 1 ta rasm kiriting'**
  String get createJobInputRequired;

  /// No description provided for @createJobLocationRequired.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni belgilang'**
  String get createJobLocationRequired;

  /// No description provided for @createJobLocationSelect.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni belgilang'**
  String get createJobLocationSelect;

  /// No description provided for @createJobLocationSelected.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuv tanlandi'**
  String get createJobLocationSelected;

  /// No description provided for @draftReviewTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'rib chiqish'**
  String get draftReviewTitle;

  /// No description provided for @draftPublished.
  ///
  /// In uz, this message translates to:
  /// **'Ish e\'lon qilindi'**
  String get draftPublished;

  /// No description provided for @draftAiFailed.
  ///
  /// In uz, this message translates to:
  /// **'AI tahlili amalga oshmadi'**
  String get draftAiFailed;

  /// No description provided for @draftTitleLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha'**
  String get draftTitleLabel;

  /// No description provided for @draftTitleRequired.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha kerak'**
  String get draftTitleRequired;

  /// No description provided for @draftDescriptionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tavsif'**
  String get draftDescriptionLabel;

  /// No description provided for @draftCategoryLabel.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriya'**
  String get draftCategoryLabel;

  /// No description provided for @draftUrgencyLabel.
  ///
  /// In uz, this message translates to:
  /// **'Muddati'**
  String get draftUrgencyLabel;

  /// No description provided for @draftPricingLabel.
  ///
  /// In uz, this message translates to:
  /// **'Narx turi'**
  String get draftPricingLabel;

  /// No description provided for @draftHourlyRateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Soatlik tarif (UZS)'**
  String get draftHourlyRateLabel;

  /// No description provided for @draftEstimatedBudgetLabel.
  ///
  /// In uz, this message translates to:
  /// **'Taxminiy byudjet (ixtiyoriy)'**
  String get draftEstimatedBudgetLabel;

  /// No description provided for @draftBudgetLabel.
  ///
  /// In uz, this message translates to:
  /// **'Byudjet (UZS)'**
  String get draftBudgetLabel;

  /// No description provided for @draftNegotiableBudgetHelp.
  ///
  /// In uz, this message translates to:
  /// **'Ishchilar bilan kelishish uchun taxminiy summa'**
  String get draftNegotiableBudgetHelp;

  /// No description provided for @draftWorkersNeededLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ustachilar soni'**
  String get draftWorkersNeededLabel;

  /// No description provided for @draftPhotosLabel.
  ///
  /// In uz, this message translates to:
  /// **'Rasmlar'**
  String get draftPhotosLabel;

  /// No description provided for @draftPublish.
  ///
  /// In uz, this message translates to:
  /// **'E\'lon qilish'**
  String get draftPublish;

  /// No description provided for @draftProcessingTitle.
  ///
  /// In uz, this message translates to:
  /// **'AI ishingizni tahlil qilmoqda...'**
  String get draftProcessingTitle;

  /// No description provided for @draftProcessingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu odatda 5-10 soniya oladi.'**
  String get draftProcessingSubtitle;

  /// No description provided for @draftConfidence.
  ///
  /// In uz, this message translates to:
  /// **'AI ishonchi: {percent}%'**
  String draftConfidence(int percent);

  /// No description provided for @galleryTitle.
  ///
  /// In uz, this message translates to:
  /// **'{index} / {total}'**
  String galleryTitle(int index, int total);

  /// No description provided for @offerAmountRequired.
  ///
  /// In uz, this message translates to:
  /// **'Narxni kiriting'**
  String get offerAmountRequired;

  /// No description provided for @offerHoursInvalid.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri soat kiriting'**
  String get offerHoursInvalid;

  /// No description provided for @offerSent.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborildi'**
  String get offerSent;

  /// No description provided for @offerSendFailed.
  ///
  /// In uz, this message translates to:
  /// **'Yuborib bo\'lmadi'**
  String get offerSendFailed;

  /// No description provided for @offerComposeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborish'**
  String get offerComposeTitle;

  /// No description provided for @offerJobRecap.
  ///
  /// In uz, this message translates to:
  /// **'{title} uchun · {price}'**
  String offerJobRecap(String title, String price);

  /// No description provided for @offerPricingTypeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Narx turi'**
  String get offerPricingTypeLabel;

  /// No description provided for @offerHourlyRateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Soatlik tarif (UZS)'**
  String get offerHourlyRateLabel;

  /// No description provided for @offerTotalAmountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Umumiy summa (UZS)'**
  String get offerTotalAmountLabel;

  /// No description provided for @offerEstimatedHoursLabel.
  ///
  /// In uz, this message translates to:
  /// **'Taxminiy soat (ixtiyoriy)'**
  String get offerEstimatedHoursLabel;

  /// No description provided for @offerNoteLabel.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get offerNoteLabel;

  /// No description provided for @offerNoteHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan: Bugun soat 14:00 da kelaman'**
  String get offerNoteHint;

  /// No description provided for @offerQuickToday.
  ///
  /// In uz, this message translates to:
  /// **'Bugun kela olaman'**
  String get offerQuickToday;

  /// No description provided for @offerQuickTools.
  ///
  /// In uz, this message translates to:
  /// **'Asboblarim bor'**
  String get offerQuickTools;

  /// No description provided for @offerSubmit.
  ///
  /// In uz, this message translates to:
  /// **'Yuborish'**
  String get offerSubmit;

  /// No description provided for @jobDetailTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ish tafsiloti'**
  String get jobDetailTitle;

  /// No description provided for @jobDetailPrice.
  ///
  /// In uz, this message translates to:
  /// **'Narx'**
  String get jobDetailPrice;

  /// No description provided for @jobDetailNegotiablePrice.
  ///
  /// In uz, this message translates to:
  /// **'Narx kelishiladi'**
  String get jobDetailNegotiablePrice;

  /// No description provided for @jobDetailAddress.
  ///
  /// In uz, this message translates to:
  /// **'Manzil'**
  String get jobDetailAddress;

  /// No description provided for @jobDetailDate.
  ///
  /// In uz, this message translates to:
  /// **'Sana'**
  String get jobDetailDate;

  /// No description provided for @jobDetailWorkersNeeded.
  ///
  /// In uz, this message translates to:
  /// **'Ustachilar soni'**
  String get jobDetailWorkersNeeded;

  /// No description provided for @jobDetailIncomingOffers.
  ///
  /// In uz, this message translates to:
  /// **'Kelgan takliflar'**
  String get jobDetailIncomingOffers;

  /// No description provided for @jobDetailMyOffers.
  ///
  /// In uz, this message translates to:
  /// **'Mening takliflarim'**
  String get jobDetailMyOffers;

  /// No description provided for @jobDetailOffersError.
  ///
  /// In uz, this message translates to:
  /// **'Takliflarni olishda xato'**
  String get jobDetailOffersError;

  /// No description provided for @jobDetailNoOffers.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha takliflar yo\'q'**
  String get jobDetailNoOffers;

  /// No description provided for @jobDetailActionFailed.
  ///
  /// In uz, this message translates to:
  /// **'Amal bajarilmadi'**
  String get jobDetailActionFailed;

  /// No description provided for @offerDurationEstimate.
  ///
  /// In uz, this message translates to:
  /// **'Taxmin: {hours} soat'**
  String offerDurationEstimate(String hours);

  /// No description provided for @offerPerHourSuffix.
  ///
  /// In uz, this message translates to:
  /// **'/soat'**
  String get offerPerHourSuffix;

  /// No description provided for @offerDecline.
  ///
  /// In uz, this message translates to:
  /// **'Rad etish'**
  String get offerDecline;

  /// No description provided for @offerAccept.
  ///
  /// In uz, this message translates to:
  /// **'Qabul qilish'**
  String get offerAccept;

  /// No description provided for @offerWithdraw.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarib olish'**
  String get offerWithdraw;

  /// No description provided for @offerOpenChat.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatga o\'tish'**
  String get offerOpenChat;

  /// No description provided for @offerApplicantUnnamed.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi'**
  String get offerApplicantUnnamed;

  /// No description provided for @offerTrustNew.
  ///
  /// In uz, this message translates to:
  /// **'Yangi'**
  String get offerTrustNew;

  /// No description provided for @offerTrustScore.
  ///
  /// In uz, this message translates to:
  /// **'Ishonch {score}'**
  String offerTrustScore(String score);

  /// No description provided for @offerTrustRatings.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta baho'**
  String offerTrustRatings(int count);

  /// No description provided for @offerTrustCompleted.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta tugagan'**
  String offerTrustCompleted(int count);

  /// No description provided for @offerAvailableNow.
  ///
  /// In uz, this message translates to:
  /// **'Hozir mavjud'**
  String get offerAvailableNow;

  /// No description provided for @offerAcceptedAssignmentReady.
  ///
  /// In uz, this message translates to:
  /// **'Taklif qabul qilindi. Ish tayinlandi.'**
  String get offerAcceptedAssignmentReady;

  /// No description provided for @assignmentMine.
  ///
  /// In uz, this message translates to:
  /// **'Mening tayinlovim'**
  String get assignmentMine;

  /// No description provided for @assignmentArrivedAction.
  ///
  /// In uz, this message translates to:
  /// **'Yetib keldim'**
  String get assignmentArrivedAction;

  /// No description provided for @assignmentStartedAction.
  ///
  /// In uz, this message translates to:
  /// **'Ishni boshladim'**
  String get assignmentStartedAction;

  /// No description provided for @assignmentDoneAction.
  ///
  /// In uz, this message translates to:
  /// **'Tugatdim'**
  String get assignmentDoneAction;

  /// No description provided for @assignmentConfirmAction.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get assignmentConfirmAction;

  /// No description provided for @assignmentArrivedStamp.
  ///
  /// In uz, this message translates to:
  /// **'Yetib keldi'**
  String get assignmentArrivedStamp;

  /// No description provided for @assignmentStartedStamp.
  ///
  /// In uz, this message translates to:
  /// **'Boshladi'**
  String get assignmentStartedStamp;

  /// No description provided for @assignmentDoneStamp.
  ///
  /// In uz, this message translates to:
  /// **'Tugatdi'**
  String get assignmentDoneStamp;

  /// No description provided for @assignmentConfirmedStamp.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlandi'**
  String get assignmentConfirmedStamp;

  /// No description provided for @assignmentStamp.
  ///
  /// In uz, this message translates to:
  /// **'{label}: {date}'**
  String assignmentStamp(String label, String date);

  /// No description provided for @chatEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha suhbatlar yo\'q.\nTaklif yuborgandan so\'ng suhbatlar shu yerda paydo bo\'ladi.'**
  String get chatEmpty;

  /// No description provided for @chatSendFailed.
  ///
  /// In uz, this message translates to:
  /// **'Yuborib bo\'lmadi'**
  String get chatSendFailed;

  /// No description provided for @chatMessageHint.
  ///
  /// In uz, this message translates to:
  /// **'Xabar yozing... (@yordam - AI yordamchi)'**
  String get chatMessageHint;

  /// No description provided for @chatVoiceMessage.
  ///
  /// In uz, this message translates to:
  /// **'Ovozli xabar'**
  String get chatVoiceMessage;

  /// No description provided for @chatAiName.
  ///
  /// In uz, this message translates to:
  /// **'Yordam AI'**
  String get chatAiName;

  /// No description provided for @chatStartHint.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatni boshlang. Narx yoki vaqt haqida kelishish uchun @yordam deb yozing - AI yordam beradi.'**
  String get chatStartHint;

  /// No description provided for @streetModeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'chada rejim'**
  String get streetModeTitle;

  /// No description provided for @streetPermissionDenied.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuv ruxsati berilmadi'**
  String get streetPermissionDenied;

  /// No description provided for @streetPermissionSettings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalardan ruxsat bering'**
  String get streetPermissionSettings;

  /// No description provided for @streetServiceDisabled.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuv xizmati o\'chirilgan'**
  String get streetServiceDisabled;

  /// No description provided for @streetLocationRequired.
  ///
  /// In uz, this message translates to:
  /// **'Avval joylashuvni tanlang'**
  String get streetLocationRequired;

  /// No description provided for @streetEnabled.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'chada rejim yoqildi'**
  String get streetEnabled;

  /// No description provided for @streetDisabled.
  ///
  /// In uz, this message translates to:
  /// **'Rejim o\'chirildi'**
  String get streetDisabled;

  /// No description provided for @streetGetLocation.
  ///
  /// In uz, this message translates to:
  /// **'Hozirgi joylashuvni olish'**
  String get streetGetLocation;

  /// No description provided for @streetSearchRadius.
  ///
  /// In uz, this message translates to:
  /// **'Qidiruv radiusi: {radius} km'**
  String streetSearchRadius(String radius);

  /// No description provided for @streetTurnOff.
  ///
  /// In uz, this message translates to:
  /// **'Rejimni o\'chirish'**
  String get streetTurnOff;

  /// No description provided for @streetTurnOn.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'chada rejimni yoqish'**
  String get streetTurnOn;

  /// No description provided for @streetActiveStatus.
  ///
  /// In uz, this message translates to:
  /// **'Hozir mijozlar sizni topa oladi'**
  String get streetActiveStatus;

  /// No description provided for @streetInactiveStatus.
  ///
  /// In uz, this message translates to:
  /// **'Rejim o\'chirilgan'**
  String get streetInactiveStatus;

  /// No description provided for @streetNoSavedLocation.
  ///
  /// In uz, this message translates to:
  /// **'Hali joylashuv saqlanmagan'**
  String get streetNoSavedLocation;

  /// No description provided for @streetSavedLocation.
  ///
  /// In uz, this message translates to:
  /// **'Saqlangan radius: {radius} km'**
  String streetSavedLocation(String radius);

  /// No description provided for @streetLastUpdated.
  ///
  /// In uz, this message translates to:
  /// **'Yangilandi: {time}'**
  String streetLastUpdated(String time);

  /// No description provided for @streetActivateWorkerNeeded.
  ///
  /// In uz, this message translates to:
  /// **'Bu funksiya uchun ustachi profilini oching'**
  String get streetActivateWorkerNeeded;

  /// No description provided for @streetActivateWorker.
  ///
  /// In uz, this message translates to:
  /// **'Ochish'**
  String get streetActivateWorker;

  /// No description provided for @notificationsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In uz, this message translates to:
  /// **'Hammasini o\'qildi'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha bildirishnomalar yo\'q'**
  String get notificationsEmpty;

  /// No description provided for @notificationFallbackTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnoma'**
  String get notificationFallbackTitle;

  /// No description provided for @closeoutUploadFailed.
  ///
  /// In uz, this message translates to:
  /// **'Dalilni yuklab bo\'lmadi'**
  String get closeoutUploadFailed;

  /// No description provided for @closeoutMissingContext.
  ///
  /// In uz, this message translates to:
  /// **'Buni ish tafsilotlari oynasidan oching.'**
  String get closeoutMissingContext;

  /// No description provided for @paymentRecordTitle.
  ///
  /// In uz, this message translates to:
  /// **'To\'lovni qayd etish'**
  String get paymentRecordTitle;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Summa ({currency})'**
  String paymentAmountLabel(String currency);

  /// No description provided for @paymentAmountRequired.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri summani kiriting'**
  String get paymentAmountRequired;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov usuli'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodCash.
  ///
  /// In uz, this message translates to:
  /// **'Naqd'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCardTransfer.
  ///
  /// In uz, this message translates to:
  /// **'O\'tkazma'**
  String get paymentMethodCardTransfer;

  /// No description provided for @paymentMethodOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get paymentMethodOther;

  /// No description provided for @paymentNoteLabel.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get paymentNoteLabel;

  /// No description provided for @paymentAddReceipt.
  ///
  /// In uz, this message translates to:
  /// **'Chek rasmini qo\'shish'**
  String get paymentAddReceipt;

  /// No description provided for @paymentChangeReceipt.
  ///
  /// In uz, this message translates to:
  /// **'Chek rasmini almashtirish'**
  String get paymentChangeReceipt;

  /// No description provided for @paymentRecordAction.
  ///
  /// In uz, this message translates to:
  /// **'To\'ladim'**
  String get paymentRecordAction;

  /// No description provided for @paymentRecordFootnote.
  ///
  /// In uz, this message translates to:
  /// **'Siz {amount} {currency} to\'lovni qayd etyapsiz. Pul mijoz va ustachi orasida to\'g\'ridan-to\'g\'ri beriladi.'**
  String paymentRecordFootnote(String amount, String currency);

  /// No description provided for @paymentRecorded.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov qayd etildi'**
  String get paymentRecorded;

  /// No description provided for @paymentConfirmAction.
  ///
  /// In uz, this message translates to:
  /// **'Oldim deb tasdiqlash'**
  String get paymentConfirmAction;

  /// No description provided for @paymentDisputeAction.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov bo\'yicha nizo'**
  String get paymentDisputeAction;

  /// No description provided for @paymentDisputeTitle.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov bo\'yicha nizo'**
  String get paymentDisputeTitle;

  /// No description provided for @paymentDisputeReasonLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nima bo\'ldi?'**
  String get paymentDisputeReasonLabel;

  /// No description provided for @paymentDisputeSubmit.
  ///
  /// In uz, this message translates to:
  /// **'Nizoni yuborish'**
  String get paymentDisputeSubmit;

  /// No description provided for @paymentStatusRecorded.
  ///
  /// In uz, this message translates to:
  /// **'Ustachi tasdig\'i kutilmoqda'**
  String get paymentStatusRecorded;

  /// No description provided for @paymentStatusConfirmed.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov tasdiqlandi'**
  String get paymentStatusConfirmed;

  /// No description provided for @paymentStatusDisputed.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov bo\'yicha nizo bor'**
  String get paymentStatusDisputed;

  /// No description provided for @ratingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tajribani baholash'**
  String get ratingTitle;

  /// No description provided for @ratingSubmitted.
  ///
  /// In uz, this message translates to:
  /// **'Baho yuborildi'**
  String get ratingSubmitted;

  /// No description provided for @ratingStars.
  ///
  /// In uz, this message translates to:
  /// **'{count} yulduz'**
  String ratingStars(int count);

  /// No description provided for @ratingTagsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tez teglar'**
  String get ratingTagsLabel;

  /// No description provided for @ratingCommentLabel.
  ///
  /// In uz, this message translates to:
  /// **'Fikr (ixtiyoriy)'**
  String get ratingCommentLabel;

  /// No description provided for @ratingSubmitAction.
  ///
  /// In uz, this message translates to:
  /// **'Baholash'**
  String get ratingSubmitAction;

  /// No description provided for @ratingTagClearInstructions.
  ///
  /// In uz, this message translates to:
  /// **'Aniq tushuntirdi'**
  String get ratingTagClearInstructions;

  /// No description provided for @ratingTagRespectful.
  ///
  /// In uz, this message translates to:
  /// **'Hurmatli'**
  String get ratingTagRespectful;

  /// No description provided for @ratingTagPaidOnTime.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtida to\'ladi'**
  String get ratingTagPaidOnTime;

  /// No description provided for @ratingTagPunctual.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtida keldi'**
  String get ratingTagPunctual;

  /// No description provided for @ratingTagSkilled.
  ///
  /// In uz, this message translates to:
  /// **'Malakali'**
  String get ratingTagSkilled;

  /// No description provided for @ratingTagFriendly.
  ///
  /// In uz, this message translates to:
  /// **'Xushmuomala'**
  String get ratingTagFriendly;

  /// No description provided for @ratingTagWouldHireAgain.
  ///
  /// In uz, this message translates to:
  /// **'Yana chaqiraman'**
  String get ratingTagWouldHireAgain;

  /// No description provided for @disputeOpenTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nizo ochish'**
  String get disputeOpenTitle;

  /// No description provided for @disputeOpenAction.
  ///
  /// In uz, this message translates to:
  /// **'Muammo bildirish'**
  String get disputeOpenAction;

  /// No description provided for @disputeEvidenceLimit.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'pi bilan 6 ta dalil rasmi'**
  String get disputeEvidenceLimit;

  /// No description provided for @disputeMissingCounterparty.
  ///
  /// In uz, this message translates to:
  /// **'Ikkinchi tomonni topib bo\'lmadi'**
  String get disputeMissingCounterparty;

  /// No description provided for @disputeOpened.
  ///
  /// In uz, this message translates to:
  /// **'Nizo ochildi'**
  String get disputeOpened;

  /// No description provided for @disputeReasonLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sabab'**
  String get disputeReasonLabel;

  /// No description provided for @disputeDescriptionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tafsilotlar'**
  String get disputeDescriptionLabel;

  /// No description provided for @disputeDescriptionRequired.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 10 ta belgi kiriting'**
  String get disputeDescriptionRequired;

  /// No description provided for @disputeEvidenceLabel.
  ///
  /// In uz, this message translates to:
  /// **'Dalillar'**
  String get disputeEvidenceLabel;

  /// No description provided for @disputeSubmitAction.
  ///
  /// In uz, this message translates to:
  /// **'Nizo ochish'**
  String get disputeSubmitAction;

  /// No description provided for @disputeReasonNotPaid.
  ///
  /// In uz, this message translates to:
  /// **'To\'lanmadi'**
  String get disputeReasonNotPaid;

  /// No description provided for @disputeReasonUnderpaid.
  ///
  /// In uz, this message translates to:
  /// **'Kam to\'landi'**
  String get disputeReasonUnderpaid;

  /// No description provided for @disputeReasonWorkNotDone.
  ///
  /// In uz, this message translates to:
  /// **'Ish bajarilmadi'**
  String get disputeReasonWorkNotDone;

  /// No description provided for @disputeReasonPoorQuality.
  ///
  /// In uz, this message translates to:
  /// **'Sifati past'**
  String get disputeReasonPoorQuality;

  /// No description provided for @disputeReasonNoShow.
  ///
  /// In uz, this message translates to:
  /// **'Kelmagan'**
  String get disputeReasonNoShow;

  /// No description provided for @disputeReasonDamagedProperty.
  ///
  /// In uz, this message translates to:
  /// **'Mulk shikastlandi'**
  String get disputeReasonDamagedProperty;

  /// No description provided for @disputeReasonAbusiveBehavior.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'pol muomala'**
  String get disputeReasonAbusiveBehavior;

  /// No description provided for @disputeReasonOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get disputeReasonOther;

  /// No description provided for @disputeDetailTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nizo'**
  String get disputeDetailTitle;

  /// No description provided for @disputeOpenedAt.
  ///
  /// In uz, this message translates to:
  /// **'Ochilgan vaqt: {date}'**
  String disputeOpenedAt(String date);

  /// No description provided for @disputeAiBriefTitle.
  ///
  /// In uz, this message translates to:
  /// **'AI xulosa'**
  String get disputeAiBriefTitle;

  /// No description provided for @disputeAiBriefPending.
  ///
  /// In uz, this message translates to:
  /// **'AI xulosa tayyorlanmoqda.'**
  String get disputeAiBriefPending;

  /// No description provided for @disputeResolutionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yechim'**
  String get disputeResolutionTitle;

  /// No description provided for @disputeBannerTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu ish bo\'yicha nizo ochilgan'**
  String get disputeBannerTitle;

  /// No description provided for @disputeStatusOpen.
  ///
  /// In uz, this message translates to:
  /// **'Ochiq'**
  String get disputeStatusOpen;

  /// No description provided for @disputeStatusAiTriaged.
  ///
  /// In uz, this message translates to:
  /// **'AI xulosa tayyor'**
  String get disputeStatusAiTriaged;

  /// No description provided for @disputeStatusUnderReview.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'rib chiqilmoqda'**
  String get disputeStatusUnderReview;

  /// No description provided for @disputeStatusResolved.
  ///
  /// In uz, this message translates to:
  /// **'Hal qilindi'**
  String get disputeStatusResolved;

  /// No description provided for @disputeStatusCancelled.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilingan'**
  String get disputeStatusCancelled;

  /// No description provided for @disputeOutcomePending.
  ///
  /// In uz, this message translates to:
  /// **'Kutilmoqda'**
  String get disputeOutcomePending;

  /// No description provided for @disputeOutcomeForOpener.
  ///
  /// In uz, this message translates to:
  /// **'Ochgan tomon foydasiga'**
  String get disputeOutcomeForOpener;

  /// No description provided for @disputeOutcomeAgainstRespondent.
  ///
  /// In uz, this message translates to:
  /// **'Javobgar tomonga qarshi'**
  String get disputeOutcomeAgainstRespondent;

  /// No description provided for @disputeOutcomeSplit.
  ///
  /// In uz, this message translates to:
  /// **'Qisman'**
  String get disputeOutcomeSplit;

  /// No description provided for @disputeOutcomeDismissed.
  ///
  /// In uz, this message translates to:
  /// **'Rad etildi'**
  String get disputeOutcomeDismissed;
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
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
