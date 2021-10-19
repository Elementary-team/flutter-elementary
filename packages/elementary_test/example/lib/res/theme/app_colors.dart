import 'package:flutter/widgets.dart';

/// Used colors
class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color primaryGreen1 = Color(0xFF21905B);
  static const Color primaryGreen2 = Color(0xFF33B063);
  static const Color primaryGreen3 = Color(0xFF95DEB0);

  /// Primary colors
  static const Iterable<Color> primaryValues = [
    primaryGreen1,
    primaryGreen2,
    primaryGreen3,
  ];

  static const Color secondaryBlue = Color(0xFF4D50B0);
  static const Color secondaryBlue2 = Color(0xFF6E71C7);
  static const Color secondaryBlue3 = Color(0xFFABAEFB);

  /// Secondary colors
  static const Iterable<Color> secondaryValues = [
    secondaryBlue,
    secondaryBlue2,
    secondaryBlue3,
  ];

  static const Color accentYellow = Color(0xFFFFB940);
  static const Color accentPink = Color(0xFFBF35AC);
  static const Color accentRed = Color(0xFFFF4C4C);

  /// Accent colors
  static const Iterable<Color> accentValues = [
    accentYellow,
    accentPink,
    accentRed,
  ];

  static const Color systemIcon = Color(0xFFA7B5C9);
  static const Color systemDivider = Color(0xFFDBE2ED);

  /// System colors
  static const Iterable<Color> systemValues = [
    systemIcon,
    systemDivider,
  ];

  static const Color typographyPrimary = Color(0xFF121213);
  static const Color typographySecondary = Color(0xFF727986);
  static const Color typographyTertiary = Color(0xFFABB3C0);
  static const Color typographyWhite = white;

  /// Typography
  static const Iterable<Color> typographyValues = [
    typographyPrimary,
    typographySecondary,
    typographyTertiary,
    typographyWhite,
  ];

  static const Color bgGray = Color(0xFFF1F6FA);
  static const Color bgWhite = white;
  static const Color bgGreen = Color(0xFFE6FEF2);

  /// Shadow color
  static const Color shadowColor = Color(0xFF727986);

  /// BG
  static const Iterable<Color> bgValues = [
    bgGray,
    bgWhite,
    bgGreen,
  ];
}
