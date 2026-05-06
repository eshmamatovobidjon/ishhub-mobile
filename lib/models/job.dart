import 'geo.dart';
import 'payment.dart';
import 'rating.dart';

/// Maps onto JobListSerializer for feed/list and JobSerializer for detail.
/// Detail-only fields are nullable so one class serves both shapes.
class Job {
  final String id;
  final String? creatorId; // detail only
  final String kind; // request | offer
  final String
      status; // open|matching|assigned|in_progress|completed|cancelled|disputed
  final String title;
  final String? category;
  final String urgency; // flexible|today|urgent
  final String pricingModel; // fixed|hourly|negotiable
  final num? budget;
  final num? hourlyRate;
  final String budgetCurrency;
  final String? displayPrice;
  final GeoPoint location;
  final String? address;
  final DateTime? scheduledFor;
  final int workersNeeded;
  final DateTime createdAt;

  // Detail-only (nullable when coming from list)
  final String? description;
  final String? city;
  final String? district;
  final List<String> skillTags;
  final num? aiConfidence;
  final List<JobAssignment> assignments;

  const Job({
    required this.id,
    required this.creatorId,
    required this.kind,
    required this.status,
    required this.title,
    required this.category,
    required this.urgency,
    required this.pricingModel,
    required this.budget,
    required this.hourlyRate,
    required this.budgetCurrency,
    required this.displayPrice,
    required this.location,
    required this.address,
    required this.scheduledFor,
    required this.workersNeeded,
    required this.createdAt,
    this.description,
    this.city,
    this.district,
    this.skillTags = const [],
    this.aiConfidence,
    this.assignments = const [],
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      creatorId: json['creator'] as String?,
      kind: json['kind'] as String? ?? 'request',
      status: json['status'] as String? ?? 'open',
      title: json['title'] as String? ?? '',
      category: json['category'] as String?,
      urgency: json['urgency'] as String? ?? 'flexible',
      pricingModel: json['pricing_model'] as String? ?? 'negotiable',
      budget: json['budget'] is String
          ? num.tryParse(json['budget'] as String)
          : json['budget'] as num?,
      hourlyRate: json['hourly_rate'] is String
          ? num.tryParse(json['hourly_rate'] as String)
          : json['hourly_rate'] as num?,
      budgetCurrency: json['budget_currency'] as String? ?? 'UZS',
      displayPrice: json['display_price'] as String?,
      location: GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
      scheduledFor: _parseDate(json['scheduled_for']),
      workersNeeded: json['workers_needed'] as int? ?? 1,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      description: json['description'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      skillTags:
          (json['skill_tags'] as List?)?.map((e) => e as String).toList() ??
              const [],
      aiConfidence: json['ai_confidence'] as num?,
      assignments: (json['assignments'] as List?)
              ?.map((e) => JobAssignment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class JobAssignment {
  final String id;
  final String workerId;
  final String workerPhone;
  final String status; // pending|arrived|in_progress|completed|cancelled
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? doneAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final num? finalAmount;
  final Payment? payment;
  final List<Rating> ratings;

  const JobAssignment({
    required this.id,
    required this.workerId,
    required this.workerPhone,
    required this.status,
    required this.arrivedAt,
    required this.startedAt,
    required this.doneAt,
    required this.completedAt,
    required this.cancelledAt,
    required this.finalAmount,
    this.payment,
    this.ratings = const [],
  });

  factory JobAssignment.fromJson(Map<String, dynamic> json) => JobAssignment(
        id: json['id'] as String,
        workerId: json['worker_id'] as String,
        workerPhone: json['worker_phone'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
        arrivedAt: _parseDate(json['arrived_at']),
        startedAt: _parseDate(json['started_at']),
        doneAt: _parseDate(json['done_at']),
        completedAt: _parseDate(json['completed_at']),
        cancelledAt: _parseDate(json['cancelled_at']),
        finalAmount: json['final_amount'] is String
            ? num.tryParse(json['final_amount'] as String)
            : json['final_amount'] as num?,
        payment: json['payment'] is Map<String, dynamic>
            ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
            : null,
        ratings: (json['ratings'] as List?)
                ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  bool hasRated(String userId) => ratings.any((r) => r.raterId == userId);
}

class WorkerAssignment {
  final JobAssignment assignment;
  final Job job;

  const WorkerAssignment({
    required this.assignment,
    required this.job,
  });

  String get id => assignment.id;
  String get status => assignment.status;

  factory WorkerAssignment.fromJson(Map<String, dynamic> json) =>
      WorkerAssignment(
        assignment: JobAssignment.fromJson(json),
        job: Job.fromJson(json['job'] as Map<String, dynamic>),
      );
}

/// Worker feed entry: a Job plus match metadata.
class JobMatch {
  final Job job;
  final double score;
  final double distanceKm;
  final bool distanceKnown;
  final int skillOverlap;
  final double embeddingSimilarity;

  const JobMatch({
    required this.job,
    required this.score,
    required this.distanceKm,
    required this.distanceKnown,
    required this.skillOverlap,
    required this.embeddingSimilarity,
  });

  factory JobMatch.fromJson(Map<String, dynamic> json) => JobMatch(
        job: Job.fromJson(json['job'] as Map<String, dynamic>),
        score: (json['score'] as num).toDouble(),
        distanceKm: (json['distance_km'] as num).toDouble(),
        distanceKnown: json['distance_known'] as bool? ?? true,
        skillOverlap: (json['skill_overlap'] as num).toInt(),
        embeddingSimilarity:
            (json['embedding_similarity'] as num? ?? 0).toDouble(),
      );
}

DateTime? _parseDate(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
