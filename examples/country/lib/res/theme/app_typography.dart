import 'package:country/res/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

const defaultFontFamily = 'Roboto';

class AppTypography {
  static const largeTitle = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 52,
    height: 60 / 52,
    fontFamily: defaultFontFamily,
  );

  static const title1 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 40 / 32,
    fontFamily: defaultFontFamily,
  );

  static const title2 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32 / 24,
    fontFamily: defaultFontFamily,
  );

  static const title3 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 24 / 18,
    fontFamily: defaultFontFamily,
  );

  static const headline = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24 / 16,
    fontFamily: defaultFontFamily,
  );

  static const subHeadline = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 20 / 14,
    fontFamily: defaultFontFamily,
  );

  static const body = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    fontFamily: defaultFontFamily,
  );

  static const body2 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
    fontFamily: defaultFontFamily,
  );

  static const invisibleTextStyle =
      TextStyle(color: Color(0x00000000), fontSize: 0);
}
