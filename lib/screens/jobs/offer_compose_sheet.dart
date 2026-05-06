import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../utils/offer_input.dart';
import '../../widgets/snack.dart';

/// Bottom-sheet form: a worker proposes terms to the job creator.
///
/// On success, returns `true` to the caller so the parent can refresh the
/// offers list.
class OfferComposeSheet extends ConsumerStatefulWidget {
  final String jobId;
  final String recipientId;
  final String? jobTitle;
  final String? jobPriceLabel;
  final String? defaultPricingModel;
  final num? suggestedAmount;

  const OfferComposeSheet({
    super.key,
    required this.jobId,
    required this.recipientId,
    this.jobTitle,
    this.jobPriceLabel,
    this.defaultPricingModel,
    this.suggestedAmount,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String jobId,
    required String recipientId,
    String? jobTitle,
    String? jobPriceLabel,
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
          jobTitle: jobTitle,
          jobPriceLabel: jobPriceLabel,
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
  final _form = GlobalKey<FormState>();
  late String _pricingModel;
  final _amount = TextEditingController();
  final _hours = TextEditingController();
  final _note = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final dpm = widget.defaultPricingModel;
    // Offers must be concrete (fixed/hourly). If the parent job is negotiable,
    // default the offer to fixed and let the worker pick.
    _pricingModel = (dpm == 'fixed' || dpm == 'hourly') ? dpm! : 'fixed';
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
    final l10n = AppLocalizations.of(context);
    if (!(_form.currentState?.validate() ?? false)) return;
    final amount = parsePositiveAmount(_amount.text);
    setState(() => _busy = true);
    try {
      await ref.read(offersRepositoryProvider).create(
            jobId: widget.jobId,
            recipientId: widget.recipientId,
            pricingModel: _pricingModel,
            amount: amount,
            durationEstimateHours: parseOptionalPositiveHours(_hours.text),
            note: _note.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSnack(context, l10n.offerSent);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, l10n.offerSendFailed, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _appendNote(String text) {
    final current = _note.text.trim();
    _note.text = current.isEmpty ? text : '$current. $text';
    _note.selection = TextSelection.collapsed(offset: _note.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.offerComposeTitle, style: theme.textTheme.titleLarge),
              if (widget.jobTitle != null || widget.jobPriceLabel != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.offerJobRecap(
                    widget.jobTitle ?? l10n.jobUntitled,
                    widget.jobPriceLabel ?? l10n.pricingNegotiable,
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'fixed', label: Text(l10n.pricingFixed)),
                  ButtonSegment(
                      value: 'hourly', label: Text(l10n.pricingHourly)),
                ],
                selected: {_pricingModel},
                onSelectionChanged: (v) =>
                    setState(() => _pricingModel = v.first),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _pricingModel == 'hourly'
                      ? l10n.offerHourlyRateLabel
                      : l10n.offerTotalAmountLabel,
                ),
                validator: (value) {
                  if (parsePositiveAmount(value ?? '') == null) {
                    return l10n.offerAmountRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hours,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: l10n.offerEstimatedHoursLabel),
                validator: (value) {
                  if (hasInvalidOptionalHours(value ?? '')) {
                    return l10n.offerHoursInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ActionChip(
                    label: Text(l10n.offerQuickToday),
                    onPressed:
                        _busy ? null : () => _appendNote(l10n.offerQuickToday),
                  ),
                  ActionChip(
                    label: Text(l10n.offerQuickTools),
                    onPressed:
                        _busy ? null : () => _appendNote(l10n.offerQuickTools),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _note,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: l10n.offerNoteLabel,
                  hintText: l10n.offerNoteHint,
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
                label: Text(l10n.offerSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
