import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/job_draft.dart';
import '../../providers/draft_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/snack.dart';

/// Step 2 of the composer: poll the draft, render the AI extraction
/// editable, then publish.
class DraftReviewScreen extends ConsumerStatefulWidget {
  final String draftId;
  const DraftReviewScreen({super.key, required this.draftId});

  @override
  ConsumerState<DraftReviewScreen> createState() => _DraftReviewScreenState();
}

class _DraftReviewScreenState extends ConsumerState<DraftReviewScreen> {
  // Must match JOB_EXTRACT_SCHEMA.category enum in apps/ai/prompts.py.
  static const _categories = <String>[
    'cleaning',
    'construction',
    'repair',
    'delivery',
    'farming',
    'gardening',
    'painting',
    'cooking',
    'teaching',
    'design',
    'loading',
    'other',
  ];

  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _budget = TextEditingController();
  String _category = 'other';
  String _urgency = 'flexible';
  String _pricingModel = 'fixed';
  int _workersNeeded = 1;
  bool _hydrated = false;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _budget.dispose();
    super.dispose();
  }

  void _hydrate(JobDraft d) {
    if (_hydrated) return;
    final ex = d.extracted;
    _title.text = (ex['title'] as String?) ?? '';
    _description.text =
        (ex['description'] as String?) ?? d.textInput ?? d.transcript ?? '';
    final cat = (ex['category'] as String?) ?? 'other';
    _category = _categories.contains(cat) ? cat : 'other';
    _urgency = (ex['urgency'] as String?) ?? 'flexible';
    final pm = (ex['pricing_model'] as String?) ?? 'fixed';
    _pricingModel =
        const {'fixed', 'hourly', 'negotiable'}.contains(pm) ? pm : 'fixed';
    final budget = ex['budget'];
    if (budget is num) _budget.text = budget.toString();
    final wn = ex['workers_needed'];
    if (wn is int && wn > 0) _workersNeeded = wn;
    _hydrated = true;
  }

  void _openGallery(List<String> urls, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) =>
            _PhotoGallery(urls: urls, initialIndex: initialIndex),
      ),
    );
  }

  Future<void> _publish() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final overrides = <String, dynamic>{
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'category': _category,
        'urgency': _urgency,
        'pricing_model': _pricingModel,
        'workers_needed': _workersNeeded,
      };
      final budget = num.tryParse(_budget.text.trim());
      if (budget != null) overrides['budget'] = budget;

      final job = await ref.read(draftsRepositoryProvider).publish(
            draftId: widget.draftId,
            overrides: overrides,
          );
      if (!mounted) return;
      showSnack(context, AppLocalizations.of(context).draftPublished);
      context.pushReplacement('/jobs/${job.id}');
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).commonNetworkError,
            error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(draftPollProvider(widget.draftId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.draftReviewTitle)),
      body: state.when(
        loading: () => const _ProcessingView(),
        error: (e, _) => _ErrorView(
          message: e is ApiException ? e.message : e.toString(),
          onRetry: () =>
              ref.read(draftPollProvider(widget.draftId).notifier).retry(),
        ),
        data: (d) {
          if (d.isProcessing) return const _ProcessingView();
          if (d.isFailed) {
            return _ErrorView(
              message: d.errorMessage ?? l10n.draftAiFailed,
              onRetry: () =>
                  ref.read(draftPollProvider(widget.draftId).notifier).retry(),
            );
          }
          _hydrate(d);
          return _buildForm(context, d);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, JobDraft d) {
    final l10n = AppLocalizations.of(context);
    final confidence = d.aiConfidence;
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (confidence != null)
            _ConfidenceChip(confidence: confidence.toDouble()),
          const SizedBox(height: 12),
          TextFormField(
            controller: _title,
            decoration: InputDecoration(labelText: l10n.draftTitleLabel),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.draftTitleRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            decoration: InputDecoration(labelText: l10n.draftDescriptionLabel),
            maxLines: 5,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: InputDecoration(labelText: l10n.draftCategoryLabel),
            items: [
              for (final category in _categories)
                DropdownMenuItem(
                  value: category,
                  child: Text(_categoryLabel(l10n, category)),
                ),
            ],
            onChanged: (v) => setState(() => _category = v ?? 'other'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _urgency,
            decoration: InputDecoration(labelText: l10n.draftUrgencyLabel),
            items: [
              DropdownMenuItem(
                value: 'flexible',
                child: Text(l10n.urgencyFlexible),
              ),
              DropdownMenuItem(value: 'today', child: Text(l10n.urgencyToday)),
              DropdownMenuItem(
                value: 'urgent',
                child: Text(l10n.urgencyUrgent),
              ),
            ],
            onChanged: (v) => setState(() => _urgency = v ?? 'flexible'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _pricingModel,
            decoration: InputDecoration(labelText: l10n.draftPricingLabel),
            items: [
              DropdownMenuItem(value: 'fixed', child: Text(l10n.pricingFixed)),
              DropdownMenuItem(
                  value: 'hourly', child: Text(l10n.pricingHourly)),
              DropdownMenuItem(
                value: 'negotiable',
                child: Text(l10n.pricingNegotiable),
              ),
            ],
            onChanged: (v) => setState(() => _pricingModel = v ?? 'fixed'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _budget,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _pricingModel == 'hourly'
                  ? l10n.draftHourlyRateLabel
                  : _pricingModel == 'negotiable'
                      ? l10n.draftEstimatedBudgetLabel
                      : l10n.draftBudgetLabel,
              helperText: _pricingModel == 'negotiable'
                  ? l10n.draftNegotiableBudgetHelp
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration:
                InputDecoration(labelText: l10n.draftWorkersNeededLabel),
            child: Row(
              children: [
                IconButton(
                  onPressed: _workersNeeded > 1
                      ? () => setState(() => _workersNeeded--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_workersNeeded',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _workersNeeded < 20
                      ? () => setState(() => _workersNeeded++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          if (d.photoUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.draftPhotosLabel),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 0; i < d.photoUrls.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _openGallery(d.photoUrls, i),
                        child: Hero(
                          tag: 'draft-photo-${d.photoUrls[i]}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              d.photoUrls[i],
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 96,
                                height: 96,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy ? null : _publish,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.publish),
              label: Text(l10n.draftPublish),
            ),
          ),
        ],
      ),
    );
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

class _ProcessingView extends StatelessWidget {
  const _ProcessingView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l10n.draftProcessingTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.draftProcessingSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function()? onRetry;
  const _ErrorView({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context).asyncRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConfidenceChip extends StatelessWidget {
  final double confidence;
  const _ConfidenceChip({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pct = (confidence * 100).round();
    final color = confidence >= 0.75
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.errorContainer;
    final on = confidence >= 0.75
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onErrorContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 16, color: on),
          const SizedBox(width: 6),
          Text(l10n.draftConfidence(pct), style: TextStyle(color: on)),
        ],
      ),
    );
  }
}

class _PhotoGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const _PhotoGallery({required this.urls, required this.initialIndex});

  @override
  State<_PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<_PhotoGallery> {
  late final PageController _ctrl =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).galleryTitle(
            _index + 1,
            widget.urls.length,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.urls.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) {
          final url = widget.urls[i];
          return Center(
            child: Hero(
              tag: 'draft-photo-$url',
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
