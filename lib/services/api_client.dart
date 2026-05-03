import 'package:dio/dio.dart';
import '../config/constants.dart';
import 'storage_service.dart';

/// Thrown for any non-2xx response. Carries the IshHub error envelope:
///   {"error": {"code": "snake_case", "message": "human readable"}}
class ApiException implements Exception {
  final int statusCode;
  final String code;
  final String message;
  ApiException(this.statusCode, this.code, this.message);

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// Single Dio instance with auth + error-envelope interceptor.
/// Auto-attempts a refresh on 401 once per request.
class ApiClient {
  ApiClient({required TokenStorage tokens, Dio? dio})
      : _tokens = tokens,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.apiBase,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
                contentType: 'application/json',
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (opts, handler) async {
          final access = await _tokens.readAccess();
          if (access != null && opts.headers['Authorization'] == null) {
            opts.headers['Authorization'] = 'Bearer $access';
          }
          handler.next(opts);
        },
        onError: (err, handler) async {
          // Try one refresh on 401 (skip the auth endpoints themselves).
          final path = err.requestOptions.path;
          final isAuthCall = path.contains('/auth/');
          if (err.response?.statusCode == 401 &&
              !isAuthCall &&
              err.requestOptions.extra['retried'] != true) {
            final refresh = await _tokens.readRefresh();
            if (refresh != null) {
              try {
                final r = await _dio.post(
                  '/auth/refresh/',
                  data: {'refresh': refresh},
                  options: Options(extra: {'retried': true}),
                );
                final newAccess = r.data['access'] as String;
                await _tokens.writeAccess(newAccess);
                final retryOpts = err.requestOptions
                  ..headers['Authorization'] = 'Bearer $newAccess'
                  ..extra['retried'] = true;
                final retryRes = await _dio.fetch(retryOpts);
                return handler.resolve(retryRes);
              } catch (_) {
                await _tokens.clear();
              }
            }
          }
          // Convert to ApiException for predictable surface.
          final res = err.response;
          if (res != null && res.data is Map) {
            final envelope =
                (res.data as Map)['error'] as Map<String, dynamic>?;
            if (envelope != null) {
              return handler.reject(
                DioException(
                  requestOptions: err.requestOptions,
                  response: res,
                  error: ApiException(
                    res.statusCode ?? 0,
                    envelope['code'] as String? ?? 'unknown',
                    envelope['message'] as String? ?? 'Request failed',
                  ),
                ),
              );
            }
          }
          return handler.next(err);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokens;

  Dio get raw => _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
      _dio.get<T>(path, queryParameters: query);

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(String path, {Object? data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
}
