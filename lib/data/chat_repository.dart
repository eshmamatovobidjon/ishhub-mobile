import '../models/chat.dart';
import '../services/api_client.dart';

class ChatRepository {
  ChatRepository(this._api);
  final ApiClient _api;

  Future<List<ChatThread>> threads() async {
    final r = await _api.get<List<dynamic>>('/threads/');
    return (r.data ?? const [])
        .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<ChatThread> openThread({
    required String jobId,
    required String workerId,
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/threads/',
      data: {'job_id': jobId, 'worker_id': workerId},
    );
    return ChatThread.fromJson(r.data!);
  }

  Future<List<ChatMessage>> messages(String threadId) async {
    final r = await _api.get<List<dynamic>>('/threads/$threadId/messages/');
    return (r.data ?? const [])
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<ChatMessage> postText(String threadId, String body) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/threads/$threadId/messages/',
      data: {'kind': 'text', 'body': body},
    );
    return ChatMessage.fromJson(r.data!);
  }

  Future<ChatMessage> postMedia({
    required String threadId,
    required String kind, // voice | image
    required String mediaUrl,
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/threads/$threadId/messages/',
      data: {'kind': kind, 'media_url': mediaUrl},
    );
    return ChatMessage.fromJson(r.data!);
  }
}
