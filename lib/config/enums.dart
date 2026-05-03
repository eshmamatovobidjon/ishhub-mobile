/// Backend-aligned enums and string constants. Kept as `String` because
/// the Django API serializes choices as snake_case strings.

class JobStatus {
  static const String draft = 'draft';
  static const String open = 'open';
  static const String matching = 'matching';
  static const String assigned = 'assigned';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String disputed = 'disputed';
}

class Urgency {
  static const String flexible = 'flexible';
  static const String today = 'today';
  static const String urgent = 'urgent';
}

class AssignmentStage {
  static const String accepted = 'accepted';
  static const String arrived = 'arrived';
  static const String started = 'started';
  static const String done = 'done';
  static const String confirmed = 'confirmed';
}

class OfferStatus {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String declined = 'declined';
  static const String withdrawn = 'withdrawn';
}

class PaymentMethod {
  static const String cash = 'cash';
  static const String transfer = 'transfer';
  static const String card = 'card';
}

class PaymentStatus {
  static const String recorded = 'recorded';
  static const String confirmed = 'confirmed';
  static const String disputed = 'disputed';
}

class MessageKind {
  static const String text = 'text';
  static const String voice = 'voice';
  static const String image = 'image';
  static const String offer = 'offer';
  static const String ai = 'ai';
}

enum UserRole { client, worker, both }

class AppLanguage {
  static const String uzbek = 'uz';
  static const String russian = 'ru';
  static const String english = 'en';
}
