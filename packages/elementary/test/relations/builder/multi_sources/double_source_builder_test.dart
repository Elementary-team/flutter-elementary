import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [DoubleSourceBuilder].
void main() {
  late TestEntity firstTestEntity;
  late TestEntity secondTestEntity;
  late DoubleSourceBuilder<TestEntity, TestEntity> testingWidget;
  late ListenableStateMock<TestEntity> firstListenableState;
  late ListenableStateMock<TestEntity> secondListenableState;
  late MockBuilder<TestEntity, TestEntity> builder;
  late Widget widget;
  late VoidCallback? firstListener;
  late VoidCallback? secondListener;

  setUp(() {
    registerFallbackValue(BuildContextFake());

    firstTestEntity = TestEntity();
    secondTestEntity = TestEntity();

    firstListenableState = ListenableStateMock<TestEntity>();
    when(() => firstListenableState.value).thenReturn(firstTestEntity);
    when(
      () => firstListenableState.addListener(
        any(),
      ),
    ).thenAnswer(
      (invocation) {
        firstListener = invocation.positionalArguments[0] as VoidCallback;
      },
    );

    secondListenableState = ListenableStateMock<TestEntity>();
    when(() => secondListenableState.value).thenReturn(secondTestEntity);
    when(
      () => secondListenableState.addListener(
        any(),
      ),
    ).thenAnswer(
      (invocation) {
        secondListener = invocation.positionalArguments[0] as VoidCallback;
      },
    );

    widget = Container();

    builder = MockBuilder<TestEntity, TestEntity>();
    when(() => builder.call(any(), any(), any())).thenReturn(widget);

    testingWidget = DoubleSourceBuilder<TestEntity, TestEntity>(
      firstSource: firstListenableState,
      secondSource: secondListenableState,
      builder: builder.call,
    );
  });

  tearDown(() {
    firstListener = null;
    secondListener = null;
  });

  testWidgets(
    'Values should be taken from both listenableState when init',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => firstListenableState.value).called(1);
      verify(() => secondListenableState.value).called(1);
    },
  );

  testWidgets(
    'Values taken from both listenableState should be used for build',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(
        () => builder.call(
          any(),
          firstTestEntity,
          secondTestEntity,
        ),
      ).called(1);
    },
  );

  testWidgets(
    'Widget inflate should add listener to both sources',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => firstListenableState.addListener(any())).called(1);
      verify(() => secondListenableState.addListener(any())).called(1);
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

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with another listenable states should remove listeners from old listenable states',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: ListenableStateMock<TestEntity>(),
            secondSource: ListenableStateMock<TestEntity>(),
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with same first and another second listenable states should remove listener from second listenable state and ignore first',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: ListenableStateMock<TestEntity>(),
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verifyNever(
            () => firstListenableState.removeListener(firstListener!),
          );

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with same second and another first listenable states should remove listener from first listenable state and ignore second',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: ListenableStateMock<TestEntity>(),
            secondSource: secondListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verifyNever(
            () => secondListenableState.removeListener(secondListener!),
          );
        },
      );

      testWidgets(
        'When widget updated to another widget with different first source, should be added listener to new source',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherListenableState = ListenableStateMock<TestEntity>();

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: anotherListenableState,
            secondSource: secondListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => anotherListenableState.addListener(firstListener!),
          ).called(1);
        },
      );

      testWidgets(
        'When widget updated to another widget with different second source, should be added listener to new source',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherListenableState = ListenableStateMock<TestEntity>();

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: anotherListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => anotherListenableState.addListener(secondListener!),
          ).called(1);
        },
      );

      testWidgets(
        'When widget updated to another widget with different first source, builder should be called with value of new source',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestEntity = TestEntity();
          final anotherListenableState = ListenableStateMock<TestEntity>();
          when(() => anotherListenableState.value)
              .thenReturn(anotherTestEntity);

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: anotherListenableState,
            secondSource: secondListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(() => builder.call(any(), anotherTestEntity, any())).called(1);
        },
      );

      testWidgets(
        'When widget updated to another widget with different second source, builder should be called with value of new source',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestEntity = TestEntity();
          final anotherListenableState = ListenableStateMock<TestEntity>();
          when(() => anotherListenableState.value)
              .thenReturn(anotherTestEntity);

          final anotherTestingWidget =
              DoubleSourceBuilder<TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: anotherListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(() => builder.call(any(), any(), anotherTestEntity)).called(1);
        },
      );
    },
  );

  testWidgets(
    'Call listener for first source should make rebuild with value of first source',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final newTestEntity = TestEntity();
      when(() => firstListenableState.value).thenReturn(newTestEntity);

      firstListener!.call();

      await tester.pump();

      verify(() => builder.call(any(), newTestEntity, any())).called(1);
    },
  );

  testWidgets(
    'Call listener for second source should make rebuild with value of second source',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final newTestEntity = TestEntity();
      when(() => secondListenableState.value).thenReturn(newTestEntity);

      secondListener!.call();

      await tester.pump();

      verify(() => builder.call(any(), any(), newTestEntity)).called(1);
    },
  );
}

class ListenableStateMock<T> extends Mock implements ListenableState<T> {}

class MockBuilder<F, S> extends Mock {
  Widget call(BuildContext context, F? first, S? secondValue);
}

class TestEntity {}

class BuildContextFake extends Fake implements BuildContext {}
