import '../models/rating.dart';
import '../services/api_client.dart';

class RatingsRepository {
  RatingsRepository(this._api);
  final ApiClient _api;

  Future<Rating> submit({
    required String assignmentId,
    required int stars,
    String comment = '',
    List<String> tags = const [],
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/ratings/',
      data: {
        'assignment_id': assignmentId,
        'stars': stars,
        if (comment.isNotEmpty) 'comment': comment,
        'tags': tags,
      },
    );
    return Rating.fromJson(r.data!);
  }

  Future<List<Rating>> userRatings(String userId) async {
    final r = await _api.get<List<dynamic>>('/users/$userId/ratings/');
    return (r.data ?? const [])
        .map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<TrustScore> trustScore(String userId) async {
    final r = await _api.get<Map<String, dynamic>>(
      '/users/$userId/trust-score/',
    );
    return TrustScore.fromJson(r.data!);
  }
}
