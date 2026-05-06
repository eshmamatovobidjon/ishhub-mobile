// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'IshHub';

  @override
  String get navFeed => 'Лента';

  @override
  String get navJobs => 'Работы';

  @override
  String get navChat => 'Чат';

  @override
  String get navProfile => 'Профиль';

  @override
  String get notificationsTooltip => 'Уведомления';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileActivateWorker => 'Открыть профиль мастера';

  @override
  String get profileWorkerActive => 'Профиль мастера активен';

  @override
  String get profileTrustTitle => 'Профиль доверия';

  @override
  String profileTrustScore(String score) {
    return 'Доверие $score';
  }

  @override
  String profileTrustRatings(int count) {
    return '$count оценок';
  }

  @override
  String profileTrustCompleted(int count) {
    return '$count завершено';
  }

  @override
  String get profileTrustUnavailable => 'Доверие появится после первых работ.';

  @override
  String get profileWorkerSkillsTitle => 'Навыки для подбора';

  @override
  String get profileWorkerNoSkills => 'Навыки пока не выбраны';

  @override
  String get profileWorkerSkillsUnavailable => 'Не удалось загрузить навыки';

  @override
  String get profileStreetModeTitle => 'Режим на улице';

  @override
  String get profileStreetModeSubtitle => 'Клиенты поблизости смогут вас найти';

  @override
  String get profileAvailabilityOnTitle => 'Доступен сейчас';

  @override
  String get profileAvailabilityOffTitle => 'Доступность выключена';

  @override
  String profileAvailabilityNoLocation(String radius) {
    return 'Радиус $radius км · геолокация не задана';
  }

  @override
  String profileAvailabilitySummary(String radius) {
    return 'Радиус $radius км · геолокация сохранена';
  }

  @override
  String get profilePreferencesTitle => 'Настройки';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get themeTitle => 'Тема';

  @override
  String get themeSubtitle => 'Выберите внешний вид приложения';

  @override
  String get themeDialogTitle => 'Выберите оформление';

  @override
  String get themeDialogSubtitle =>
      'IshHub подстроится под ваши глаза и ритм дня.';

  @override
  String get themeSystemTitle => 'Системная';

  @override
  String get themeSystemDescription => 'Следует настройкам телефона';

  @override
  String get themeLightTitle => 'Светлая';

  @override
  String get themeLightDescription => 'Ясный дневной интерфейс';

  @override
  String get themeDarkTitle => 'Темная';

  @override
  String get themeDarkDescription => 'Мягкий темный режим для вечерней работы';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageSubtitle => 'Выберите язык приложения';

  @override
  String get languageDialogTitle => 'Выберите язык';

  @override
  String get languageDialogSubtitle =>
      'Интерфейс сразу переключится на выбранный язык.';

  @override
  String get languageUzbekTitle => 'O\'zbekcha';

  @override
  String get languageUzbekDescription => 'Основной язык местного рынка';

  @override
  String get languageRussianTitle => 'Русский';

  @override
  String get languageRussianDescription => 'Интерфейс приложения на русском';

  @override
  String get languageEnglishTitle => 'English';

  @override
  String get languageEnglishDescription => 'Использовать IshHub на английском';

  @override
  String get selectedOption => 'Выбрано';

  @override
  String get profileSetupTitle => 'Настройка профиля';

  @override
  String get profileSetupHeadline => 'Сделайте профиль полезным';

  @override
  String get profileSetupSubtitle =>
      'Клиенты и мастера увидят эти данные перед решением о работе.';

  @override
  String get profileSetupNameLabel => 'Полное имя';

  @override
  String get profileSetupNameRequired => 'Введите минимум 2 символа';

  @override
  String get profileSetupCityLabel => 'Город';

  @override
  String get profileSetupDistrictLabel => 'Район или квартал';

  @override
  String get profileSetupLocationTitle => 'Геолокация для лучшего подбора';

  @override
  String get profileSetupLocationSubtitle =>
      'Используйте GPS сейчас или продолжите только с городом и районом.';

  @override
  String get profileSetupLocationReady =>
      'Геолокация сохранена для ближайших работ.';

  @override
  String get profileSetupUseLocation => 'GPS';

  @override
  String get profileSetupAvatarLaterTitle => 'Фото добавим позже';

  @override
  String get profileSetupAvatarLaterSubtitle =>
      'Пока в приложении будут показываться ваши инициалы. Загрузка фото появится здесь.';

  @override
  String get profileSetupContinue => 'Продолжить';

  @override
  String get commonNetworkError => 'Ошибка сети';

  @override
  String get commonNetworkErrorRetry => 'Ошибка сети. Попробуйте еще раз.';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get asyncEmpty => 'Пока пусто';

  @override
  String get asyncRetry => 'Повторить';

  @override
  String get authPhoneRequired => 'Введите номер телефона';

  @override
  String get authWelcomeTitle => 'Добро пожаловать в IshHub';

  @override
  String get authWelcomeSubtitle => 'Введите номер телефона, чтобы войти';

  @override
  String get authPhoneLabel => 'Телефон';

  @override
  String get authPhoneHint => '+998901234567';

  @override
  String get authSendCode => 'Отправить код';

  @override
  String get authCodeRequired => 'Введите код полностью';

  @override
  String get authOtpHint => '• • • • • •';

  @override
  String get authCodeResent => 'Код отправлен повторно';

  @override
  String get authOtpTitle => 'Код подтверждения';

  @override
  String authOtpSentTo(String phone) {
    return 'Отправлен на номер $phone';
  }

  @override
  String get authVerify => 'Подтвердить';

  @override
  String get authResendCode => 'Отправить код еще раз';

  @override
  String get rolePickerDescription =>
      'Это позволит вам находить работы и отправлять предложения.';

  @override
  String get rolePickerClientTitle => 'Мне нужны мастера';

  @override
  String get rolePickerClientSubtitle =>
      'Публикуйте работы, сравнивайте предложения и управляйте процессом';

  @override
  String get rolePickerWorkerTitle => 'Буду работать мастером';

  @override
  String get rolePickerWorkerSubtitle =>
      'Откройте профиль мастера, чтобы находить работы';

  @override
  String get workerSetupTitle => 'Настройка мастера';

  @override
  String get workerSetupHeadline => 'Соберите профиль, который получает работу';

  @override
  String get workerSetupSubtitle =>
      'Выберите реальные навыки, добавьте короткое описание и ставку, чтобы подбор и клиенты доверяли предложению.';

  @override
  String get workerSetupSkillSearchLabel => 'Поиск навыков';

  @override
  String get workerSetupSkillsRequired => 'Выберите хотя бы один навык';

  @override
  String get workerSetupBioLabel => 'О себе';

  @override
  String get workerSetupBioHint =>
      'например: Ремонтирую сантехнику, двери и мелкую электрику. Могу приехать со своими инструментами.';

  @override
  String get workerSetupRateLabel => 'Базовая ставка (UZS)';

  @override
  String get workerSetupRateUnitLabel => 'Ед.';

  @override
  String get workerSetupStreetModeTitle => 'Режим на улице после настройки';

  @override
  String get workerSetupStreetModeSubtitle =>
      'Когда профиль будет активен, вы сможете включить доступность поблизости.';

  @override
  String get workerSetupAvailabilityTitle => 'Где клиенты смогут вас найти?';

  @override
  String get workerSetupAvailabilitySubtitle =>
      'Сохраните геолокацию для ближайших работ. Профиль можно открыть и без GPS.';

  @override
  String get workerSetupLocationReady =>
      'Геолокация готова. Лента сможет ранжировать ближайшие работы.';

  @override
  String get workerSetupUseLocation => 'Получить текущее местоположение';

  @override
  String workerSetupRadius(String radius) {
    return 'Радиус работы: $radius км';
  }

  @override
  String get workerSetupAvailableNowTitle =>
      'Включить режим на улице после настройки';

  @override
  String get workerSetupAvailableNowSubtitle =>
      'Клиенты поблизости сразу смогут вас найти.';

  @override
  String get workerSetupAvailableNowNeedsLocation =>
      'Сначала выберите геолокацию.';

  @override
  String get workerSetupFinish => 'Открыть профиль мастера';

  @override
  String get feedMapTooltip => 'Карта';

  @override
  String get feedListTooltip => 'Список';

  @override
  String get feedFiltersTooltip => 'Фильтры';

  @override
  String get feedFiltersTitle => 'Фильтры';

  @override
  String feedSearchRadius(String radius) {
    return 'Радиус поиска: $radius км';
  }

  @override
  String get feedKeywordLabel => 'Ключевое слово';

  @override
  String get feedKeywordHint => 'например: сантехник';

  @override
  String get feedApplyFilters => 'Применить';

  @override
  String get feedDistanceFallback => 'Показываем свежие работы';

  @override
  String feedSkillMatch(int count) {
    return 'Совпадений навыков: $count';
  }

  @override
  String feedMatchScore(int percent) {
    return 'Совпадение $percent%';
  }

  @override
  String get feedOpenToOffer => 'Откройте детали, чтобы отправить предложение';

  @override
  String get feedStreetModePromptTitle =>
      'Включите режим на улице для ближайших работ';

  @override
  String get feedStreetModePromptSubtitle =>
      'Пока он выключен, Лента показывает свежие открытые работы без точного расстояния.';

  @override
  String get feedEmpty =>
      'Пока нет подходящих работ.\nПопробуйте изменить фильтры.';

  @override
  String get feedActivateWorkerTitle =>
      'Откройте профиль мастера, чтобы находить работы';

  @override
  String get feedBecomeWorker => 'Стать мастером';

  @override
  String get findWorkersTitle => 'Найти мастеров';

  @override
  String get findWorkersUnnamedWorker => 'Мастер';

  @override
  String get findWorkersHeader => 'Мастера рядом сейчас';

  @override
  String findWorkersHeaderSubtitle(String radius) {
    return 'В радиусе $radius км · только режим на улице';
  }

  @override
  String get findWorkersUseCurrentLocation => 'Текущая геолокация';

  @override
  String get findWorkersLocationTitle => 'Найдите мастеров рядом';

  @override
  String get findWorkersLocationSubtitle =>
      'Используйте текущую геолокацию, чтобы увидеть доступных мастеров вокруг.';

  @override
  String get findWorkersEmpty =>
      'Рядом пока нет доступных мастеров.\nУвеличьте радиус или попробуйте другой навык.';

  @override
  String get findWorkersClosestNow => 'Ближайшие сейчас';

  @override
  String findWorkersCount(int count) {
    return 'Мастеров: $count';
  }

  @override
  String findWorkersDistance(String distance) {
    return '$distance км от вас';
  }

  @override
  String findWorkersRate(String amount, String unit) {
    return '$amount UZS · $unit';
  }

  @override
  String findWorkersTrust(String score) {
    return 'Доверие $score';
  }

  @override
  String get findWorkersNewBadge => 'Новый';

  @override
  String get findWorkersFreshNow => 'Обновлено сейчас';

  @override
  String get findWorkersFreshRecent => 'Недавно обновлено';

  @override
  String get findWorkersFreshStale => 'Может быть рядом';

  @override
  String get findWorkersFreshUnknown => 'Доступность включена';

  @override
  String get contactWorkerAction => 'Написать мастеру';

  @override
  String contactWorkerTitle(String worker) {
    return 'Связаться: $worker';
  }

  @override
  String contactWorkerDefaultMessage(String worker) {
    return 'Здравствуйте, $worker. Я нашел вас рядом. Можем обсудить работу?';
  }

  @override
  String get contactWorkerMessageLabel => 'Первое сообщение';

  @override
  String get contactWorkerSend => 'Открыть чат';

  @override
  String get contactWorkerSending => 'Открываем чат...';

  @override
  String get contactWorkerUnavailable =>
      'Этот мастер больше недоступен. Список обновлен.';

  @override
  String get contactWorkerLocationRequired =>
      'Выберите место поиска перед сообщением мастеру.';

  @override
  String get contactWorkerMessageRequired =>
      'Напишите короткое первое сообщение.';

  @override
  String get findWorkersPostJobAction => 'Создать работу для мастера';

  @override
  String get findWorkersFiltersTitle => 'Фильтры мастеров';

  @override
  String get findWorkersSearchLabel => 'Навык или слово';

  @override
  String get findWorkersSearchHint => 'например: уборщик';

  @override
  String get jobsMineTitle => 'Мои работы';

  @override
  String get jobsHubTitle => 'Рабочий центр';

  @override
  String get jobsTabActiveWork => 'Активные';

  @override
  String get jobsTabPostedByMe => 'Мои объявления';

  @override
  String get jobsTabHistory => 'История';

  @override
  String get jobsActiveEmpty =>
      'Активных назначенных работ пока нет.\nКогда клиент выберет вас или вы примете срочную работу, она появится здесь.';

  @override
  String get jobsPostedEmpty =>
      'Вы пока не публиковали работы.\nСоздайте новую работу.';

  @override
  String get jobsHistoryEmpty =>
      'Завершенные и отмененные назначенные работы появятся здесь.';

  @override
  String get jobsOpenJob => 'Открыть работу';

  @override
  String feedActiveWorkTitle(int count) {
    return 'Активных назначенных работ: $count';
  }

  @override
  String get feedActiveWorkSubtitle =>
      'Откройте раздел Работы, чтобы продолжить назначенную работу.';

  @override
  String jobsError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get jobsEmpty => 'У вас пока нет работ.\nСоздайте новую работу.';

  @override
  String get jobsNew => 'Новая работа';

  @override
  String get chatTitle => 'Чаты';

  @override
  String get jobUntitled => '(без названия)';

  @override
  String get urgencyUrgent => 'Срочно';

  @override
  String get urgencyToday => 'Сегодня';

  @override
  String get urgencyFlexible => 'Гибко';

  @override
  String get pricingFixed => 'Фиксированная';

  @override
  String get pricingHourly => 'Почасовая';

  @override
  String get pricingNegotiable => 'Договорная';

  @override
  String get statusDraft => 'Черновик';

  @override
  String get statusOpen => 'Открыто';

  @override
  String get statusPosted => 'Опубликовано';

  @override
  String get statusMatching => 'Подбор';

  @override
  String get statusAssigned => 'Назначено';

  @override
  String get statusInProgress => 'В работе';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get statusDisputed => 'Открыт спор';

  @override
  String get statusPending => 'Ожидает';

  @override
  String get statusAccepted => 'Принято';

  @override
  String get statusDeclined => 'Отклонено';

  @override
  String get statusWithdrawn => 'Отозвано';

  @override
  String get statusCountered => 'Встречное';

  @override
  String get statusArrived => 'Прибыл';

  @override
  String get statusStarted => 'Начато';

  @override
  String get statusDone => 'Готово';

  @override
  String get statusConfirmed => 'Подтверждено';

  @override
  String get categoryCleaning => 'Уборка';

  @override
  String get categoryConstruction => 'Строительство';

  @override
  String get categoryRepair => 'Ремонт';

  @override
  String get categoryDelivery => 'Доставка';

  @override
  String get categoryFarming => 'Фермерство';

  @override
  String get categoryGardening => 'Садоводство';

  @override
  String get categoryPainting => 'Покраска';

  @override
  String get categoryCooking => 'Готовка';

  @override
  String get categoryTeaching => 'Обучение';

  @override
  String get categoryDesign => 'Дизайн';

  @override
  String get categoryLoading => 'Погрузка';

  @override
  String get categoryOther => 'Другое';

  @override
  String get timeNow => 'сейчас';

  @override
  String timeMinutesAgo(int count) {
    return '$count мин';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count ч';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count дн.';
  }

  @override
  String timeWeeksAgo(int count) {
    return '$count нед.';
  }

  @override
  String get createJobTitle => 'Новая работа';

  @override
  String get createJobIntro => 'Опишите задачу, AI заполнит детали';

  @override
  String get createJobBodyLabel => 'О работе';

  @override
  String get createJobBodyHint =>
      'например: В ванной течет кран, приходите завтра';

  @override
  String get createJobAddressLabel => 'Адрес (необязательно)';

  @override
  String createJobPhotosCount(int count) {
    return 'Фото ($count/6)';
  }

  @override
  String get createJobAnalyze => 'Проанализировать с AI';

  @override
  String get createJobLocationFailed => 'Не удалось получить геолокацию';

  @override
  String get createJobMaxPhotos => 'Максимум 6 фото';

  @override
  String get createJobUploadFailed => 'Не удалось загрузить';

  @override
  String get createJobInputRequired =>
      'Введите текст или добавьте хотя бы 1 фото';

  @override
  String get createJobLocationRequired => 'Укажите геолокацию';

  @override
  String get createJobLocationSelect => 'Укажите геолокацию';

  @override
  String get createJobLocationSelected => 'Геолокация выбрана';

  @override
  String get draftReviewTitle => 'Проверка';

  @override
  String get draftPublished => 'Работа опубликована';

  @override
  String get draftAiFailed => 'AI-анализ не выполнен';

  @override
  String get draftTitleLabel => 'Заголовок';

  @override
  String get draftTitleRequired => 'Нужен заголовок';

  @override
  String get draftDescriptionLabel => 'Описание';

  @override
  String get draftCategoryLabel => 'Категория';

  @override
  String get draftUrgencyLabel => 'Срок';

  @override
  String get draftPricingLabel => 'Тип цены';

  @override
  String get draftHourlyRateLabel => 'Почасовая ставка (UZS)';

  @override
  String get draftEstimatedBudgetLabel => 'Примерный бюджет (необязательно)';

  @override
  String get draftBudgetLabel => 'Бюджет (UZS)';

  @override
  String get draftNegotiableBudgetHelp =>
      'Примерная сумма для переговоров с работниками';

  @override
  String get draftWorkersNeededLabel => 'Количество мастеров';

  @override
  String get draftPhotosLabel => 'Фото';

  @override
  String get draftPublish => 'Опубликовать';

  @override
  String get draftProcessingTitle => 'AI анализирует вашу работу...';

  @override
  String get draftProcessingSubtitle => 'Обычно это занимает 5-10 секунд.';

  @override
  String draftConfidence(int percent) {
    return 'Уверенность AI: $percent%';
  }

  @override
  String galleryTitle(int index, int total) {
    return '$index / $total';
  }

  @override
  String get offerAmountRequired => 'Введите цену';

  @override
  String get offerHoursInvalid => 'Введите корректные часы';

  @override
  String get offerSent => 'Предложение отправлено';

  @override
  String get offerSendFailed => 'Не удалось отправить';

  @override
  String get offerComposeTitle => 'Отправить предложение';

  @override
  String offerJobRecap(String title, String price) {
    return 'Для $title · $price';
  }

  @override
  String get offerPricingTypeLabel => 'Тип цены';

  @override
  String get offerHourlyRateLabel => 'Почасовая ставка (UZS)';

  @override
  String get offerTotalAmountLabel => 'Общая сумма (UZS)';

  @override
  String get offerEstimatedHoursLabel => 'Примерные часы (необязательно)';

  @override
  String get offerNoteLabel => 'Комментарий (необязательно)';

  @override
  String get offerNoteHint => 'например: Сегодня приду в 14:00';

  @override
  String get offerQuickToday => 'Могу прийти сегодня';

  @override
  String get offerQuickTools => 'Инструменты с собой';

  @override
  String get offerSubmit => 'Отправить';

  @override
  String get jobDetailTitle => 'Детали работы';

  @override
  String get jobDetailPrice => 'Цена';

  @override
  String get jobDetailNegotiablePrice => 'Цена договорная';

  @override
  String get jobDetailAddress => 'Адрес';

  @override
  String get jobDetailDate => 'Дата';

  @override
  String get jobDetailWorkersNeeded => 'Количество мастеров';

  @override
  String get jobDetailIncomingOffers => 'Полученные предложения';

  @override
  String get jobDetailMyOffers => 'Мои предложения';

  @override
  String get jobDetailOffersError => 'Не удалось загрузить предложения';

  @override
  String get jobDetailNoOffers => 'Предложений пока нет';

  @override
  String get jobDetailActionFailed => 'Действие не выполнено';

  @override
  String get jobCancelAction => 'Отменить работу';

  @override
  String get jobCancelConfirmTitle => 'Отменить эту работу?';

  @override
  String get jobCancelPostedBody =>
      'Для этой работы еще нет назначенного мастера. Она будет отменена и исчезнет из ленты.';

  @override
  String get jobCancelAssignedBody =>
      'Мастер уже назначен. Мы уведомим его, а работа не вернется в ленту.';

  @override
  String get jobCancelReasonLabel => 'Причина (необязательно)';

  @override
  String get jobCancelKeepAction => 'Оставить работу';

  @override
  String get jobCancelConfirmAction => 'Отменить работу';

  @override
  String get jobCancelSuccess => 'Работа отменена';

  @override
  String offerDurationEstimate(String hours) {
    return 'Оценка: $hours ч';
  }

  @override
  String get offerPerHourSuffix => '/ч';

  @override
  String get offerDecline => 'Отклонить';

  @override
  String get offerAccept => 'Принять';

  @override
  String get offerWithdraw => 'Отозвать';

  @override
  String get offerOpenChat => 'Перейти в чат';

  @override
  String get offerApplicantUnnamed => 'Мастер';

  @override
  String get offerTrustNew => 'Новый';

  @override
  String offerTrustScore(String score) {
    return 'Доверие $score';
  }

  @override
  String offerTrustRatings(int count) {
    return 'Оценок: $count';
  }

  @override
  String offerTrustCompleted(int count) {
    return 'Выполнено: $count';
  }

  @override
  String get offerAvailableNow => 'Доступен сейчас';

  @override
  String get offerAcceptedAssignmentReady =>
      'Предложение принято. Работа назначена.';

  @override
  String get assignmentMine => 'Мое назначение';

  @override
  String get assignmentArrivedAction => 'Я прибыл';

  @override
  String get assignmentStartedAction => 'Начал работу';

  @override
  String get assignmentDoneAction => 'Завершил';

  @override
  String get assignmentConfirmAction => 'Подтвердить';

  @override
  String get assignmentCancelAction => 'Отменить назначение';

  @override
  String get assignmentCancelConfirmTitle => 'Отменить это назначение?';

  @override
  String get assignmentCancelConfirmBody =>
      'Клиент получит уведомление, а эта работа исчезнет из ваших активных.';

  @override
  String get assignmentCancelKeepAction => 'Оставить назначение';

  @override
  String get assignmentCancelConfirmAction => 'Отменить назначение';

  @override
  String get assignmentCancelSuccess => 'Назначение отменено';

  @override
  String get assignmentCancelClientRecoveryTitle => 'Мастер отменил работу';

  @override
  String get assignmentCancelClientRecoveryBody =>
      'Ваша работа снова открыта. Можно подождать новые предложения или найти другого мастера рядом.';

  @override
  String get assignmentCancelFindWorkerAction => 'Найти другого мастера';

  @override
  String get assignmentArrivedStamp => 'Прибыл';

  @override
  String get assignmentStartedStamp => 'Начал';

  @override
  String get assignmentDoneStamp => 'Завершил';

  @override
  String get assignmentConfirmedStamp => 'Подтверждено';

  @override
  String assignmentStamp(String label, String date) {
    return '$label: $date';
  }

  @override
  String get chatEmpty =>
      'Чатов пока нет.\nПосле отправки предложения чаты появятся здесь.';

  @override
  String get chatSendFailed => 'Не удалось отправить';

  @override
  String get chatMessageHint => 'Напишите сообщение... (@yordam - AI-помощник)';

  @override
  String get chatVoiceMessage => 'Голосовое сообщение';

  @override
  String get chatAiName => 'Yordam AI';

  @override
  String get chatStartHint =>
      'Начните чат. Напишите @yordam, чтобы договориться о цене или времени с помощью AI.';

  @override
  String get chatAgreementAction => 'Создать соглашение';

  @override
  String get chatAgreementCreateTitle => 'Создать соглашение';

  @override
  String get chatAgreementSubtitle =>
      'Зафиксируйте цену и объем до начала работы.';

  @override
  String get chatAgreementCardTitle => 'Рабочее соглашение';

  @override
  String get chatAgreementPrivacy =>
      'Телефон скрыт, пока соглашение не принято.';

  @override
  String get chatAgreementAlreadyAssigned =>
      'Соглашение принято. Продолжайте в разделе работ.';

  @override
  String get chatAgreementDescriptionLabel => 'Объем работы';

  @override
  String get chatAgreementDescriptionHint => 'Что именно нужно сделать?';

  @override
  String get chatAgreementDescriptionRequired => 'Опишите работу';

  @override
  String get chatAgreementNoteHint =>
      'например: Оплата наличными после завершения';

  @override
  String get chatAgreementSent => 'Соглашение отправлено';

  @override
  String get chatAgreementSendFailed => 'Не удалось отправить соглашение';

  @override
  String get chatAgreementAccepted => 'Соглашение принято. Работа назначена.';

  @override
  String get chatAgreementDeclined => 'Соглашение отклонено';

  @override
  String get chatCounterAction => 'Встречное';

  @override
  String get chatCounterCreateTitle => 'Встречное предложение';

  @override
  String get chatCounterSubtitle => 'Отправьте обновленные условия в этот чат.';

  @override
  String get chatCounterNoteHint =>
      'например: Могу сделать сегодня за эту цену';

  @override
  String get chatCounterSent => 'Встречное предложение отправлено';

  @override
  String get chatCounterSendFailed =>
      'Не удалось отправить встречное предложение';

  @override
  String get chatCallAction => 'Позвонить';

  @override
  String get chatContactUnlocked => 'Звонок доступен для этой принятой работы.';

  @override
  String get chatContactUnavailable => 'Контакт пока недоступен.';

  @override
  String get chatCallFailed => 'Не удалось открыть телефонный набор.';

  @override
  String get chatQuickLocation => 'Адрес';

  @override
  String get chatQuickPrice => 'Цена';

  @override
  String get chatQuickYordam => '@yordam';

  @override
  String get chatQuickLocationMessage => 'Я могу отправить точный адрес здесь.';

  @override
  String get chatQuickPriceMessage => 'Давайте согласуем цену до начала?';

  @override
  String get chatQuickYordamMessage =>
      '@yordam предложи честные условия для этой работы';

  @override
  String get safetyMenuTooltip => 'Действия безопасности';

  @override
  String get safetyBlockAction => 'Заблокировать';

  @override
  String get safetyUnblockAction => 'Разблокировать';

  @override
  String get safetyReportAction => 'Пожаловаться';

  @override
  String safetyBlockTitle(String name) {
    return 'Заблокировать $name?';
  }

  @override
  String get safetyBlockConfirm =>
      'Этот пользователь больше не сможет писать или связываться с вами. Существующий чат останется видимым для истории.';

  @override
  String safetyBlocked(String name) {
    return 'Пользователь $name заблокирован';
  }

  @override
  String safetyUnblocked(String name) {
    return 'Пользователь $name разблокирован';
  }

  @override
  String safetyBlockedComposer(String name) {
    return 'Вы заблокировали $name. Сообщения отключены.';
  }

  @override
  String safetyBlockedByThemComposer(String name) {
    return 'Пользователь $name заблокировал вас. Чат остается доступным для чтения, но сообщения отключены.';
  }

  @override
  String safetyMutualBlockedComposer(String name) {
    return 'Вы и $name заблокировали друг друга. Чат остается доступным для чтения, но сообщения отключены.';
  }

  @override
  String safetyReportTitle(String name) {
    return 'Пожаловаться на $name';
  }

  @override
  String get safetyReportSubtitle =>
      'Жалобы помогают IshHub проверять небезопасное поведение, спам и попытки увести общение с платформы.';

  @override
  String get safetyReportReasonLabel => 'Причина';

  @override
  String get safetyReportDetailsLabel => 'Детали';

  @override
  String get safetyReportSubmit => 'Отправить жалобу';

  @override
  String get safetyReportSent => 'Жалоба отправлена';

  @override
  String get safetyReportReasonAbuse => 'Оскорбительное поведение';

  @override
  String get safetyReportReasonSpam => 'Спам';

  @override
  String get safetyReportReasonFraud => 'Мошенничество';

  @override
  String get safetyReportReasonOffPlatform => 'Давление перейти вне платформы';

  @override
  String get safetyReportReasonSafety => 'Вопрос безопасности';

  @override
  String get safetyReportReasonOther => 'Другое';

  @override
  String get streetModeTitle => 'Режим на улице';

  @override
  String get streetPermissionDenied => 'Нет разрешения на геолокацию';

  @override
  String get streetPermissionSettings => 'Разрешите доступ в настройках';

  @override
  String get streetServiceDisabled => 'Служба геолокации отключена';

  @override
  String get streetLocationRequired => 'Сначала выберите геолокацию';

  @override
  String get streetEnabled => 'Режим на улице включен';

  @override
  String get streetDisabled => 'Режим выключен';

  @override
  String get streetGetLocation => 'Получить текущее местоположение';

  @override
  String streetSearchRadius(String radius) {
    return 'Радиус поиска: $radius км';
  }

  @override
  String get streetTurnOff => 'Выключить режим';

  @override
  String get streetTurnOn => 'Включить режим на улице';

  @override
  String get streetActiveStatus => 'Сейчас клиенты могут вас найти';

  @override
  String get streetInactiveStatus => 'Режим выключен';

  @override
  String get streetNoSavedLocation => 'Геолокация пока не сохранена';

  @override
  String streetSavedLocation(String radius) {
    return 'Сохраненный радиус: $radius км';
  }

  @override
  String streetLastUpdated(String time) {
    return 'Обновлено $time';
  }

  @override
  String get streetActivateWorkerNeeded =>
      'Для этой функции откройте профиль мастера';

  @override
  String get streetActivateWorker => 'Открыть';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsMarkAllRead => 'Отметить все прочитанными';

  @override
  String get notificationsEmpty => 'Уведомлений пока нет';

  @override
  String get notificationFallbackTitle => 'Уведомление';

  @override
  String get closeoutUploadFailed => 'Не удалось загрузить доказательство';

  @override
  String get closeoutMissingContext => 'Откройте это с экрана деталей заказа.';

  @override
  String get paymentRecordTitle => 'Отметить оплату';

  @override
  String paymentAmountLabel(String currency) {
    return 'Сумма ($currency)';
  }

  @override
  String get paymentAmountRequired => 'Введите корректную сумму';

  @override
  String get paymentMethodLabel => 'Способ оплаты';

  @override
  String get paymentMethodCash => 'Наличные';

  @override
  String get paymentMethodCardTransfer => 'Перевод';

  @override
  String get paymentMethodOther => 'Другое';

  @override
  String get paymentNoteLabel => 'Заметка (необязательно)';

  @override
  String get paymentAddReceipt => 'Добавить фото чека';

  @override
  String get paymentChangeReceipt => 'Заменить фото чека';

  @override
  String get paymentRecordAction => 'Я оплатил';

  @override
  String paymentRecordFootnote(String amount, String currency) {
    return 'Вы отмечаете оплату $amount $currency. Деньги передаются напрямую между клиентом и мастером.';
  }

  @override
  String get paymentRecorded => 'Оплата отмечена';

  @override
  String get paymentConfirmAction => 'Подтвердить получение';

  @override
  String get paymentDisputeAction => 'Оспорить оплату';

  @override
  String get paymentDisputeTitle => 'Спор по оплате';

  @override
  String get paymentDisputeReasonLabel => 'Что произошло?';

  @override
  String get paymentDisputeSubmit => 'Отправить спор';

  @override
  String get paymentStatusRecorded => 'Ожидает подтверждения мастера';

  @override
  String get paymentStatusConfirmed => 'Оплата подтверждена';

  @override
  String get paymentStatusDisputed => 'Оплата оспорена';

  @override
  String get ratingTitle => 'Оценить опыт';

  @override
  String get ratingSubmitted => 'Оценка отправлена';

  @override
  String ratingStars(int count) {
    return '$count звезд';
  }

  @override
  String get ratingTagsLabel => 'Быстрые теги';

  @override
  String get ratingCommentLabel => 'Отзыв (необязательно)';

  @override
  String get ratingSubmitAction => 'Оценить';

  @override
  String get ratingTagClearInstructions => 'Понятные инструкции';

  @override
  String get ratingTagRespectful => 'Уважительный';

  @override
  String get ratingTagPaidOnTime => 'Оплатил вовремя';

  @override
  String get ratingTagPunctual => 'Пунктуальный';

  @override
  String get ratingTagSkilled => 'Опытный';

  @override
  String get ratingTagFriendly => 'Дружелюбный';

  @override
  String get ratingTagWouldHireAgain => 'Нанял бы снова';

  @override
  String get disputeOpenTitle => 'Открыть спор';

  @override
  String get disputeOpenAction => 'Сообщить о проблеме';

  @override
  String get disputeEvidenceLimit => 'Максимум 6 фото доказательств';

  @override
  String get disputeMissingCounterparty => 'Не удалось найти вторую сторону';

  @override
  String get disputeOpened => 'Спор открыт';

  @override
  String get disputeReasonLabel => 'Причина';

  @override
  String get disputeDescriptionLabel => 'Подробности';

  @override
  String get disputeDescriptionRequired => 'Добавьте минимум 10 символов';

  @override
  String get disputeEvidenceLabel => 'Доказательства';

  @override
  String get disputeSubmitAction => 'Открыть спор';

  @override
  String get disputeReasonNotPaid => 'Не оплатили';

  @override
  String get disputeReasonUnderpaid => 'Недоплатили';

  @override
  String get disputeReasonWorkNotDone => 'Работа не выполнена';

  @override
  String get disputeReasonPoorQuality => 'Плохое качество';

  @override
  String get disputeReasonNoShow => 'Не пришел';

  @override
  String get disputeReasonDamagedProperty => 'Имущество повреждено';

  @override
  String get disputeReasonAbusiveBehavior => 'Грубое поведение';

  @override
  String get disputeReasonOther => 'Другое';

  @override
  String get disputeDetailTitle => 'Спор';

  @override
  String disputeOpenedAt(String date) {
    return 'Открыт $date';
  }

  @override
  String get disputeAiBriefTitle => 'AI-сводка';

  @override
  String get disputeAiBriefPending => 'AI-сводка готовится.';

  @override
  String get disputeResolutionTitle => 'Решение';

  @override
  String get disputeBannerTitle => 'По этому заказу открыт спор';

  @override
  String get disputeStatusOpen => 'Открыт';

  @override
  String get disputeStatusAiTriaged => 'AI-сводка готова';

  @override
  String get disputeStatusUnderReview => 'На рассмотрении';

  @override
  String get disputeStatusResolved => 'Решен';

  @override
  String get disputeStatusCancelled => 'Отменен';

  @override
  String get disputeOutcomePending => 'Ожидает';

  @override
  String get disputeOutcomeForOpener => 'В пользу заявителя';

  @override
  String get disputeOutcomeAgainstRespondent => 'Против ответчика';

  @override
  String get disputeOutcomeSplit => 'Частично';

  @override
  String get disputeOutcomeDismissed => 'Отклонен';
}
