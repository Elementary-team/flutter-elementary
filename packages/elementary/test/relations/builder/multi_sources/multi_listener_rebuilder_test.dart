import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [MultiListenerRebuilder].
void main() {
  late MultiListenerRebuilder testingWidget;
  late Iterable<ListenableMock> listenableList;
  late MockBuilder builder;
  late Widget widget;
  late Map<ListenableMock, VoidCallback> listeners;

  setUp(() {
    registerFallbackValue(BuildContextFake());
    listeners = {};
    listenableList = <ListenableMock>[
      ListenableMock(),
      ListenableMock(),
      ListenableMock(),
      ListenableMock(),
    ];

    for (final listenable in listenableList) {
      when(
        () => listenable.addListener(
          any(),
        ),
      ).thenAnswer(
        (invocation) {
          listeners[listenable] =
              invocation.positionalArguments[0] as VoidCallback;
        },
      );
    }

    widget = Container();

    builder = MockBuilder();
    when(() => builder.call(any())).thenReturn(widget);

    testingWidget = MultiListenerRebuilder(
      listenableList: listenableList,
      builder: builder.call,
    );
  });

  testWidgets(
    'Widget inflating should add listener to all sources',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      for (final listenable in listenableList) {
        verify(() => listenable.addListener(any())).called(1);
      }
    },
  );

  group(
    'Update and dispose widget tests: ',
    () {
      testWidgets(
        'Dispose should remove listeners which was add',
        (tester) async {
          await tester.pumpWidget(testingWidget);
          await tester.pumpWidget(Container());

          for (final listenable in listenableList) {
            verify(() => listenable.addListener(listeners[listenable]!))
                .called(1);
          }
        },
      );

      testWidgets(
        'Update widget with another listenableList should remove listeners from all missing previous listenable and should not remove from reused',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final missingList = <ListenableMock>[];
          final newListenableList = <ListenableMock>[];
          for (var i = 0; i < listenableList.length; i++) {
            final listenable = listenableList.elementAt(i);
            if (i.isEven) {
              missingList.add(listenable);
            } else {
              newListenableList.add(listenable);
            }
          }

          final anotherTestingWidget = MultiListenerRebuilder(
            listenableList: newListenableList,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          for (final listenable in missingList) {
            verify(() => listenable.removeListener(listeners[listenable]!))
                .called(1);
          }

          for (final listenable in newListenableList) {
            verifyNever(() => listenable.removeListener(any()));
          }
        },
      );

      testWidgets(
        'Update widget with new listenable list should add listener for all new listenable',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final newListenableList = <ListenableMock>[
            ListenableMock(),
            ListenableMock(),
            ListenableMock(),
            ListenableMock(),
          ];

          final anotherTestingWidget = MultiListenerRebuilder(
            listenableList: newListenableList,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          for (final listenable in newListenableList) {
            verify(() => listenable.addListener(any())).called(1);
          }
        },
      );
    },
  );

  testWidgets(
    'Call any added listener from list should make rebuild',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      reset(builder);
      when(() => builder.call(any())).thenReturn(widget);

      for (var i = 0; i < listenableList.length; i++) {
        final listenable = listenableList.elementAt(i);
        listeners[listenable]!.call();

        await tester.pump();

        verify(() => builder.call(any())).called(1);

        reset(builder);
        when(() => builder.call(any())).thenReturn(widget);
      }
    },
  );
}

class ListenableMock extends Mock implements Listenable {}

class MockBuilder extends Mock {
  Widget call(BuildContext context);
}

class BuildContextFake extends Fake implements BuildContext {}
