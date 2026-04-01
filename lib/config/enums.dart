/// Shared constants for the IshHub mobile app.
/// Job statuses, categories, roles, and other enums.

class JobCategory {
  static const String plumbing = 'plumbing';
  static const String electrical = 'electrical';
  static const String cleaning = 'cleaning';
  static const String painting = 'painting';
  static const String carpentry = 'carpentry';
  static const String moving = 'moving';
  static const String repair = 'repair';
  static const String gardening = 'gardening';
  static const String tutoring = 'tutoring';
  static const String delivery = 'delivery';
  static const String cooking = 'cooking';
  static const String driving = 'driving';
  static const String construction = 'construction';
  static const String welding = 'welding';
  static const String acRepair = 'ac_repair';
  static const String applianceRepair = 'appliance_repair';
  static const String other = 'other';

  static const Map<String, String> labels = {
    plumbing: 'Santexnika',
    electrical: 'Elektrika',
    cleaning: 'Tozalash',
    painting: "Bo'yash",
    carpentry: 'Duradgorlik',
    moving: "Ko'chirish",
    repair: "Ta'mirlash",
    gardening: "Bog'dorchilik",
    tutoring: 'Repetitorlik',
    delivery: 'Yetkazib berish',
    cooking: 'Oshpazlik',
    driving: 'Haydovchilik',
    construction: 'Qurilish',
    welding: 'Payvandlash',
    acRepair: "Konditsioner ta'mirlash",
    applianceRepair: "Maishiy texnika ta'mirlash",
    other: 'Boshqa',
  };
}

class JobStatus {
  static const String posted = 'posted';
  static const String accepted = 'accepted';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String expired = 'expired';
}

class ApplicationStatus {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String declined = 'declined';
}

class AgreementStatus {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String declined = 'declined';
}

class UserRole {
  static const String client = 'client';
  static const String worker = 'worker';
}

class PaymentMethod {
  static const String cash = 'cash';
}

class AppLanguage {
  static const String uzbek = 'uz';
  static const String russian = 'ru';
}
