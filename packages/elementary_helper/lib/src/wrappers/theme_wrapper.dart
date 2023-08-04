import 'package:flutter/material.dart';

/// Wrapper for hiding direct call flutter theme.
class ThemeWrapper {
  /// Return theme data.
  ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }

  /// Return theme data.
  TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
