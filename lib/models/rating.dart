class Rating {
  final String id;
  final String assignmentId;
  final String raterId;
  final String raterPhone;
  final String rateeId;
  final String direction;
  final int stars;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const Rating({
    required this.id,
    required this.assignmentId,
    required this.raterId,
    required this.raterPhone,
    required this.rateeId,
    required this.direction,
    required this.stars,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json['id'] as String,
        assignmentId: json['assignment'] as String,
        raterId: json['rater'] as String,
        raterPhone: json['rater_phone'] as String? ?? '',
        rateeId: json['ratee'] as String,
        direction: json['direction'] as String? ?? '',
        stars: json['stars'] as int? ?? 0,
        comment: json['comment'] as String? ?? '',
        tags: (json['tags'] as List?)?.map((e) => e as String).toList() ??
            const [],
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

class TrustScore {
  final double score;
  final double avgRating;
  final int ratingCount;
  final int completedJobs;
  final int cancelledJobs;
  final double completionRate;
  final int disputesAgainst;
  final int disputesLost;
  final bool identityVerified;
  final bool phoneVerified;
  final bool orgVerified;
  final DateTime? updatedAt;

  const TrustScore({
    required this.score,
    required this.avgRating,
    required this.ratingCount,
    required this.completedJobs,
    required this.cancelledJobs,
    required this.completionRate,
    required this.disputesAgainst,
    required this.disputesLost,
    required this.identityVerified,
    required this.phoneVerified,
    required this.orgVerified,
    required this.updatedAt,
  });

  factory TrustScore.fromJson(Map<String, dynamic> json) => TrustScore(
        score: (json['score'] as num? ?? 0).toDouble(),
        avgRating: (json['avg_rating'] as num? ?? 0).toDouble(),
        ratingCount: json['rating_count'] as int? ?? 0,
        completedJobs: json['completed_jobs'] as int? ?? 0,
        cancelledJobs: json['cancelled_jobs'] as int? ?? 0,
        completionRate: (json['completion_rate'] as num? ?? 0).toDouble(),
        disputesAgainst: json['disputes_against'] as int? ?? 0,
        disputesLost: json['disputes_lost'] as int? ?? 0,
        identityVerified: json['identity_verified'] as bool? ?? false,
        phoneVerified: json['phone_verified'] as bool? ?? true,
        orgVerified: json['org_verified'] as bool? ?? false,
        updatedAt: _date(json['updated_at']),
      );
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
