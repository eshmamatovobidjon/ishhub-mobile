import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/constants.dart';

/// Secure JWT storage backed by Keychain (iOS) / EncryptedSharedPreferences (Android).
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<String?> readAccess() => _storage.read(key: AppConstants.kAccessToken);
  Future<String?> readRefresh() =>
      _storage.read(key: AppConstants.kRefreshToken);

  Future<void> write({required String access, required String refresh}) async {
    await _storage.write(key: AppConstants.kAccessToken, value: access);
    await _storage.write(key: AppConstants.kRefreshToken, value: refresh);
  }

  Future<void> writeAccess(String access) =>
      _storage.write(key: AppConstants.kAccessToken, value: access);

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.kAccessToken);
    await _storage.delete(key: AppConstants.kRefreshToken);
  }
}
