import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [EntityState].
void main() {
  test('Data should be equal to init data', () {
    const data = 1;
    const state = EntityState<int>(data: data);
    expect(state.data, equals(data));
  });

  test('Error should be equal to init error', () {
    final error = Exception('test');
    final state = EntityState<int>(error: error, hasError: true);
    expect(state.error, equals(error));
  });

  test('Has error should be equal to init has error', () {
    const state = EntityState<int>(hasError: true);
    expect(state.hasError, isTrue);
  });

  test('Loading should be equal to init loading', () {
    const state = EntityState<int>(isLoading: true);
    expect(state.isLoading, isTrue);
  });

  test('Data should be equal to init data', () {
    const state = EntityState<int>(data: 1);
    expect(state.data, 1);
  });

  test('Data should be null if not init', () {
    const state = EntityState<int>();
    expect(state.data, isNull);
  });

  test('Error should be null if not init', () {
    const state = EntityState<int>();
    expect(state.error, isNull);
  });

  test('Loading should be false if not init', () {
    const state = EntityState<int>();
    expect(state.isLoading, isFalse);
  });

  test('Has error should be false if not init', () {
    const state = EntityState<int>();
    expect(state.hasError, isFalse);
  });

  test('Error without hasError should throw assert exception', () {
    final error = Exception('test');
    expect(() => EntityState<int>(error: error), throwsAssertionError);
  });

  test('Loading and Error in same time should throw assert exception', () {
    expect(
      () => EntityState<int>(hasError: true, isLoading: true),
      throwsAssertionError,
    );
  });

  test('Loading constructor should create correct entity', () {
    const state = EntityState<int>.loading();
    expect(state.isLoading, isTrue);
    expect(state.hasError, isFalse);
    expect(state.error, isNull);
  });

  test('Error constructor should create correct entity', () {
    const state = EntityState<int>.error();
    expect(state.isLoading, isFalse);
    expect(state.hasError, isTrue);
  });

  test('Content constructor should create correct entity', () {
    const state = EntityState<int>.content(1);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
    expect(state.data, 1);
  });
}
