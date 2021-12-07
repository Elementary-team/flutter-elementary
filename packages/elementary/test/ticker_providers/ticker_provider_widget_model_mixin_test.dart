import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ignore_for_file: avoid_catches_without_on_clauses
void main() {
  late TestWidgetModel testWidgetModel;
  late ElementaryModelMock model;
  late ElementaryWidget testWidget;

  TestWidgetModel testWmFactory(
    BuildContext context,
  ) {
    return testWidgetModel;
  }

  setUp(
    () {
      model = ElementaryModelMock();
      testWidgetModel = TestWidgetModel(model: model);
      testWidget = TestElementaryWidget(testWmFactory);
    },
  );

  testWidgets(
    'When embedding a testWidget with two AnimationController in a tree,'
    ' there should be no errors',
    (tester) async {
      expect(
        () async => tester.pumpWidget(testWidget),
        returnsNormally,
      );
    },
  );

  testWidgets(
    'Calling dispose() method while the ticker is active should '
    'throw a specific error',
    (tester) async {
      await tester.pumpWidget(testWidget);
      unawaited(testWidgetModel.firstTestController.repeat());
      Object? expectError;
      try {
        testWidgetModel.dispose();
      } catch (e) {
        expectError = e;
      }
      expect(expectError, isNotNull);
      expect(expectError, isFlutterError);
      final error = expectError as FlutterError;
      expect(error.diagnostics.length, 4);
      expect(error.diagnostics[2].level, DiagnosticLevel.hint);
      expect(
        error.diagnostics[2].toStringDeep(),
        'Tickers used by AnimationControllers should be disposed by\n'
        'calling dispose() on the AnimationController itself. Otherwise,\n'
        'the ticker will leak.\n',
      );
      expect(error.diagnostics[3], isA<DiagnosticsProperty<Ticker>>());
      expect(
        error.toStringDeep().split('\n').take(13).join('\n'),
        equalsIgnoringHashCodes(
          'FlutterError\n'
          '   TestWidgetModel#00000 was disposed with an active Ticker.\n'
          '   TestWidgetModel created a Ticker via its\n'
          '   TickerProviderWidgetModelMixin, but at the time dispose() was\n'
          '   called on the mixin, that Ticker was still active. The Ticker\n'
          '   must be disposed before calling super.dispose().\n'
          '   Tickers used by AnimationControllers should be disposed by\n'
          '   calling dispose() on the AnimationController itself. Otherwise,\n'
          '   the ticker will leak.\n'
          '   The offending ticker was:\n'
          '     _WidgetTicker(created by TestWidgetModel#991c6)\n'
          '     The stack trace when the _WidgetTicker was actually created\n'
          '     was:',
        ),
      );

      testWidgetModel.firstTestController.stop();
      expectError = null;
      try {
        testWidgetModel.dispose();
      } catch (e) {
        expectError = e;
      }

      expect(expectError, isNull);

      testWidgetModel.firstTestController.dispose();
    },
  );
}

class IElementaryWidgetModelTest extends IWidgetModel {}

class TestWidgetModel
    extends WidgetModel<TestElementaryWidget, ElementaryModelMock>
    with
        TickerProviderWidgetModelMixin<TestElementaryWidget,
            ElementaryModelMock>
    implements
        IElementaryWidgetModelTest {
  late AnimationController firstTestController;
  late AnimationController secondTestController;

  TestWidgetModel({
    required ElementaryModelMock model,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    firstTestController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    secondTestController = AnimationController(vsync: this);
  }
}

class TestElementaryWidget
    extends ElementaryWidget<IElementaryWidgetModelTest> {
  const TestElementaryWidget(
    WidgetModelFactory<
            WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>>
        wmFactory, {
    Key? key,
  }) : super(
          wmFactory,
          key: key,
        );

  @override
  Widget build(IElementaryWidgetModelTest wm) {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}

class ElementaryModelMock extends Mock implements ElementaryModel {}
