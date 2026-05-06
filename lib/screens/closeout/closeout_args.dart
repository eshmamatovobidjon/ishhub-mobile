import '../../models/job.dart';

class AssignmentCloseoutArgs {
  final Job job;
  final JobAssignment assignment;
  final bool isWorker;

  const AssignmentCloseoutArgs({
    required this.job,
    required this.assignment,
    required this.isWorker,
  });
}
