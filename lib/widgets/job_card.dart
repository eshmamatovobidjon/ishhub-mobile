import 'package:flutter/material.dart';
import '../config/enums.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final double? distanceKm;
  final bool distanceKnown;
  final int? skillOverlap;
  final double? matchScore;
  final bool showOfferHint;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.job,
    this.distanceKm,
    this.distanceKnown = true,
    this.skillOverlap,
    this.matchScore,
    this.showOfferHint = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = job.title.isEmpty ? l10n.jobUntitled : job.title;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Semantics(
        button: onTap != null,
        label: title,
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
                        title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (job.urgency == Urgency.urgent)
                      _badge(context, l10n.urgencyUrgent,
                          bg: theme.colorScheme.errorContainer,
                          fg: theme.colorScheme.onErrorContainer)
                    else if (job.urgency == Urgency.today)
                      _badge(context, l10n.urgencyToday,
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
                      _meta(context, Icons.category_outlined,
                          _categoryLabel(l10n, job.category!)),
                    if (distanceKm != null && distanceKnown)
                      _meta(context, Icons.place_outlined,
                          '${distanceKm!.toStringAsFixed(1)} km'),
                    if (distanceKm != null && !distanceKnown)
                      _meta(context, Icons.public_outlined,
                          l10n.feedDistanceFallback),
                    if ((skillOverlap ?? 0) > 0)
                      _meta(context, Icons.handyman_outlined,
                          l10n.feedSkillMatch(skillOverlap!)),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (matchScore != null) ...[
                          Icon(Icons.auto_awesome,
                              size: 14, color: theme.colorScheme.outline),
                          const SizedBox(width: 4),
                          Text(
                            l10n.feedMatchScore(
                              (matchScore! * 100).clamp(0, 100).round(),
                            ),
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          _timeAgo(l10n, job.createdAt),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                if (showOfferHint) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.send_outlined,
                          size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.feedOpenToOffer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          size: 18, color: theme.colorScheme.primary),
                    ],
                  ),
                ],
              ],
            ),
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

  String _timeAgo(AppLocalizations l10n, DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return l10n.timeNow;
    if (d.inMinutes < 60) return l10n.timeMinutesAgo(d.inMinutes);
    if (d.inHours < 24) return l10n.timeHoursAgo(d.inHours);
    if (d.inDays < 7) return l10n.timeDaysAgo(d.inDays);
    return l10n.timeWeeksAgo((d.inDays / 7).floor());
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      'cleaning' => l10n.categoryCleaning,
      'construction' => l10n.categoryConstruction,
      'repair' => l10n.categoryRepair,
      'delivery' => l10n.categoryDelivery,
      'farming' => l10n.categoryFarming,
      'gardening' => l10n.categoryGardening,
      'painting' => l10n.categoryPainting,
      'cooking' => l10n.categoryCooking,
      'teaching' => l10n.categoryTeaching,
      'design' => l10n.categoryDesign,
      'loading' => l10n.categoryLoading,
      _ => l10n.categoryOther,
    };
  }
}
