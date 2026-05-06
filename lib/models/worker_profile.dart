import 'geo.dart';

class WorkerProfile {
  final String id;
  final String? bio;
  final num? defaultRate;
  final String defaultRateUnit; // hourly|fixed
  final bool availableNow;
  final int availableRadiusM;
  final DateTime? availableUntil;
  final DateTime? lastLocationAt;
  final GeoPoint? lastLocation;

  const WorkerProfile({
    required this.id,
    required this.bio,
    required this.defaultRate,
    required this.defaultRateUnit,
    required this.availableNow,
    required this.availableRadiusM,
    required this.availableUntil,
    required this.lastLocationAt,
    required this.lastLocation,
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) => WorkerProfile(
        id: json['id'] as String,
        bio: json['bio'] as String?,
        defaultRate: _num(json['default_rate']),
        defaultRateUnit: json['default_rate_unit'] as String? ?? 'hourly',
        availableNow: json['available_now'] as bool? ?? false,
        availableRadiusM: (json['available_radius_m'] as num?)?.toInt() ?? 5000,
        availableUntil: _date(json['available_until']),
        lastLocationAt: _date(json['last_location_at']),
        lastLocation: json['last_location'] is Map<String, dynamic>
            ? GeoPoint.fromJson(json['last_location'] as Map<String, dynamic>)
            : null,
      );
}

DateTime? _date(Object? v) =>
    v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;

num? _num(Object? v) {
  if (v is num) return v;
  if (v is String && v.isNotEmpty) return num.tryParse(v);
  return null;
}
