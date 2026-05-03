/// Mirrors `apps.offers.serializers.OfferSerializer`.
class Offer {
  final String id;
  final String jobId;
  final String senderId;
  final String recipientId;
  final String direction; // client_to_worker | worker_to_client
  final String status;    // sent | accepted | declined | countered | withdrawn | expired
  final String pricingModel; // fixed | hourly | negotiable
  final num? amount;
  final String currency;
  final DateTime? proposedStart;
  final double? durationEstimateHours;
  final String note;
  final String? parentOfferId;
  final DateTime? expiresAt;
  final DateTime? respondedAt;
  final DateTime createdAt;

  const Offer({
    required this.id,
    required this.jobId,
    required this.senderId,
    required this.recipientId,
    required this.direction,
    required this.status,
    required this.pricingModel,
    required this.amount,
    required this.currency,
    required this.proposedStart,
    required this.durationEstimateHours,
    required this.note,
    required this.parentOfferId,
    required this.expiresAt,
    required this.respondedAt,
    required this.createdAt,
  });

  bool get isOpen => status == 'sent';
  bool get isAccepted => status == 'accepted';

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      jobId: json['job'] as String,
      senderId: json['sender'] as String,
      recipientId: json['recipient'] as String,
      direction: json['direction'] as String? ?? 'worker_to_client',
      status: json['status'] as String? ?? 'sent',
      pricingModel: json['pricing_model'] as String? ?? 'negotiable',
      amount: json['amount'] is String
          ? num.tryParse(json['amount'] as String)
          : json['amount'] as num?,
      currency: json['currency'] as String? ?? 'UZS',
      proposedStart: _date(json['proposed_start']),
      durationEstimateHours: (json['duration_estimate_hours'] as num?)?.toDouble(),
      note: json['note'] as String? ?? '',
      parentOfferId: json['parent_offer'] as String?,
      expiresAt: _date(json['expires_at']),
      respondedAt: _date(json['responded_at']),
      createdAt: _date(json['created_at']) ?? DateTime.now(),
    );
  }
}

DateTime? _date(Object? v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}
