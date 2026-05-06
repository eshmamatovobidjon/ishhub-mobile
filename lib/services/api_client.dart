import 'dart:math';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/constants.dart';
import 'storage_service.dart';

/// Thrown for any non-2xx response. Carries the IshHub error envelope:
///   {"error": {"code": "snake_case", "message": "human readable"}}
class ApiException implements Exception {
  final int statusCode;
  final String code;
  final String message;
  final String? requestId;
  ApiException(this.statusCode, this.code, this.message, {this.requestId});

  @override
  String toString() => requestId == null
      ? 'ApiException($statusCode, $code): $message'
      : 'ApiException($statusCode, $code, requestId=$requestId): $message';
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
          final requestId = _requestId();
          opts.headers['X-Request-ID'] ??= requestId;
          opts.extra['requestId'] = opts.headers['X-Request-ID'];
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
          final requestId = _responseRequestId(err);
          await Sentry.addBreadcrumb(
            Breadcrumb(
              category: 'http',
              type: 'http',
              level: SentryLevel.warning,
              message:
                  '${err.requestOptions.method} ${err.requestOptions.path}',
              data: {
                'status_code': res?.statusCode,
                'request_id': requestId,
              },
            ),
          );
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
                    requestId: requestId,
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
      _unwrap(() => _dio.get<T>(path, queryParameters: query));

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _unwrap(() => _dio.post<T>(path, data: data));

  Future<Response<T>> put<T>(String path, {Object? data}) =>
      _unwrap(() => _dio.put<T>(path, data: data));

  Future<Response<T>> patch<T>(String path, {Object? data}) =>
      _unwrap(() => _dio.patch<T>(path, data: data));

  Future<Response<T>> delete<T>(String path) =>
      _unwrap(() => _dio.delete<T>(path));

  Future<Response<T>> _unwrap<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final error = e.error;
      if (error is ApiException) throw error;
      rethrow;
    }
  }
}

String _responseRequestId(DioException err) {
  return err.response?.headers.value('x-request-id') ??
      err.requestOptions.extra['requestId']?.toString() ??
      '';
}

final Random _random = Random.secure();

String _requestId() {
  final now = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
  final suffix = List.generate(
    4,
    (_) => _random.nextInt(0x10000).toRadixString(16).padLeft(4, '0'),
  ).join();
  return 'm-$now-$suffix';
}
