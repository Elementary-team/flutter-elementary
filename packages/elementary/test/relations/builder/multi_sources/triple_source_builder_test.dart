import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [TripleSourceBuilder].
void main() {
  late TestEntity firstTestEntity;
  late TestEntity secondTestEntity;
  late TestEntity thirdTestEntity;
  late TripleSourceBuilder<TestEntity, TestEntity, TestEntity> testingWidget;
  late ListenableStateMock<TestEntity> firstListenableState;
  late ListenableStateMock<TestEntity> secondListenableState;
  late ListenableStateMock<TestEntity> thirdListenableState;
  late MockBuilder<TestEntity, TestEntity, TestEntity> builder;
  late Widget widget;
  late VoidCallback? firstListener;
  late VoidCallback? secondListener;
  late VoidCallback? thirdListener;

  setUp(() {
    registerFallbackValue(BuildContextFake());

    firstTestEntity = TestEntity();
    secondTestEntity = TestEntity();
    thirdTestEntity = TestEntity();

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

    thirdListenableState = ListenableStateMock<TestEntity>();
    when(() => thirdListenableState.value).thenReturn(thirdTestEntity);
    when(
      () => thirdListenableState.addListener(
        any(),
      ),
    ).thenAnswer(
      (invocation) {
        thirdListener = invocation.positionalArguments[0] as VoidCallback;
      },
    );

    widget = Container();

    builder = MockBuilder<TestEntity, TestEntity, TestEntity>();
    when(() => builder.call(any(), any(), any(), any())).thenReturn(widget);

    testingWidget = TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
      firstSource: firstListenableState,
      secondSource: secondListenableState,
      thirdSource: thirdListenableState,
      builder: builder.call,
    );
  });

  tearDown(() {
    firstListener = null;
    secondListener = null;
    thirdListener = null;
  });

  testWidgets(
    'Values should be taken from all listenableState when init',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => firstListenableState.value).called(1);
      verify(() => secondListenableState.value).called(1);
      verify(() => thirdListenableState.value).called(1);
    },
  );

  testWidgets(
    'Values taken from all listenableState should be used for build',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(
        () => builder.call(
          any(),
          firstTestEntity,
          secondTestEntity,
          thirdTestEntity,
        ),
      ).called(1);
    },
  );

  testWidgets(
    'Widget inflate should add listener to all sources',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      verify(() => firstListenableState.addListener(any())).called(1);
      verify(() => secondListenableState.addListener(any())).called(1);
      verify(() => thirdListenableState.addListener(any())).called(1);
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

          verify(
            () => thirdListenableState.removeListener(thirdListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with another listenable states should remove listeners from old listenable states',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: ListenableStateMock<TestEntity>(),
            secondSource: ListenableStateMock<TestEntity>(),
            thirdSource: ListenableStateMock<TestEntity>(),
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);

          verify(
            () => thirdListenableState.removeListener(thirdListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with same first and another others listenable states should remove listener from all listenable state except first',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: ListenableStateMock<TestEntity>(),
            thirdSource: ListenableStateMock<TestEntity>(),
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verifyNever(
            () => firstListenableState.removeListener(firstListener!),
          );

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);

          verify(
            () => thirdListenableState.removeListener(thirdListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with same second and another others listenable states should remove listener from all listenable state except second',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: ListenableStateMock<TestEntity>(),
            secondSource: secondListenableState,
            thirdSource: ListenableStateMock<TestEntity>(),
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verifyNever(
            () => secondListenableState.removeListener(secondListener!),
          );

          verify(
            () => thirdListenableState.removeListener(thirdListener!),
          ).called(1);
        },
      );

      testWidgets(
        'Update widget with same third and another others listenable states should remove listener from all listenable state except third',
        (tester) async {
          await tester.pumpWidget(testingWidget);

          final anotherTestingWidget =
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: ListenableStateMock<TestEntity>(),
            secondSource: ListenableStateMock<TestEntity>(),
            thirdSource: thirdListenableState,
            builder: builder.call,
          );

          await tester.pumpWidget(anotherTestingWidget);

          verify(
            () => firstListenableState.removeListener(firstListener!),
          ).called(1);

          verify(
            () => secondListenableState.removeListener(secondListener!),
          ).called(1);

          verifyNever(
            () => thirdListenableState.removeListener(thirdListener!),
          );
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
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: anotherListenableState,
            secondSource: secondListenableState,
            thirdSource: thirdListenableState,
            builder: builder.call,
          );
          await tester.pumpWidget(anotherTestingWidget);

          verify(() => builder.call(any(), anotherTestEntity, any(), any()))
              .called(1);
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
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: anotherListenableState,
            thirdSource: thirdListenableState,
            builder: builder.call,
          );
          await tester.pumpWidget(anotherTestingWidget);

          verify(() => builder.call(any(), any(), anotherTestEntity, any()))
              .called(1);
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
              TripleSourceBuilder<TestEntity, TestEntity, TestEntity>(
            firstSource: firstListenableState,
            secondSource: secondListenableState,
            thirdSource: anotherListenableState,
            builder: builder.call,
          );
          await tester.pumpWidget(anotherTestingWidget);

          verify(() => builder.call(any(), any(), any(), anotherTestEntity))
              .called(1);
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

      verify(() => builder.call(any(), newTestEntity, any(), any())).called(1);
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

      verify(() => builder.call(any(), any(), newTestEntity, any())).called(1);
    },
  );

  testWidgets(
    'Call listener for third source should make rebuild with value of third source',
    (tester) async {
      await tester.pumpWidget(testingWidget);

      final newTestEntity = TestEntity();
      when(() => thirdListenableState.value).thenReturn(newTestEntity);

      thirdListener!.call();

      await tester.pump();

      verify(() => builder.call(any(), any(), any(), newTestEntity)).called(1);
    },
  );
}

class ListenableStateMock<T> extends Mock implements ListenableState<T> {}

class MockBuilder<F, S, T> extends Mock {
  Widget call(BuildContext context, F? first, S? second, T? third);
}

class TestEntity {}

class BuildContextFake extends Fake implements BuildContext {}
