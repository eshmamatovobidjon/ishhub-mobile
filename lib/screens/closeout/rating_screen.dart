import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/snack.dart';
import 'closeout_args.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final AssignmentCloseoutArgs? args;
  const RatingScreen({super.key, required this.args});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _comment = TextEditingController();
  int _stars = 5;
  final Set<String> _tags = {};
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final args = widget.args;
    if (args == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(ratingsRepositoryProvider).submit(
            assignmentId: args.assignment.id,
            stars: _stars,
            comment: _comment.text.trim(),
            tags: _tags.toList(),
          );
      ref.invalidate(jobDetailProvider(args.job.id));
      if (!mounted) return;
      showSnack(context, AppLocalizations.of(context).ratingSubmitted);
      context.pop();
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted)
        showSnack(context, AppLocalizations.of(context).commonNetworkError,
            error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final args = widget.args;
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ratingTitle)),
        body: Center(child: Text(l10n.closeoutMissingContext)),
      );
    }
    final tags = args.isWorker
        ? {
            'clear_instructions': l10n.ratingTagClearInstructions,
            'respectful': l10n.ratingTagRespectful,
            'paid_on_time': l10n.ratingTagPaidOnTime,
          }
        : {
            'punctual': l10n.ratingTagPunctual,
            'skilled': l10n.ratingTagSkilled,
            'friendly': l10n.ratingTagFriendly,
            'would_hire_again': l10n.ratingTagWouldHireAgain,
          };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ratingTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(args.job.title,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() => _stars = i),
                    iconSize: 40,
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icon(i <= _stars ? Icons.star : Icons.star_border),
                  ),
              ],
            ),
            Center(child: Text(l10n.ratingStars(_stars))),
            const SizedBox(height: 20),
            Text(l10n.ratingTagsLabel,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in tags.entries)
                  FilterChip(
                    label: Text(entry.value),
                    selected: _tags.contains(entry.key),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _tags.add(entry.key);
                      } else {
                        _tags.remove(entry.key);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _comment,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(labelText: l10n.ratingCommentLabel),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.star),
              label: Text(l10n.ratingSubmitAction),
            ),
          ],
        ),
      ),
    );
  }
}
