import '../models/job.dart';
import '../models/job_draft.dart';
import '../services/api_client.dart';

class DraftsRepository {
  DraftsRepository(this._api);
  final ApiClient _api;

  /// Create a draft. Backend will schedule AI extraction async.
  Future<JobDraft> createDraft({
    required double latitude,
    required double longitude,
    String address = '',
    String textInput = '',
    String voiceUrl = '',
    List<String> photoUrls = const [],
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/jobs/draft/',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        if (textInput.isNotEmpty) 'text_input': textInput,
        if (voiceUrl.isNotEmpty) 'voice_url': voiceUrl,
        if (photoUrls.isNotEmpty) 'photo_urls': photoUrls,
      },
    );
    return JobDraft.fromJson(r.data!);
  }

  Future<JobDraft> draft(String draftId) async {
    final r = await _api.get<Map<String, dynamic>>('/jobs/drafts/$draftId/');
    return JobDraft.fromJson(r.data!);
  }

  /// Publish with optional overrides. Returns the created Job.
  Future<Job> publish({
    required String draftId,
    Map<String, dynamic> overrides = const {},
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/jobs/drafts/$draftId/publish/',
      data: overrides,
    );
    return Job.fromJson(r.data!);
  }
}
