import '../models/payment.dart';
import '../services/api_client.dart';

class PaymentsRepository {
  PaymentsRepository(this._api);
  final ApiClient _api;

  Future<Payment> record({
    required String assignmentId,
    required num amount,
    required String method,
    String note = '',
    String receiptUrl = '',
  }) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/payments/',
      data: {
        'assignment_id': assignmentId,
        'amount': amount.toString(),
        'method': method,
        if (note.isNotEmpty) 'note': note,
        if (receiptUrl.isNotEmpty) 'receipt_url': receiptUrl,
      },
    );
    return Payment.fromJson(r.data!);
  }

  Future<Payment> confirm(String paymentId) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/payments/$paymentId/confirm/',
    );
    return Payment.fromJson(r.data!);
  }

  Future<Payment> dispute(String paymentId, {String reason = ''}) async {
    final r = await _api.post<Map<String, dynamic>>(
      '/payments/$paymentId/dispute/',
      data: {if (reason.isNotEmpty) 'reason': reason},
    );
    return Payment.fromJson(r.data!);
  }
}
