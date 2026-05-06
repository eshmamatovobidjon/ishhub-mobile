import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

final tokenStorageProvider = Provider<TokenStorage>((_) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokens: ref.watch(tokenStorageProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    api: ref.watch(apiClientProvider),
    tokens: ref.watch(tokenStorageProvider),
  );
});

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

class AuthSignedIn extends AuthState {
  final AppUser user;
  const AuthSignedIn(this.user);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthLoading()) {
    _bootstrap();
  }

  final Ref _ref;

  Future<void> _bootstrap() async {
    final tokens = _ref.read(tokenStorageProvider);
    final access = await tokens.readAccess();
    if (access == null) {
      state = const AuthSignedOut();
      return;
    }
    try {
      final user = await _ref.read(authServiceProvider).me();
      state = AuthSignedIn(user);
    } catch (_) {
      await tokens.clear();
      state = const AuthSignedOut();
    }
  }

  Future<void> sendOtp(String phone) =>
      _ref.read(authServiceProvider).sendOtp(phone);

  Future<void> verifyOtp({required String phone, required String code}) async {
    final user = await _ref.read(authServiceProvider).verifyOtp(
          phone: phone,
          code: code,
        );
    state = AuthSignedIn(user);
  }

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
    String? language,
    String? city,
    String? district,
    double? latitude,
    double? longitude,
  }) async {
    final user = await _ref.read(authServiceProvider).updateMe(
          name: name,
          avatarUrl: avatarUrl,
          language: language,
          city: city,
          district: district,
          latitude: latitude,
          longitude: longitude,
        );
    state = AuthSignedIn(user);
  }

  Future<void> refreshUser() async {
    final user = await _ref.read(authServiceProvider).me();
    state = AuthSignedIn(user);
  }

  Future<void> signOut() async {
    await _ref.read(authServiceProvider).signOut();
    state = const AuthSignedOut();
  }

  void setUser(AppUser user) {
    state = AuthSignedIn(user);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
