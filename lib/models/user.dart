import 'geo.dart';

class RoleFlags {
  final bool isClient;
  final bool isWorker;
  final bool isOrg;

  const RoleFlags({
    this.isClient = true,
    this.isWorker = false,
    this.isOrg = false,
  });

  factory RoleFlags.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RoleFlags();
    return RoleFlags(
      isClient: json['is_client'] as bool? ?? true,
      isWorker: json['is_worker'] as bool? ?? false,
      isOrg: json['is_org'] as bool? ?? false,
    );
  }
}

class AppUser {
  final String id;
  final String phone;
  final String? name;
  final String? avatarUrl;
  final String? language;
  final String? city;
  final String? district;
  final GeoPoint? location;
  final RoleFlags roles;

  const AppUser({
    required this.id,
    required this.phone,
    this.name,
    this.avatarUrl,
    this.language,
    this.city,
    this.district,
    this.location,
    this.roles = const RoleFlags(),
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        phone: json['phone'] as String,
        name: json['name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        language: json['language'] as String?,
        city: json['city'] as String?,
        district: json['district'] as String?,
        location: json['location'] is Map<String, dynamic>
            ? GeoPoint.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        roles: RoleFlags.fromJson(json['roles'] as Map<String, dynamic>?),
      );
}

class AuthTokens {
  final String access;
  final String refresh;

  const AuthTokens({required this.access, required this.refresh});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        access: json['access'] as String,
        refresh: json['refresh'] as String,
      );
}
