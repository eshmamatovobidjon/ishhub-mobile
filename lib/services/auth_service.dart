import '../models/user.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  AuthService({required this.api, required this.tokens});

  final ApiClient api;
  final TokenStorage tokens;

  /// Request an OTP for the given phone (E.164, e.g. "+998901234567").
  Future<void> sendOtp(String phone) async {
    await api.post<dynamic>('/auth/send-otp/', data: {'phone': phone});
  }

  /// Verify the OTP. Persists tokens and returns the authenticated user.
  /// Backend returns: `{user: {...}, tokens: {access, refresh}}`.
  Future<AppUser> verifyOtp({required String phone, required String code}) async {
    final r = await api.post<Map<String, dynamic>>(
      '/auth/verify-otp/',
      data: {'phone': phone, 'code': code},
    );
    final body = r.data!;
    final t = AuthTokens.fromJson(body['tokens'] as Map<String, dynamic>);
    await tokens.write(access: t.access, refresh: t.refresh);
    return AppUser.fromJson(body['user'] as Map<String, dynamic>);
  }

  Future<AppUser> me() async {
    final r = await api.get<Map<String, dynamic>>('/users/me/');
    return AppUser.fromJson(r.data!);
  }

  Future<void> signOut() => tokens.clear();
}
