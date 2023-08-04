import 'package:elementary_helper/src/relations/notifier/entity_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [EntityState].
void main() {
  test('Data for every type of states should be equal to init data', () {
    const data = 1;
    final state = EntityState<int>.content(data);
    final loadingState = EntityState<int>.loading(data);
    final errorState = EntityState<int>.error(null, data);

    expect(state.data, equals(data));
    expect(loadingState.data, equals(data));
    expect(errorState.data, equals(data));
  });

  test('Data for every type should be null if is not init', () {
    final state = EntityState<int>.content();
    final loadingState = EntityState<int>.loading();
    final errorState = EntityState<int>.error();

    expect(state.data, isNull);
    expect(loadingState.data, isNull);
    expect(errorState.data, isNull);
  });

  test('Content factory should return ContentEntityState instance', () {
    const data = 1;
    final state = EntityState<int>.content(data);

    expect(state, const TypeMatcher<ContentEntityState<int>>());
  });

  test('Error factory should return ErrorEntityState instance', () {
    final error = Exception('test');
    final state = EntityState<int>.error(error);

    expect(state, const TypeMatcher<ErrorEntityState<int>>());
  });

  test('Loading factory should return LoadingEntityState instance', () {
    const data = 1;
    final state = EntityState<int>.loading(data);

    expect(state, const TypeMatcher<LoadingEntityState<int>>());
  });

  test('Error for error state should be equal to init error', () {
    final error = Exception('test');
    final state = EntityState<int>.error(error);

    expect((state as ErrorEntityState).error, equals(error));
  });

  test('isErrorState should return correct result', () {
    final state = EntityState<int>.content(1);
    final loadingState = EntityState<int>.loading(1);
    final errorState = EntityState<int>.error(null, 1);

    expect(state.isErrorState, isFalse);
    expect(loadingState.isErrorState, isFalse);
    expect(errorState.isErrorState, isTrue);
  });

  test('isLoadingState should return correct result', () {
    final state = EntityState<int>.content(1);
    final loadingState = EntityState<int>.loading(1);
    final errorState = EntityState<int>.error(null, 1);

    expect(state.isLoadingState, isFalse);
    expect(loadingState.isLoadingState, isTrue);
    expect(errorState.isLoadingState, isFalse);
  });

  test('errorOrNull should return correct result', () {
    final error = Exception('test');
    final state = EntityState<int>.content(1);
    final loadingState = EntityState<int>.loading(1);
    final errorState = EntityState<int>.error(error, 1);
    final errorStateWithoutError = EntityState<int>.error(null, 1);

    expect(state.errorOrNull, isNull);
    expect(loadingState.errorOrNull, isNull);
    expect(errorStateWithoutError.errorOrNull, isNull);
    expect(errorState.errorOrNull, equals(error));
  });
}
