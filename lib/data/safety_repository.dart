import '../models/safety.dart';
import '../services/api_client.dart';

class SafetyRepository {
  SafetyRepository(this._api);
  final ApiClient _api;

  Future<List<UserBlockSummary>> blocks() async {
    final r = await _api.get<List<dynamic>>('/users/me/blocks/');
    return (r.data ?? const [])
        .map((e) => UserBlockSummary.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<UserBlockSummary> blockUser(
    String userId, {
    String reason = '',
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/users/$userId/block/',
      data: {if (reason.isNotEmpty) 'reason': reason},
    );
    return UserBlockSummary.fromJson(r.data!);
  }

  Future<void> unblockUser(String userId) async {
    await _api.delete<Map<String, dynamic>>('/users/$userId/block/');
  }

  Future<UserReportSummary> reportUser({
    required String userId,
    required String reason,
    String details = '',
    String? threadId,
    String? jobId,
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/users/$userId/report/',
      data: {
        'reason': reason,
        if (details.isNotEmpty) 'details': details,
        if (threadId != null) 'thread_id': threadId,
        if (jobId != null) 'job_id': jobId,
      },
    );
    return UserReportSummary.fromJson(r.data!);
  }
}
