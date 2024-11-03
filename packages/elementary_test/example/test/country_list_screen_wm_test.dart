// ignore_for_file: avoid_implementing_value_types, cascade_invocations

import 'dart:async';

import 'package:counter/main.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Тесты для [TestPageWidgetModel]
void main() {
  late TestPageModelMock model;

  TestPageWidgetModel setUpWm() {
    model = TestPageModelMock();
    when(() => model.value).thenReturn(0);
    when(() => model.increment()).thenAnswer((invocation) => Future.value(1));

    return TestPageWidgetModel(model);
  }

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'calculatingState should return true while incrementing before the answer was recieved',
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

      expect(wm.calculatingState.value, isTrue);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'calculatingState should return false after get the answer of incrementing',
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
        const Duration(milliseconds: 31),
      );

      expect(wm.calculatingState.value, isFalse);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'should happen smth depend on lifecycle',
    setUpWm,
    (wm, tester, context) async {
      tester.init();

      // Emulate didChangeDependencies happened.
      tester.didChangeDependencies();

      // Test what ever we expect happened in didChangeDependencies;
      // ...
    },
  );
}

class TestPageModelMock extends Mock
    with MockElementaryModelMixin
    implements TestPageModel {}
