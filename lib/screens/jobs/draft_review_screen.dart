import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _budget = TextEditingController();
  String _urgency = 'flexible';
  String _pricingModel = 'negotiable';
  bool _hydrated = false;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    _budget.dispose();
    super.dispose();
  }

  void _hydrate(JobDraft d) {
    if (_hydrated) return;
    final ex = d.extracted;
    _title.text = (ex['title'] as String?) ?? '';
    _description.text =
        (ex['description'] as String?) ?? d.textInput ?? d.transcript ?? '';
    _category.text = (ex['category'] as String?) ?? '';
    _urgency = (ex['urgency'] as String?) ?? 'flexible';
    _pricingModel = (ex['pricing_model'] as String?) ?? 'negotiable';
    final budget = ex['budget'];
    if (budget is num) _budget.text = budget.toString();
    _hydrated = true;
  }

  Future<void> _publish() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final overrides = <String, dynamic>{
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        if (_category.text.trim().isNotEmpty) 'category': _category.text.trim(),
        'urgency': _urgency,
        'pricing_model': _pricingModel,
      };
      final budget = num.tryParse(_budget.text.trim());
      if (budget != null) overrides['budget'] = budget;

      final job = await ref.read(draftsRepositoryProvider).publish(
            draftId: widget.draftId,
            overrides: overrides,
          );
      if (!mounted) return;
      showSnack(context, 'Ish e\u02bclon qilindi');
      context.pushReplacement('/jobs/${job.id}');
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, 'Tarmoq xatosi', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(draftPollProvider(widget.draftId));

    return Scaffold(
      appBar: AppBar(title: const Text('Ko\u02bcrib chiqish')),
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
              message: d.errorMessage ?? 'AI tahlili amalga oshmadi',
              onRetry: () => ref
                  .read(draftPollProvider(widget.draftId).notifier)
                  .retry(),
            );
          }
          _hydrate(d);
          return _buildForm(context, d);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, JobDraft d) {
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
            decoration: const InputDecoration(labelText: 'Sarlavha'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Sarlavha kerak' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Tavsif'),
            maxLines: 5,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _category,
            decoration: const InputDecoration(labelText: 'Kategoriya'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _urgency,
            decoration: const InputDecoration(labelText: 'Muddati'),
            items: const [
              DropdownMenuItem(value: 'flexible', child: Text('Erkin')),
              DropdownMenuItem(value: 'today', child: Text('Bugun')),
              DropdownMenuItem(value: 'urgent', child: Text('Shoshilinch')),
            ],
            onChanged: (v) => setState(() => _urgency = v ?? 'flexible'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _pricingModel,
            decoration: const InputDecoration(labelText: 'Narx turi'),
            items: const [
              DropdownMenuItem(value: 'fixed', child: Text('Belgilangan')),
              DropdownMenuItem(value: 'hourly', child: Text('Soatlik')),
              DropdownMenuItem(value: 'negotiable', child: Text('Kelishiladi')),
            ],
            onChanged: (v) => setState(() => _pricingModel = v ?? 'negotiable'),
          ),
          if (_pricingModel != 'negotiable') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _budget,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _pricingModel == 'hourly'
                    ? 'Soatlik tarif (UZS)'
                    : 'Byudjet (UZS)',
              ),
            ),
          ],
          if (d.photoUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Rasmlar'),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final url in d.photoUrls)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
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
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _publish,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.publish),
            label: const Text('E\u02bclon qilish'),
          ),
        ],
      ),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'AI ishingizni tahlil qilmoqda…',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu odatda 5\u201310 soniya oladi.',
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
                child: const Text('Qayta urinish'),
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
          Text('AI ishonchi: $pct%', style: TextStyle(color: on)),
        ],
      ),
    );
  }
}
