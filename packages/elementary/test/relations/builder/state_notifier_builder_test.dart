import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [StateNotifierBuilder].
void main() {
  late TestEntity testEntity;
  late StateNotifierBuilder<TestEntity> testingWidget;
  late ListenableStateMock<TestEntity> listenableState;
  late MockBuilder<TestEntity> builder;
  late Widget widget;
  late VoidCallback? listener;

  setUp(() {
    registerFallbackValue(BuildContextFake());

    testEntity = TestEntity();
    listenableState = ListenableStateMock<TestEntity>();
    when(() => listenableState.value).thenReturn(testEntity);
    when(
      () => listenableState.addListener(
        any(),
      ),
    ).thenAnswer(
      (invocation) {
        listener = invocation.positionalArguments[0] as VoidCallback;
      },
    );

    widget = Container();
    builder = MockBuilder<TestEntity>();
    when(() => builder.call(any(), any())).thenReturn(widget);

    testingWidget = StateNotifierBuilder<TestEntity>(
      listenableState: listenableState,
      builder: builder.call,
    );
  });

  tearDown(() {
    listener = null;
  });

  testWidgets(
    'Value should be taken from listenableState when init',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => listenableState.value).called(1);
    },
  );

  testWidgets(
    'Value taken from listenableState when use to build',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => builder.call(any(), testEntity)).called(1);
    },
  );

  testWidgets('Initialization should add listener', (tester) async {
    await tester.pumpWidget(testingWidget);

    verify(() => listenableState.addListener(any())).called(1);
  });

  testWidgets('Dispose should remove listener which was add', (tester) async {
    await tester.pumpWidget(testingWidget);
    await tester.pumpWidget(Container());

    verify(() => listenableState.removeListener(listener!)).called(1);
  });

  testWidgets(
    'Update widget with another listenable state should remove listener from old listenable state',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final anotherListenableState = ListenableStateMock<TestEntity>();

      final anotherTestingWidget = StateNotifierBuilder<TestEntity>(
        listenableState: anotherListenableState,
        builder: builder.call,
      );

      await tester.pumpWidget(anotherTestingWidget);

      verify(() => listenableState.removeListener(listener!)).called(1);
    },
  );

  testWidgets(
    'Update widget with another listenable state should add listener to new listenable state',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final anotherListenableState = ListenableStateMock<TestEntity>();

      final anotherTestingWidget = StateNotifierBuilder<TestEntity>(
        listenableState: anotherListenableState,
        builder: builder.call,
      );

      await tester.pumpWidget(anotherTestingWidget);

      verify(() => anotherListenableState.addListener(listener!)).called(1);
    },
  );

  testWidgets(
    'Update widget with another listenable state should build with new listenable state value',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final anotherTestEntity = TestEntity();
      final anotherListenableState = ListenableStateMock<TestEntity>();
      when(() => anotherListenableState.value).thenReturn(anotherTestEntity);

      final anotherTestingWidget = StateNotifierBuilder<TestEntity>(
        listenableState: anotherListenableState,
        builder: builder.call,
      );

      await tester.pumpWidget(anotherTestingWidget);

      verify(() => builder.call(any(), anotherTestEntity)).called(1);
    },
  );

  testWidgets('Call listener should rebuild with new value', (tester) async {
    await tester.pumpWidget(testingWidget);

    final newTestEntity = TestEntity();
    when(() => listenableState.value).thenReturn(newTestEntity);

    listener!.call();

    await tester.pump();

    verify(() => builder.call(any(), newTestEntity)).called(1);
  });
}

class ListenableStateMock<T> extends Mock implements ListenableState<T> {}

class MockBuilder<T> extends Mock {
  Widget call(BuildContext context, T? value);
}

class TestEntity {}

class BuildContextFake extends Fake implements BuildContext {}
