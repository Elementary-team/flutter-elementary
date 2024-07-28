import 'package:country/assets/colors/colors.dart';
import 'package:flutter/material.dart';

/// Theme data for application.
final appTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: accentColor,
    secondary: accentColor,
    onSecondary: primaryColor,
    error: errorColor,
    onError: whiteColor,
    background: backgroundColor,
    onBackground: textColorPrimary,
    surface: backgroundColor,
    onSurface: textColorPrimary,
  ),
);
