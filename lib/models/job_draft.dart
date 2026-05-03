import 'geo.dart';

/// Mirrors JobDraftSerializer. The `extracted` blob is the AI's draft job
/// payload — schema-validated server-side, but we treat it as a permissive
/// map and pull keys defensively for the review screen.
class JobDraft {
  final String id;
  final String status; // pending|extracting|ready|published|failed
  final String? voiceUrl;
  final List<String> photoUrls;
  final String? textInput;
  final String? address;
  final GeoPoint? location;
  final String? transcript;
  final String? detectedLanguage;
  final num? aiConfidence;
  final Map<String, dynamic> extracted;
  final String? errorMessage;
  final String? publishedJobId;
  final DateTime createdAt;

  const JobDraft({
    required this.id,
    required this.status,
    required this.voiceUrl,
    required this.photoUrls,
    required this.textInput,
    required this.address,
    required this.location,
    required this.transcript,
    required this.detectedLanguage,
    required this.aiConfidence,
    required this.extracted,
    required this.errorMessage,
    required this.publishedJobId,
    required this.createdAt,
  });

  bool get isReady => status == 'ready';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'pending' || status == 'extracting';

  factory JobDraft.fromJson(Map<String, dynamic> json) => JobDraft(
        id: json['id'] as String,
        status: json['status'] as String? ?? 'pending',
        voiceUrl: json['voice_url'] as String?,
        photoUrls: (json['photo_urls'] as List?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        textInput: json['text_input'] as String?,
        address: json['address'] as String?,
        location: json['location'] is Map<String, dynamic>
            ? GeoPoint.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        transcript: json['transcript'] as String?,
        detectedLanguage: json['detected_language'] as String?,
        aiConfidence: json['ai_confidence'] as num?,
        extracted:
            (json['extracted'] as Map?)?.cast<String, dynamic>() ?? const {},
        errorMessage: json['error_message'] as String?,
        publishedJobId: json['published_job'] as String?,
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
