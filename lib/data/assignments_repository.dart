import '../models/job.dart';
import '../services/api_client.dart';

/// Calls the assignment-lifecycle endpoints. Each transition optionally takes
/// the worker's current GPS coords (used by the backend for geo-verification).
class AssignmentsRepository {
  AssignmentsRepository(this._api);
  final ApiClient _api;

  Future<Job> arrived(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'arrived', lat: lat, lng: lng);

  Future<Job> started(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'started', lat: lat, lng: lng);

  Future<Job> done(String assignmentId, {double? lat, double? lng}) =>
      _action(assignmentId, 'done', lat: lat, lng: lng);

  Future<Job> confirm(String assignmentId, {num? finalAmount}) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/assignments/$assignmentId/confirm/',
      data: {if (finalAmount != null) 'final_amount': finalAmount.toString()},
    );
    return Job.fromJson(r.data!);
  }

  Future<Job> _action(
    String assignmentId,
    String path, {
    double? lat,
    double? lng,
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/assignments/$assignmentId/$path/',
      data: {
        if (lat != null) 'latitude': lat,
        if (lng != null) 'longitude': lng,
      },
    );
    return Job.fromJson(r.data!);
  }
}
