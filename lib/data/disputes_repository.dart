import '../models/dispute.dart';
import '../services/api_client.dart';

class DisputesRepository {
  DisputesRepository(this._api);
  final ApiClient _api;

  Future<List<Dispute>> list({String? jobId}) async {
    final r = await _api.get<List<dynamic>>(
      '/disputes/',
      query: {if (jobId != null) 'job_id': jobId},
    );
    return (r.data ?? const [])
        .map((e) => Dispute.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Dispute> detail(String disputeId) async {
    final r = await _api.get<Map<String, dynamic>>('/disputes/$disputeId/');
    return Dispute.fromJson(r.data!);
  }

  Future<Dispute> open({
    required String jobId,
    required String againstUserId,
    required String reason,
    required String description,
    List<String> evidenceUrls = const [],
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/disputes/',
      data: {
        'job_id': jobId,
        'against_user_id': againstUserId,
        'reason': reason,
        'description': description,
        'evidence_urls': evidenceUrls,
      },
    );
    return Dispute.fromJson(r.data!);
  }
}
