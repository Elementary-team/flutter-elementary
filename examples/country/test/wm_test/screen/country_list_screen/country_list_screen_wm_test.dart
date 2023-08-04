// ignore_for_file: avoid_implementing_value_types

import 'package:country/res/theme/app_typography.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_model.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Тесты для [CountryListScreenWidgetModel]
void main() {
  late CountryListScreenModelMock model;
  late ThemeWrapperMock theme;
  late TextThemeMock textTheme;

  CountryListScreenWidgetModel setUpWm() {
    textTheme = TextThemeMock();
    theme = ThemeWrapperMock();
    when(() => theme.getTextTheme(any())).thenReturn(textTheme);
    model = CountryListScreenModelMock();
    when(() => model.loadCountries())
        .thenAnswer((invocation) => Future.value([]));

    return CountryListScreenWidgetModel(model, theme);
  }

  testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
    'countryNameStyle should be headline4',
    setUpWm,
    (wm, tester, context) {
      final style = TextStyleMock();
      when(() => textTheme.headlineMedium).thenReturn(style);

      tester.init();

      expect(wm.countryNameStyle, style);
    },
  );

  testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
    'countryNameStyle should be AppTypography.title3 when headline4 not found',
    setUpWm,
    (wm, tester, context) {
      when(() => textTheme.headlineMedium).thenReturn(null);

      tester.init();

      expect(wm.countryNameStyle, AppTypography.title3);
    },
  );
}

class CountryListScreenModelMock extends Mock
    implements CountryListScreenModel {}

class ThemeWrapperMock extends Mock implements ThemeWrapper {}

class TextThemeMock extends DiagnosticableMock implements TextTheme {}

class TextStyleMock extends DiagnosticableMock implements TextStyle {
  @override
  // ignore: must_call_super
  void debugFillProperties(
    DiagnosticPropertiesBuilder properties, {
    String prefix = '',
  }) {}
}

class DiagnosticableMock extends Mock with Diagnosticable {}
