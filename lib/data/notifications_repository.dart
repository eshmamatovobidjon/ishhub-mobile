import '../models/notification.dart';
import '../services/api_client.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);
  final ApiClient _api;

  Future<List<AppNotification>> list(
      {bool unreadOnly = false, int limit = 100}) async {
    final r = await _api.get<List<dynamic>>(
      '/notifications/',
      query: {
        if (unreadOnly) 'unread': 'true',
        'limit': limit,
      },
    );
    return (r.data ?? const [])
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<int> unreadCount() async {
    final r =
        await _api.get<Map<String, dynamic>>('/notifications/unread-count/');
    return (r.data?['count'] as int?) ?? 0;
  }

  Future<AppNotification> markRead(String id) async {
    final r = await _api.post<Map<String, dynamic>>('/notifications/$id/read/');
    return AppNotification.fromJson(r.data!);
  }

  Future<int> markAllRead() async {
    final r =
        await _api.post<Map<String, dynamic>>('/notifications/mark-all-read/');
    return (r.data?['updated'] as int?) ?? 0;
  }
}
