import 'rating.dart';
import 'skill.dart';
import 'worker_profile.dart';

class PublicUserSummary {
  final String id;
  final String? name;
  final String? avatarUrl;
  final String? city;
  final String? district;

  const PublicUserSummary({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.city,
    required this.district,
  });

  factory PublicUserSummary.fromJson(Map<String, dynamic> json) =>
      PublicUserSummary(
        id: json['id'] as String,
        name: json['name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        city: json['city'] as String?,
        district: json['district'] as String?,
      );
}

class NearbyWorker {
  final String workerId;
  final PublicUserSummary user;
  final WorkerProfile profile;
  final TrustScore? trustScore;
  final List<UserSkill> topSkills;
  final double score;
  final double distanceKm;
  final int skillOverlap;
  final bool availableNow;
  final String availabilityFreshness;
  final DateTime? lastLocationAt;

  const NearbyWorker({
    required this.workerId,
    required this.user,
    required this.profile,
    required this.trustScore,
    required this.topSkills,
    required this.score,
    required this.distanceKm,
    required this.skillOverlap,
    required this.availableNow,
    required this.availabilityFreshness,
    required this.lastLocationAt,
  });

  factory NearbyWorker.fromJson(Map<String, dynamic> json) => NearbyWorker(
        workerId: json['worker_id'] as String,
        user: PublicUserSummary.fromJson(json['user'] as Map<String, dynamic>),
        profile:
            WorkerProfile.fromJson(json['profile'] as Map<String, dynamic>),
        trustScore: json['trust_score'] is Map<String, dynamic>
            ? TrustScore.fromJson(json['trust_score'] as Map<String, dynamic>)
            : null,
        topSkills: (json['top_skills'] as List?)
                ?.map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        score: (json['score'] as num? ?? 0).toDouble(),
        distanceKm: (json['distance_km'] as num? ?? 0).toDouble(),
        skillOverlap: (json['skill_overlap'] as num? ?? 0).toInt(),
        availableNow: json['available_now'] as bool? ?? false,
        availabilityFreshness:
            json['availability_freshness'] as String? ?? 'unknown',
        lastLocationAt: _date(json['last_location_at']),
      );

  String get displayName =>
      user.name?.trim().isNotEmpty == true ? user.name!.trim() : '';

  String? get locality {
    final parts = [user.district, user.city]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
