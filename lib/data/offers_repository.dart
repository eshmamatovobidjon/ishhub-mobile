import '../models/offer.dart';
import '../services/api_client.dart';

class OffersRepository {
  OffersRepository(this._api);
  final ApiClient _api;

  Future<List<Offer>> list({String? jobId}) async {
    final r = await _api.get<List<dynamic>>(
      '/offers/',
      query: {if (jobId != null) 'job_id': jobId},
    );
    return (r.data ?? const [])
        .map((e) => Offer.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Offer> create({
    required String jobId,
    required String recipientId,
    required String pricingModel,
    num? amount,
    DateTime? proposedStart,
    double? durationEstimateHours,
    String? note,
    String? parentOfferId,
    DateTime? expiresAt,
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/offers/',
      data: {
        'job_id': jobId,
        'recipient_id': recipientId,
        'pricing_model': pricingModel,
        if (amount != null) 'amount': amount.toString(),
        if (proposedStart != null)
          'proposed_start': proposedStart.toUtc().toIso8601String(),
        if (durationEstimateHours != null)
          'duration_estimate_hours': durationEstimateHours,
        if (note != null && note.isNotEmpty) 'note': note,
        if (parentOfferId != null) 'parent_offer_id': parentOfferId,
        if (expiresAt != null)
          'expires_at': expiresAt.toUtc().toIso8601String(),
      },
    );
    return Offer.fromJson(r.data!);
  }

  Future<Offer> _action(String id, String path) async {
    final r = await _api.post<Map<String, dynamic>>('/offers/$id/$path/');
    return Offer.fromJson(r.data!);
  }

  Future<Offer> accept(String id) => _action(id, 'accept');
  Future<Offer> decline(String id) => _action(id, 'decline');
  Future<Offer> withdraw(String id) => _action(id, 'withdraw');
}
