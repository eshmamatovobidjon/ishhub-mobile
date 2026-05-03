import 'package:flutter/material.dart';

void showSnack(BuildContext context, String message, {bool error = false}) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? theme.colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
