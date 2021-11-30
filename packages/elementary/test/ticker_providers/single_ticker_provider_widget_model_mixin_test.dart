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
    'When embedding a testWidget in a tree, there should be no errors',
    (tester) async {
      expect(
        () async => tester.pumpWidget(testWidget),
        returnsNormally,
      );
    },
  );

  testWidgets(
    'There must be a definite error when trying to create two AnimationController',
    (tester) async {
      Object? expectError;
      try {
        AnimationController(vsync: testWidgetModel);
      } catch (e) {
        expectError = e;
      }
      expect(expectError, isNull);

      try {
        AnimationController(vsync: testWidgetModel);
      } catch (e) {
        expectError = e;
      }

      expect(expectError, isNotNull);
      expect(expectError, isFlutterError);
      final error = expectError as FlutterError;
      expect(error.diagnostics.length, 3);
      expect(error.diagnostics[2].level, DiagnosticLevel.hint);
      expect(
        error.diagnostics[2].toStringDeep(),
        equalsIgnoringHashCodes(
          'If a WidgetModel is used for multiple AnimationController\n'
          'objects, or if it is passed to other objects and those objects\n'
          'might use it more than one time in total, then instead of mixing\n'
          'in a SingleTickerProviderWidgetModelMixin, implement your own\n'
          'TickerProviderWidgetModelMixin.\n'
          '',
        ),
      );
    },
  );

  testWidgets(
    'Calling dispose() method while the ticker is active should '
    'throw a specific error',
    (tester) async {
      Object? expectError;
      await tester.pumpWidget(testWidget);
      unawaited(testWidgetModel.controller.repeat());
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
          '   SingleTickerProviderWidgetModelMixin, but at the time dispose()\n'
          '   was called on the mixin, that Ticker was still active. The Ticker\n'
          '   must be disposed before calling super.dispose().\n'
          '   Tickers used by AnimationControllers should be disposed by\n'
          '   calling dispose() on the AnimationController itself. Otherwise,\n'
          '   the ticker will leak.\n'
          '   The offending ticker was:\n'
          '     Ticker(created by TestWidgetModel#3d3de)\n'
          '     The stack trace when the Ticker was actually created was:\n'
          '     #0      new Ticker.<anonymous closure>',
        ),
      );
      testWidgetModel.controller.stop();
      expectError = null;
      try {
        testWidgetModel.dispose();
      } catch (e) {
        expectError = e;
      }

      expect(expectError, isNull);
    },
  );
}

class IElementaryWidgetModelTest extends IWidgetModel {}

class TestWidgetModel
    extends WidgetModel<TestElementaryWidget, ElementaryModelMock>
    with
        SingleTickerProviderWidgetModelMixin<TestElementaryWidget,
            ElementaryModelMock>
    implements
        IElementaryWidgetModelTest {
  late AnimationController controller;

  TestWidgetModel({
    required ElementaryModelMock model,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
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
