import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/geo.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../services/location_service.dart';
import '../../services/media_upload_service.dart';
import '../../widgets/snack.dart';

/// Step 1 of the job composer: collect raw inputs (text + photos + location)
/// and POST to /jobs/draft/. Then we navigate to review screen which polls
/// for the AI extraction result.
class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _textCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final List<UploadedAsset> _photos = [];
  GeoPoint? _location;
  bool _busy = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    setState(() => _busy = true);
    try {
      final res = await ref.read(locationServiceProvider).currentPosition();
      if (!mounted) return;
      if (res.status == LocationStatus.ok) {
        setState(() => _location = res.point);
      } else {
        showSnack(context, AppLocalizations.of(context).createJobLocationFailed,
            error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addPhoto() async {
    if (_photos.length >= 6) {
      showSnack(context, AppLocalizations.of(context).createJobMaxPhotos,
          error: true);
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(
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
      setState(() => _photos.add(asset));
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).createJobUploadFailed,
            error: true);
      }
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

  Future<void> _submit() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _photos.isEmpty) {
      showSnack(context, AppLocalizations.of(context).createJobInputRequired,
          error: true);
      return;
    }
    if (_location == null) {
      showSnack(context, AppLocalizations.of(context).createJobLocationRequired,
          error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      final draft = await ref.read(draftsRepositoryProvider).createDraft(
            latitude: _location!.latitude,
            longitude: _location!.longitude,
            address: _addressCtrl.text.trim(),
            textInput: text,
            photoUrls: _photos.map((p) => p.publicUrl).toList(),
          );
      if (!mounted) return;
      context.pushReplacement('/jobs/drafts/${draft.id}');
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createJobTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.createJobIntro,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textCtrl,
              maxLines: 5,
              maxLength: 4000,
              decoration: InputDecoration(
                labelText: l10n.createJobBodyLabel,
                hintText: l10n.createJobBodyHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                labelText: l10n.createJobAddressLabel,
              ),
            ),
            const SizedBox(height: 16),
            _LocationCard(
                point: _location, onTap: _busy ? null : _pickLocation),
            const SizedBox(height: 16),
            Text(l10n.createJobPhotosCount(_photos.length),
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _PhotosStrip(
              photos: _photos,
              onAdd: _busy ? null : _addPhoto,
              onRemove: (i) => setState(() => _photos.removeAt(i)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(l10n.createJobAnalyze),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final GeoPoint? point;
  final VoidCallback? onTap;
  const _LocationCard({required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.place_outlined),
        title: Text(point == null
            ? l10n.createJobLocationSelect
            : l10n.createJobLocationSelected),
        subtitle: point != null
            ? Text(
                '${point!.latitude.toStringAsFixed(5)}, '
                '${point!.longitude.toStringAsFixed(5)}',
              )
            : null,
        trailing: const Icon(Icons.gps_fixed),
        onTap: onTap,
      ),
    );
  }
}

class _PhotosStrip extends StatelessWidget {
  final List<UploadedAsset> photos;
  final VoidCallback? onAdd;
  final void Function(int) onRemove;
  const _PhotosStrip({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...photos.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(e.value.localPath ?? ''),
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 96,
                            height: 96,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton.filledTonal(
                          icon: const Icon(Icons.close, size: 16),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 28, minHeight: 28),
                          onPressed: () => onRemove(e.key),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (onAdd != null && photos.length < 6)
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onAdd,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: const Icon(Icons.add_a_photo_outlined, size: 32),
              ),
            ),
        ],
      ),
    );
  }
}
