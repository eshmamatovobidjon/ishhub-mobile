import '../models/nearby_worker.dart';
import '../services/api_client.dart';

class WorkerSearchRepository {
  WorkerSearchRepository(this._api);
  final ApiClient _api;

  Future<List<NearbyWorker>> nearbyWorkers({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    int limit = 30,
    String? category,
    String? skill,
    String? query,
  }) async {
    final r = await _api.get<List<dynamic>>(
      '/workers/nearby/',
      query: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (skill != null && skill.isNotEmpty) 'skill': skill,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
    return (r.data ?? const [])
        .map((e) => NearbyWorker.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
