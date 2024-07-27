import 'package:flutter/material.dart';

/// Wrapper for hiding direct call flutter ScaffoldManager.
class ScaffoldMessengerWrapper {
  /// Shows a default snackBar.
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _DefaultSnack(message: message),
    );
  }
}

class _DefaultSnack extends SnackBar {
  final String message;

  _DefaultSnack({required this.message}) : super(content: Text(message));
}
