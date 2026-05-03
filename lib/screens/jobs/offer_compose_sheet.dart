import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/snack.dart';

/// Bottom-sheet form: a worker proposes terms to the job creator.
///
/// On success, returns `true` to the caller so the parent can refresh the
/// offers list.
class OfferComposeSheet extends ConsumerStatefulWidget {
  final String jobId;
  final String recipientId;
  final String? defaultPricingModel;
  final num? suggestedAmount;

  const OfferComposeSheet({
    super.key,
    required this.jobId,
    required this.recipientId,
    this.defaultPricingModel,
    this.suggestedAmount,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String jobId,
    required String recipientId,
    String? defaultPricingModel,
    num? suggestedAmount,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: OfferComposeSheet(
          jobId: jobId,
          recipientId: recipientId,
          defaultPricingModel: defaultPricingModel,
          suggestedAmount: suggestedAmount,
        ),
      ),
    );
  }

  @override
  ConsumerState<OfferComposeSheet> createState() => _OfferComposeSheetState();
}

class _OfferComposeSheetState extends ConsumerState<OfferComposeSheet> {
  late String _pricingModel;
  final _amount = TextEditingController();
  final _hours = TextEditingController();
  final _note = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _pricingModel = widget.defaultPricingModel ?? 'fixed';
    if (widget.suggestedAmount != null) {
      _amount.text = widget.suggestedAmount!.toString();
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _hours.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = num.tryParse(_amount.text.trim());
    if (_pricingModel != 'negotiable' && (amount == null || amount <= 0)) {
      showSnack(context, 'Narxni kiriting', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(offersRepositoryProvider).create(
            jobId: widget.jobId,
            recipientId: widget.recipientId,
            pricingModel: _pricingModel,
            amount: amount,
            durationEstimateHours: double.tryParse(_hours.text.trim()),
            note: _note.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSnack(context, 'Taklif yuborildi');
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, 'Yuborib bo\u02bclmadi', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Taklif yuborish', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _pricingModel,
              decoration: const InputDecoration(labelText: 'Narx turi'),
              items: const [
                DropdownMenuItem(value: 'fixed', child: Text('Belgilangan')),
                DropdownMenuItem(value: 'hourly', child: Text('Soatlik')),
                DropdownMenuItem(
                    value: 'negotiable', child: Text('Kelishiladi')),
              ],
              onChanged: (v) => setState(() => _pricingModel = v ?? 'fixed'),
            ),
            const SizedBox(height: 12),
            if (_pricingModel != 'negotiable')
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _pricingModel == 'hourly'
                      ? 'Soatlik tarif (UZS)'
                      : 'Umumiy summa (UZS)',
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _hours,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Taxminiy soat (ixtiyoriy)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Izoh (ixtiyoriy)',
                hintText: 'masalan: Bugun soat 14:00 da kelaman',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Yuborish'),
            ),
          ],
        ),
      ),
    );
  }
}
