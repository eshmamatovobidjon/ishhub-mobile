import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/api_client.dart';

/// Unified loading / error / empty / data view for any AsyncValue list+detail.
class AsyncStateView<T> extends StatelessWidget {
  final AsyncValue<T> state;
  final Widget Function(T data) data;
  final bool Function(T data)? isEmpty;
  final Widget? emptyView;
  final Future<void> Function()? onRetry;

  const AsyncStateView({
    super.key,
    required this.state,
    required this.data,
    this.isEmpty,
    this.emptyView,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        message: err is ApiException ? err.message : err.toString(),
        onRetry: onRetry,
      ),
      data: (value) {
        if (isEmpty != null && isEmpty!(value)) {
          return emptyView ?? const _DefaultEmpty();
        }
        return data(value);
      },
    );
  }
}

class _DefaultEmpty extends StatelessWidget {
  const _DefaultEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(l10n.asyncEmpty, textAlign: TextAlign.center),
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(l10n.asyncRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
