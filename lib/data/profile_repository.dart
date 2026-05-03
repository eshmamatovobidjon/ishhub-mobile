import '../models/worker_profile.dart';
import '../services/api_client.dart';

class ProfileRepository {
  ProfileRepository(this._api);
  final ApiClient _api;

  Future<WorkerProfile?> myWorkerProfile() async {
    try {
      final r = await _api.get<Map<String, dynamic>>('/users/me/worker-profile/');
      return WorkerProfile.fromJson(r.data!);
    } on ApiException catch (e) {
      // Worker role inactive → no profile yet.
      if (e.statusCode == 404 || e.code == 'worker_role_inactive') return null;
      rethrow;
    }
  }

  Future<WorkerProfile> activateWorker({
    String? bio,
    num? defaultRate,
    String defaultRateUnit = 'hourly',
    List<String> skillIds = const [],
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/users/me/activate-worker/',
      data: {
        if (bio != null) 'bio': bio,
        if (defaultRate != null) 'default_rate': defaultRate,
        'default_rate_unit': defaultRateUnit,
        'skill_ids': skillIds,
      },
    );
    return WorkerProfile.fromJson(r.data!);
  }

  /// PUT /users/me/street-mode/
  Future<WorkerProfile> setStreetMode({
    required bool availableNow,
    int? radiusM,
    double? latitude,
    double? longitude,
  }) async {
    final r = await _api.put<Map<String, dynamic>>(
      '/users/me/street-mode/',
      data: {
        'available_now': availableNow,
        if (radiusM != null) 'available_radius_m': radiusM,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
    );
    return WorkerProfile.fromJson(r.data!);
  }
}
