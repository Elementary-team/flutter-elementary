import 'package:elementary/src/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests of the [Elementary] behaviour.
void main() {
  late int factoryCalledCount;
  late BuildContext? factoryCalledContext;
  late Object? buildCallbackObject;
  late ElementaryWidgetModelMock? wm;
  late ElementaryWidgetTest widget;

  setUp(() {
    factoryCalledCount = 0;
    factoryCalledContext = null;
    buildCallbackObject = null;
    wm = null;

    void buildCallback(Object object) {
      buildCallbackObject = object;
    }

    ElementaryWidgetModelMock factory(BuildContext ctx) {
      factoryCalledContext = ctx;
      factoryCalledCount++;
      wm = ElementaryWidgetModelMock();
      return wm!;
    }

    widget = ElementaryWidgetTest(
      wmFactory: factory,
      buildCallback: buildCallback,
    );
  });

  testWidgets('First build should create widget model', (tester) async {
    await tester.pumpWidget(widget);

    expect(factoryCalledCount, 1);
  });

  testWidgets('Next builds should not create widget model', (tester) async {
    await tester.pumpWidget(widget);

    expect(factoryCalledCount, 1);

    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(factoryCalledCount, 1);
  });

  testWidgets(
    'For creating wm should be passed correct context',
    (tester) async {
      await tester.pumpWidget(widget);

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      expect(factoryCalledContext, same(elementary));
    },
  );

  testWidgets(
    'For creating wm should be passed correct context',
    (tester) async {
      await tester.pumpWidget(widget);

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      expect(factoryCalledContext, same(elementary));
    },
  );

  testWidgets(
    'First build should call correct widget model methods',
    (tester) async {
      await tester.pumpWidget(widget);

      verifyInOrder([
        () => wm!.initWidgetModel(),
        () => wm!.didChangeDependencies(),
      ]);
    },
  );

  testWidgets('Element should use correct wm for building', (tester) async {
    await tester.pumpWidget(widget);

    expect(buildCallbackObject, same(wm));
  });

  testWidgets('Element should have correct link with widget', (tester) async {
    await tester.pumpWidget(widget);

    final elementary = tester.element<Elementary>(
      find.byElementType(Elementary),
    );

    expect(elementary.widget, same(widget));
  });

  testWidgets(
    'Unmount should call deactivate from widget model',
    (tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpWidget(Container());

      verify(() => wm!.deactivate()).called(1);
    },
  );

  testWidgets(
    'Unmount should call dispose from widget model',
    (tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpWidget(Container());

      verify(() => wm!.dispose()).called(1);
    },
  );

  testWidgets(
    'Moving to another part of tree should call activate from widget model',
    (tester) async {
      void buildCallback(Object object) {
        buildCallbackObject = object;
      }

      ElementaryWidgetModelMock factory(BuildContext ctx) {
        factoryCalledContext = ctx;
        factoryCalledCount++;
        wm = ElementaryWidgetModelMock();
        return wm!;
      }

      widget = ElementaryWidgetTest(
        key: GlobalKey(debugLabel: 'test'),
        wmFactory: factory,
        buildCallback: buildCallback,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Row(
                key: const ValueKey<String>('firstRow'),
                children: [
                  widget,
                ],
              ),
              Row(
                key: const ValueKey<String>('secondRow'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Row(
                key: const ValueKey<String>('firstRow'),
              ),
              Row(
                key: const ValueKey<String>('secondRow'),
                children: [
                  widget,
                ],
              ),
            ],
          ),
        ),
      );

      verify(() => wm!.activate()).called(1);
    },
  );

  testWidgets(
    'Change dependencies should call didChangeDependencies widget model',
    (tester) async {
      final notifier = TestNotifier();

      await tester.pumpWidget(
        TestNotifierWidget(
          test: notifier,
          child: widget,
        ),
      );

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      verify(() => wm!.didChangeDependencies()).called(1);

      TestNotifierWidget.of(elementary);

      notifier.up();

      await tester.pump();

      verify(() => wm!.didChangeDependencies()).called(1);
    },
  );

  testWidgets(
    'Element should have correct link with widget after update',
    (tester) async {
      await tester.pumpWidget(widget);
      when(() => wm!.widget).thenReturn(widget);

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      final newWidget = ElementaryWidgetTest(
        buildCallback: (_) {},
        wmFactory: (_) {
          return ElementaryWidgetModelMock();
        },
      );

      await tester.pumpWidget(newWidget);

      expect(elementary.widget, same(newWidget));
    },
  );

  testWidgets(
    'Element reassemble should invoke wm reassemble',
    (tester) async {
      await tester.pumpWidget(widget);

      final elementary = tester.element<Elementary>(
        find.byElementType(Elementary),
      );

      // ignore: cascade_invocations
      elementary.reassemble();

      verify(() => wm!.reassemble()).called(1);
    },
  );
}

class ElementaryWidgetTest
    extends ElementaryWidget<IElementaryWidgetModelMock> {
  final void Function(Object) buildCallback;

  const ElementaryWidgetTest({
    Key? key,
    required WidgetModelFactory wmFactory,
    required this.buildCallback,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IElementaryWidgetModelMock wm) {
    buildCallback.call(wm);
    return Container();
  }
}

class IElementaryWidgetModelMock extends IWidgetModel {}

class ElementaryWidgetModelMock extends DiagnosticableMock
    implements
        WidgetModel<ElementaryWidgetTest, ElementaryModelMock>,
        IElementaryWidgetModelMock {}

class ElementaryModelMock extends Mock implements ElementaryModel {}

abstract class DiagnosticableMock extends Mock with Diagnosticable {}

class TestNotifierWidget extends InheritedNotifier {
  final TestNotifier test;

  const TestNotifierWidget({
    Key? key,
    required this.test,
    required Widget child,
  }) : super(key: key, child: child, notifier: test);

  static TestNotifier of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<TestNotifierWidget>();

    if (widget == null) {
      throw Exception('Not found');
    }

    return widget.test;
  }
}

class TestNotifier extends ValueNotifier<int> {
  TestNotifier() : super(0);

  void up() {
    value++;
  }
}
