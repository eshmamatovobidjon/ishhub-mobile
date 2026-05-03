import '../models/job.dart';
import '../services/api_client.dart';

class JobsRepository {
  JobsRepository(this._api);
  final ApiClient _api;

  /// Worker feed: ranked open jobs near me.
  /// `GET /workers/me/feed/?radius_km=&limit=&category=&q=`
  Future<List<JobMatch>> workerFeed({
    double radiusKm = 15,
    int limit = 20,
    String? category,
    String? query,
  }) async {
    final r = await _api.get<List<dynamic>>(
      '/workers/me/feed/',
      query: {
        'radius_km': radiusKm,
        'limit': limit,
        if (category != null) 'category': category,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
    return (r.data ?? const [])
        .map((e) => JobMatch.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Open jobs filter (used as a fallback when worker role isn't active or for clients).
  /// `GET /jobs/?status=open&category=&near=lat,lng,radius_m`
  Future<List<Job>> listJobs({
    String? status = 'open',
    String? category,
    double? lat,
    double? lng,
    int? radiusM,
  }) async {
    final near = (lat != null && lng != null && radiusM != null)
        ? '$lat,$lng,$radiusM'
        : null;
    final r = await _api.get<List<dynamic>>(
      '/jobs/',
      query: {
        if (status != null) 'status': status,
        if (category != null) 'category': category,
        if (near != null) 'near': near,
      },
    );
    return (r.data ?? const [])
        .map((e) => Job.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Job> jobDetail(String jobId) async {
    final r = await _api.get<Map<String, dynamic>>('/jobs/$jobId/');
    return Job.fromJson(r.data!);
  }
}
