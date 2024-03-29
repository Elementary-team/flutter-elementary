import 'package:elementary_helper/src/relations/builder/entity_state_notifier_builder.dart';
import 'package:elementary_helper/src/relations/notifier/entity_state_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [EntityStateNotifierBuilder].
void main() {
  late EntityState<TestEntity> testEntity;
  late EntityStateNotifierBuilder<TestEntity> testingWidget;
  late ListenableEntityStateMock<TestEntity> listenableState;
  late MockBuilder<TestEntity> builder;
  late MockLoaderBuilder<TestEntity> loaderBuilder;
  late MockErrorBuilder<TestEntity> errorBuilder;
  late Widget widget;

  setUp(() {
    registerFallbackValue(BuildContextFake());

    listenableState = ListenableEntityStateMock<TestEntity>();

    widget = Container();
    builder = MockBuilder<TestEntity>();
    loaderBuilder = MockLoaderBuilder<TestEntity>();
    errorBuilder = MockErrorBuilder<TestEntity>();
    when(() => builder.call(any(), any())).thenReturn(widget);
    when(() => loaderBuilder.call(any(), any())).thenReturn(widget);
    when(() => errorBuilder.call(any(), any(), any())).thenReturn(widget);

    testingWidget = EntityStateNotifierBuilder<TestEntity>(
      listenableEntityState: listenableState,
      builder: builder.call,
      errorBuilder: errorBuilder.call,
      loadingBuilder: loaderBuilder.call,
    );
  });

  testWidgets(
    'When state with content should call build method',
    (tester) async {
      final testData = TestEntity();
      testEntity = EntityState<TestEntity>.content(testData);
      when(() => listenableState.value).thenReturn(testEntity);

      await tester.pumpWidget(testingWidget);

      verify(() => builder.call(any(), testData)).called(1);
    },
  );

  testWidgets(
    'When loading state should call loadingBuilder method',
    (tester) async {
      final testData = TestEntity();
      testEntity = EntityState<TestEntity>.loading(testData);
      when(() => listenableState.value).thenReturn(testEntity);

      await tester.pumpWidget(testingWidget);

      verify(() => loaderBuilder.call(any(), testData)).called(1);
    },
  );

  testWidgets(
    'When error state should call errorBuilder method',
    (tester) async {
      final testData = TestEntity();
      final exception = Exception('test');
      testEntity = EntityState<TestEntity>.error(exception, testData);
      when(() => listenableState.value).thenReturn(testEntity);

      await tester.pumpWidget(testingWidget);

      verify(() => errorBuilder.call(any(), exception, testData)).called(1);
    },
  );

  testWidgets(
    'Default builder should be called for error state when errorBuilder is not set',
    (tester) async {
      final testData = TestEntity();
      final exception = Exception('test');
      testEntity = EntityState<TestEntity>.error(exception, testData);
      when(() => listenableState.value).thenReturn(testEntity);
      testingWidget = EntityStateNotifierBuilder<TestEntity>(
        listenableEntityState: listenableState,
        builder: builder.call,
      );

      await tester.pumpWidget(testingWidget);

      verify(() => builder.call(any(), testData)).called(1);
    },
  );

  testWidgets(
    'Default builder should be called for loading state when loadingBuilder is not set',
    (tester) async {
      final testData = TestEntity();
      testEntity = EntityState<TestEntity>.loading(testData);
      when(() => listenableState.value).thenReturn(testEntity);
      testingWidget = EntityStateNotifierBuilder<TestEntity>(
        listenableEntityState: listenableState,
        builder: builder.call,
      );

      await tester.pumpWidget(testingWidget);

      verify(() => builder.call(any(), testData)).called(1);
    },
  );
}

class ListenableEntityStateMock<T> extends Mock
    implements ValueListenable<EntityState<T>> {}

class MockBuilder<T> extends Mock {
  Widget call(BuildContext context, T? value);
}

class MockLoaderBuilder<T> extends Mock {
  Widget call(BuildContext context, T? value);
}

class MockErrorBuilder<T> extends Mock {
  Widget call(BuildContext context, Exception? e, T? value);
}

class TestEntity {}

class BuildContextFake extends Fake implements BuildContext {}
