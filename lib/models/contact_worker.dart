import 'chat.dart';
import 'job.dart';

class ContactWorkerResult {
  final String workerId;
  final bool created;
  final Job job;
  final ChatThread thread;

  const ContactWorkerResult({
    required this.workerId,
    required this.created,
    required this.job,
    required this.thread,
  });

  factory ContactWorkerResult.fromJson(Map<String, dynamic> json) =>
      ContactWorkerResult(
        workerId: json['worker_id'] as String,
        created: json['created'] as bool? ?? false,
        job: Job.fromJson(json['job'] as Map<String, dynamic>),
        thread: ChatThread.fromJson(json['thread'] as Map<String, dynamic>),
      );
}
