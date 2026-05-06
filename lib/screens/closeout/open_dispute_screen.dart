import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/dispute.dart';
import '../../providers/closeout_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/snack.dart';
import 'closeout_args.dart';

class OpenDisputeScreen extends ConsumerStatefulWidget {
  final AssignmentCloseoutArgs? args;
  const OpenDisputeScreen({super.key, required this.args});

  @override
  ConsumerState<OpenDisputeScreen> createState() => _OpenDisputeScreenState();
}

class _OpenDisputeScreenState extends ConsumerState<OpenDisputeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final List<String> _evidenceUrls = [];
  final List<String> _localPaths = [];
  String _reason = DisputeReason.other;
  bool _busy = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _addEvidence() async {
    if (_evidenceUrls.length >= 6) {
      showSnack(context, AppLocalizations.of(context).disputeEvidenceLimit,
          error: true);
      return;
    }
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
        _evidenceUrls.add(asset.publicUrl);
        _localPaths.add(picked.path);
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
    final againstUserId =
        args.isWorker ? args.job.creatorId : args.assignment.workerId;
    if (againstUserId == null) {
      showSnack(
          context, AppLocalizations.of(context).disputeMissingCounterparty,
          error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      final dispute = await ref.read(disputesRepositoryProvider).open(
            jobId: args.job.id,
            againstUserId: againstUserId,
            reason: _reason,
            description: _description.text.trim(),
            evidenceUrls: _evidenceUrls,
          );
      ref.invalidate(jobDetailProvider(args.job.id));
      ref.invalidate(jobDisputesProvider(args.job.id));
      if (!mounted) return;
      showSnack(context, AppLocalizations.of(context).disputeOpened);
      context.go('/disputes/${dispute.id}');
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
        appBar: AppBar(title: Text(l10n.disputeOpenTitle)),
        body: Center(child: Text(l10n.closeoutMissingContext)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.disputeOpenTitle)),
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
              DropdownButtonFormField<String>(
                initialValue: _reason,
                decoration: InputDecoration(labelText: l10n.disputeReasonLabel),
                items: [
                  for (final reason in DisputeReason.values)
                    DropdownMenuItem(
                        value: reason, child: Text(_reasonLabel(l10n, reason))),
                ],
                onChanged: (v) =>
                    setState(() => _reason = v ?? DisputeReason.other),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                maxLines: 6,
                maxLength: 4000,
                decoration:
                    InputDecoration(labelText: l10n.disputeDescriptionLabel),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? l10n.disputeDescriptionRequired
                    : null,
              ),
              const SizedBox(height: 12),
              Text(l10n.disputeEvidenceLabel,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < _localPaths.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(_localPaths[i]),
                              width: 96, height: 96, fit: BoxFit.cover),
                        ),
                      ),
                    if (_evidenceUrls.length < 6)
                      InkWell(
                        onTap: _busy ? null : _addEvidence,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_a_photo_outlined),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.gavel_outlined),
                label: Text(l10n.disputeSubmitAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _reasonLabel(AppLocalizations l10n, String reason) => switch (reason) {
      DisputeReason.notPaid => l10n.disputeReasonNotPaid,
      DisputeReason.underpaid => l10n.disputeReasonUnderpaid,
      DisputeReason.workNotDone => l10n.disputeReasonWorkNotDone,
      DisputeReason.poorQuality => l10n.disputeReasonPoorQuality,
      DisputeReason.noShow => l10n.disputeReasonNoShow,
      DisputeReason.damagedProperty => l10n.disputeReasonDamagedProperty,
      DisputeReason.abusiveBehavior => l10n.disputeReasonAbusiveBehavior,
      _ => l10n.disputeReasonOther,
    };
