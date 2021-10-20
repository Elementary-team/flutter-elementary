// ignore_for_file: avoid_implementing_value_types

import 'package:counter/impl/screen/test_page_model.dart';
import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:counter/impl/screen/test_page_widget_model.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

/// Тесты для [TestPageWidgetModel]
void main() {
  late TestPageModelMock model;
  late ThemeWrapperMock theme;
  late TextThemeMock textTheme;

  TestPageWidgetModel setUpWm() {
    textTheme = TextThemeMock();
    when(() => textTheme.headline4).thenReturn(null);
    theme = ThemeWrapperMock();
    when(() => theme.getTextTheme(any())).thenReturn(textTheme);
    model = TestPageModelMock();
    when(() => model.value).thenReturn(0);
    when(() => model.increment()).thenAnswer((invocation) => Future.value(1));

    return TestPageWidgetModel(model, theme);
  }

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'counterStyle should be headline4',
    setUpWm,
    (wm, tester, context) {
      final style = TextStyleMock();
      when(() => textTheme.headline4).thenReturn(style);

      tester.init();

      expect(wm.counterStyle, style);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'counterStyle should be not null when headline4 not found',
    setUpWm,
    (wm, tester, context) {
      tester.init();

      expect(wm.counterStyle, isNotNull);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'when call increment and before get answer valueState should be loading',
    setUpWm,
    (wm, tester, context) async {
      tester.init();

      when(() => model.increment()).thenAnswer(
        (invocation) => Future.delayed(
          const Duration(milliseconds: 30),
          () => 1,
        ),
      );

      unawaited(wm.increment());

      await Future<void>.delayed(
        const Duration(milliseconds: 10),
      );

      final value = wm.valueState.value;

      expect(value, isNotNull);
      expect(value!.isLoading, isTrue);
    },
  );
}

class TestPageModelMock extends Mock implements TestPageModel {}

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
