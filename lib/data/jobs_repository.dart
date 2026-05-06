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

  Future<Job> cancelJob(String jobId, {String reason = ''}) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/jobs/$jobId/cancel/',
      data: {if (reason.isNotEmpty) 'reason': reason},
    );
    return Job.fromJson(r.data!);
  }

  /// Jobs created by the current user (any status).
  /// `GET /jobs/?creator=me`
  Future<List<Job>> myJobs() async {
    final r = await _api.get<dynamic>('/jobs/', query: {'creator': 'me'});
    final raw = r.data;
    // The endpoint is paginated; accept both shapes.
    final List items = raw is Map<String, dynamic>
        ? (raw['results'] as List? ?? const [])
        : (raw as List? ?? const []);
    return items
        .map((e) => Job.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Jobs assigned to the current worker.
  /// `GET /assignments/me/?scope=active|history|all`
  Future<List<WorkerAssignment>> myAssignments(
      {String scope = 'active'}) async {
    final r = await _api.get<List<dynamic>>(
      '/assignments/me/',
      query: {'scope': scope},
    );
    return (r.data ?? const [])
        .map((e) => WorkerAssignment.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
