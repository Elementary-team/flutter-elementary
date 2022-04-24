import 'package:elementary/src/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests of the [WidgetModel].
void main() {
  late ElementaryModelMock model;
  late ElementaryWidgetModelTest wm;

  group('WM and Model interaction.', () {
    setUp(() {
      model = ElementaryModelMock();
      wm = ElementaryWidgetModelTest(model);
    });

    test('Init WM should call model init', () {
      wm.initWidgetModel();

      verify(() => model.init()).called(1);
    });

    test('Dispose WM should call model dispose', () {
      wm.dispose();

      verify(() => model.dispose()).called(1);
    });

    test('Activate WM should not throw error', () {
      expect(() => wm.activate(), returnsNormally);
    });

    test('Deactivate WM should not throw error', () {
      expect(() => wm.deactivate(), returnsNormally);
    });

    test('Reassemble WM should not throw error', () {
      expect(() => wm.reassemble(), returnsNormally);
    });

    test('WM should use correct model', () {
      final model1 = ElementaryModelMock();
      final wm1 = ElementaryWidgetModelTest(model1);

      final model2 = ElementaryModelMock();
      final wm2 = ElementaryWidgetModelTest(model2);

      expect(wm1.model, same(model1));
      expect(wm2.model, same(model2));
    });
  });

  group('In tree interaction.', () {
    late ElementaryWidgetTest widget;

    setUp(() {
      model = ElementaryModelMock();
      wm = ElementaryWidgetModelTest(model);

      ElementaryWidgetModelTest factory(BuildContext ctx) {
        return wm;
      }

      widget = ElementaryWidgetTest(
        wmFactory: factory,
      );
    });

    testWidgets('Getter context should return correct Element', (tester) async {
      await tester.pumpWidget(widget);

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      expect(wm.context, same(elementary));
    });

    testWidgets(
      'Getting context after unmount should throw error',
      (tester) async {
        await tester.pumpWidget(widget);
        await tester.pumpWidget(Container());

        FlutterError? error;

        try {
          wm.context;
          // ignore: avoid_catching_errors
        } on FlutterError catch (e) {
          error = e;
        }

        expect(error, isNotNull);
        expect(error!.message, 'This widget has been unmounted');
      },
    );

    testWidgets(
      'Getting context before mount should throw error',
      (tester) async {
        FlutterError? error;

        try {
          wm.context;
          // ignore: avoid_catching_errors
        } on FlutterError catch (e) {
          error = e;
        }

        expect(error, isNotNull);
        expect(error!.message, 'This widget has been unmounted');
      },
    );

    testWidgets(
      'Property isMounted should return true when widget inflate into tree',
      (tester) async {
        await tester.pumpWidget(widget);

        expect(wm.isMounted, isTrue);
      },
    );

    testWidgets(
      'Property isMounted should return false after defunct',
      (tester) async {
        await tester.pumpWidget(widget);
        await tester.pumpWidget(Container());

        expect(wm.isMounted, isFalse);
      },
    );

    testWidgets('Getter widget should return correct widget', (tester) async {
      await tester.pumpWidget(widget);

      expect(wm.widget, same(widget));
    });

    test('DidUpdateWidgets should returns normally', () {
      expect(() => wm.didUpdateWidget(widget), returnsNormally);
    });

    test('OnErrorHandler should returns normally', () {
      expect(() => wm.onErrorHandle(1), returnsNormally);
    });
  });

  group('Testing methods', () {
    setUp(() {
      model = ElementaryModelMock();
      wm = ElementaryWidgetModelTest(model);
    });

    test('setupTestWidget should set widget', () {
      ElementaryWidgetModelTest factory(BuildContext ctx) {
        return ElementaryWidgetModelTest(ElementaryModelMock());
      }

      final widget = ElementaryWidgetTest(
        wmFactory: factory,
      );

      wm.setupTestWidget(widget);

      expect(wm.widget, same(widget));
    });

    test('setupTestElement should set element', () {
      ElementaryWidgetModelTest factory(BuildContext ctx) {
        return ElementaryWidgetModelTest(ElementaryModelMock());
      }

      final widget = ElementaryWidgetTest(
        wmFactory: factory,
      );

      final element = Elementary(widget);

      wm.setupTestElement(element);

      expect(wm.context, same(element));
    });
  });
}

class ElementaryWidgetTest
    extends ElementaryWidget<IElementaryWidgetModelTest> {
  const ElementaryWidgetTest({
    Key? key,
    required WidgetModelFactory wmFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IElementaryWidgetModelTest wm) {
    return Container();
  }
}

class IElementaryWidgetModelTest extends IWidgetModel {}

class ElementaryWidgetModelTest
    extends WidgetModel<ElementaryWidgetTest, ElementaryModelMock>
    implements IElementaryWidgetModelTest {
  ElementaryWidgetModelTest(ElementaryModelMock model) : super(model);
}

class ElementaryModelMock extends Mock implements ElementaryModel {}
