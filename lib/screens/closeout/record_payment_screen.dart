import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/payment.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/snack.dart';
import 'closeout_args.dart';

class RecordPaymentScreen extends ConsumerStatefulWidget {
  final AssignmentCloseoutArgs? args;
  const RecordPaymentScreen({super.key, required this.args});

  @override
  ConsumerState<RecordPaymentScreen> createState() =>
      _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends ConsumerState<RecordPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String _method = PaymentMethod.cash;
  String _receiptUrl = '';
  String? _receiptPath;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    final amount = args?.assignment.finalAmount ?? args?.job.budget;
    if (amount != null) _amount.text = amount.toString();
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _busy = true);
    try {
      final asset = await ref.read(mediaUploadServiceProvider).upload(
            file: File(picked.path),
            kind: 'photo',
            contentType: _contentTypeFor(picked.path),
          );
      if (!mounted) return;
      setState(() {
        _receiptUrl = asset.publicUrl;
        _receiptPath = picked.path;
      });
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted)
        showSnack(context, AppLocalizations.of(context).closeoutUploadFailed,
            error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final args = widget.args;
    if (args == null || !_formKey.currentState!.validate()) return;
    final amount = num.tryParse(_amount.text.trim());
    if (amount == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(paymentsRepositoryProvider).record(
            assignmentId: args.assignment.id,
            amount: amount,
            method: _method,
            note: _note.text.trim(),
            receiptUrl: _receiptUrl,
          );
      ref.invalidate(jobDetailProvider(args.job.id));
      if (!mounted) return;
      showSnack(context, AppLocalizations.of(context).paymentRecorded);
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

  String _contentTypeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic')) return 'image/heic';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final args = widget.args;
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.paymentRecordTitle)),
        body: Center(child: Text(l10n.closeoutMissingContext)),
      );
    }
    final currency = args.job.budgetCurrency;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentRecordTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(args.job.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.paymentAmountLabel(currency),
                ),
                validator: (v) => num.tryParse((v ?? '').trim()) == null
                    ? l10n.paymentAmountRequired
                    : null,
              ),
              const SizedBox(height: 16),
              Text(l10n.paymentMethodLabel,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                      value: PaymentMethod.cash,
                      label: Text(l10n.paymentMethodCash)),
                  ButtonSegment(
                      value: PaymentMethod.cardTransfer,
                      label: Text(l10n.paymentMethodCardTransfer)),
                  ButtonSegment(
                      value: PaymentMethod.other,
                      label: Text(l10n.paymentMethodOther)),
                ],
                selected: {_method},
                onSelectionChanged: (v) => setState(() => _method = v.first),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _note,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.paymentNoteLabel),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickReceipt,
                icon: const Icon(Icons.receipt_long_outlined),
                label: Text(_receiptUrl.isEmpty
                    ? l10n.paymentAddReceipt
                    : l10n.paymentChangeReceipt),
              ),
              if (_receiptPath != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(_receiptPath!),
                      height: 160, fit: BoxFit.cover),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.payments_outlined),
                label: Text(l10n.paymentRecordAction),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.paymentRecordFootnote(
                    NumberFormat.decimalPattern()
                        .format(num.tryParse(_amount.text) ?? 0),
                    currency),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
