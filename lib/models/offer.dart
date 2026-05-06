import 'rating.dart';
import 'skill.dart';

/// Mirrors `apps.offers.serializers.OfferSerializer`.
class Offer {
  final String id;
  final String jobId;
  final String senderId;
  final String recipientId;
  final String direction; // client_to_worker | worker_to_client
  final String
      status; // sent | accepted | declined | countered | withdrawn | expired
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
  final OfferPartySummary? senderSummary;
  final OfferPartySummary? recipientSummary;

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
    required this.senderSummary,
    required this.recipientSummary,
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
      durationEstimateHours:
          (json['duration_estimate_hours'] as num?)?.toDouble(),
      note: json['note'] as String? ?? '',
      parentOfferId: json['parent_offer'] as String?,
      expiresAt: _date(json['expires_at']),
      respondedAt: _date(json['responded_at']),
      createdAt: _date(json['created_at']) ?? DateTime.now(),
      senderSummary: json['sender_summary'] is Map<String, dynamic>
          ? OfferPartySummary.fromJson(
              json['sender_summary'] as Map<String, dynamic>,
            )
          : null,
      recipientSummary: json['recipient_summary'] is Map<String, dynamic>
          ? OfferPartySummary.fromJson(
              json['recipient_summary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  OfferPartySummary? get workerSummary =>
      direction == 'worker_to_client' ? senderSummary : recipientSummary;
}

class OfferPartySummary {
  final String id;
  final String? name;
  final String? avatarUrl;
  final String? city;
  final String? district;
  final OfferWorkerProfileSummary? workerProfile;
  final TrustScore? trustScore;

  const OfferPartySummary({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.city,
    required this.district,
    required this.workerProfile,
    required this.trustScore,
  });

  factory OfferPartySummary.fromJson(Map<String, dynamic> json) {
    return OfferPartySummary(
      id: json['id'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      workerProfile: json['worker_profile'] is Map<String, dynamic>
          ? OfferWorkerProfileSummary.fromJson(
              json['worker_profile'] as Map<String, dynamic>,
            )
          : null,
      trustScore: json['trust_score'] is Map<String, dynamic>
          ? TrustScore.fromJson(json['trust_score'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OfferWorkerProfileSummary {
  final String id;
  final String? bio;
  final num? defaultRate;
  final String defaultRateUnit;
  final bool availableNow;
  final List<UserSkill> skills;

  const OfferWorkerProfileSummary({
    required this.id,
    required this.bio,
    required this.defaultRate,
    required this.defaultRateUnit,
    required this.availableNow,
    required this.skills,
  });

  factory OfferWorkerProfileSummary.fromJson(Map<String, dynamic> json) {
    return OfferWorkerProfileSummary(
      id: json['id'] as String,
      bio: json['bio'] as String?,
      defaultRate: _num(json['default_rate']),
      defaultRateUnit: json['default_rate_unit'] as String? ?? 'hourly',
      availableNow: json['available_now'] as bool? ?? false,
      skills: (json['skills'] as List?)
              ?.map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

DateTime? _date(Object? v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}

num? _num(Object? v) {
  if (v is num) return v;
  if (v is String && v.isNotEmpty) return num.tryParse(v);
  return null;
}
