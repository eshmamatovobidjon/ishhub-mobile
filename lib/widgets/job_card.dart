import 'package:flutter/material.dart';
import '../config/enums.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final double? distanceKm;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.distanceKm, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title.isEmpty ? '(nomsiz)' : job.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (job.urgency == Urgency.urgent)
                    _badge(context, 'Shoshilinch',
                        bg: theme.colorScheme.errorContainer,
                        fg: theme.colorScheme.onErrorContainer)
                  else if (job.urgency == Urgency.today)
                    _badge(context, 'Bugun',
                        bg: theme.colorScheme.tertiaryContainer,
                        fg: theme.colorScheme.onTertiaryContainer),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (job.category != null)
                    _meta(context, Icons.category_outlined, job.category!),
                  if (distanceKm != null)
                    _meta(context, Icons.place_outlined,
                        '${distanceKm!.toStringAsFixed(1)} km'),
                  if (job.address != null && job.address!.isNotEmpty)
                    _meta(context, Icons.map_outlined, job.address!),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    job.displayPrice ?? '—',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _timeAgo(job.createdAt),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String text,
      {required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }

  Widget _meta(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'hozir';
    if (d.inMinutes < 60) return '${d.inMinutes} daq';
    if (d.inHours < 24) return '${d.inHours} soat';
    if (d.inDays < 7) return '${d.inDays} kun';
    return '${(d.inDays / 7).floor()} hafta';
  }
}
