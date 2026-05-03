import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';

class UploadedAsset {
  final String publicUrl;
  final String key;
  final String contentType;
  final String? localPath; // for thumbnail preview
  const UploadedAsset({
    required this.publicUrl,
    required this.key,
    required this.contentType,
    this.localPath,
  });
}

/// Two-step upload:
///   1. POST /media/presign-upload/  → server returns presigned PUT URL
///   2. PUT bytes directly to storage with the returned headers
///
/// Never proxies bytes through Django.
class MediaUploadService {
  MediaUploadService(this._api);
  final ApiClient _api;

  /// Upload a local file. `kind` is one of: voice|photo|document.
  Future<UploadedAsset> upload({
    required File file,
    required String kind,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    final filename = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : 'upload';

    final r = await _api.post<Map<String, dynamic>>(
      '/media/presign-upload/',
      data: {
        'kind': kind,
        'content_type': contentType,
        'filename': filename,
      },
    );
    final body = r.data!;
    final uploadUrl = body['upload_url'] as String;
    final publicUrl = body['public_url'] as String;
    final key = body['key'] as String;
    final headers = (body['headers'] as Map?)?.cast<String, dynamic>() ?? {};

    // Use a fresh Dio for the storage PUT — no auth header, raw bytes.
    final raw = Dio(BaseOptions(
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 2),
    ));
    final length = await file.length();
    final bytes = await file.readAsBytes();
    await raw.put<void>(
      uploadUrl,
      data: Stream.value(bytes),
      options: Options(
        headers: {
          ...headers,
          Headers.contentLengthHeader: length,
        },
      ),
      onSendProgress: (sent, total) {
        if (onProgress != null && total > 0) onProgress(sent / total);
      },
    );

    return UploadedAsset(
      publicUrl: publicUrl,
      key: key,
      contentType: contentType,
      localPath: file.path,
    );
  }
}
