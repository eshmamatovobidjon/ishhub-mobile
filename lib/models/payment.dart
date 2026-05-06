class Payment {
  final String id;
  final String assignmentId;
  final String? payerId;
  final String? payeeId;
  final num amount;
  final String currency;
  final String method;
  final String status;
  final String note;
  final String receiptUrl;
  final DateTime? confirmedAt;
  final DateTime? disputedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Payment({
    required this.id,
    required this.assignmentId,
    required this.payerId,
    required this.payeeId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.note,
    required this.receiptUrl,
    required this.confirmedAt,
    required this.disputedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRecorded => status == PaymentStatus.recorded;
  bool get isConfirmed => status == PaymentStatus.confirmed;
  bool get isDisputed => status == PaymentStatus.disputed;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] as String,
        assignmentId: json['assignment'] as String,
        payerId: json['payer'] as String?,
        payeeId: json['payee'] as String?,
        amount: _num(json['amount']) ?? 0,
        currency: json['currency'] as String? ?? 'UZS',
        method: json['method'] as String? ?? PaymentMethod.cash,
        status: json['status'] as String? ?? PaymentStatus.recorded,
        note: json['note'] as String? ?? '',
        receiptUrl: json['receipt_url'] as String? ?? '',
        confirmedAt: _date(json['confirmed_at']),
        disputedAt: _date(json['disputed_at']),
        createdAt: _date(json['created_at']) ?? DateTime.now(),
        updatedAt: _date(json['updated_at']),
      );
}

class PaymentMethod {
  static const String cash = 'cash';
  static const String cardTransfer = 'card_transfer';
  static const String click = 'click';
  static const String payme = 'payme';
  static const String other = 'other';

  static const values = [cash, cardTransfer, click, payme, other];
}

class PaymentStatus {
  static const String recorded = 'recorded';
  static const String confirmed = 'confirmed';
  static const String disputed = 'disputed';
}

num? _num(Object? raw) {
  if (raw is num) return raw;
  if (raw is String) return num.tryParse(raw);
  return null;
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
