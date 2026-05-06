import '../services/api_client.dart';

/// Calls the assignment-lifecycle endpoints. Each transition optionally takes
/// the worker's current GPS coords (used by the backend for geo-verification).
class AssignmentsRepository {
  AssignmentsRepository(this._api);
  final ApiClient _api;

  Future<void> arrived(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'arrived', lat: lat, lng: lng);

  Future<void> started(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'started', lat: lat, lng: lng);

  Future<void> done(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'done', lat: lat, lng: lng);

  Future<void> confirm(String assignmentId, {num? finalAmount}) async {
    await _api.post<Map<String, dynamic>>(
      '/assignments/$assignmentId/confirm/',
      data: {if (finalAmount != null) 'final_amount': finalAmount.toString()},
    );
  }

  Future<void> cancel(String assignmentId, {String reason = ''}) async {
    await _api.post<Map<String, dynamic>>(
      '/assignments/$assignmentId/cancel/',
      data: {if (reason.isNotEmpty) 'reason': reason},
    );
  }

  Future<void> _action(
    String assignmentId,
    String path, {
    double? lat,
    double? lng,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/assignments/$assignmentId/$path/',
      data: {
        if (lat != null) 'latitude': lat,
        if (lng != null) 'longitude': lng,
      },
    );
  }
}
