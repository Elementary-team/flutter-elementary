import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [EntityStateNotifier]
void main() {
  late EntityStateNotifier<int> testNotifier;

  setUp(() {
    testNotifier = EntityStateNotifier<int>();
  });

  test('Create without init value should create empty value', () {
    final testNotifier = EntityStateNotifier<int>();
    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.data, isNull);
  });

  test('Create with init value should set passed value', () {
    const value = EntityState<int>();
    final testNotifier = EntityStateNotifier<int>(value);
    expect(testNotifier.value, same(value));
  });

  test('Create by value constructor should set correct value', () {
    final testNotifier = EntityStateNotifier<int>.value(100);
    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.data, 100);
  });

  test('Content should set correct entity', () {
    testNotifier.content(200);

    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.data, 200);

    testNotifier.content(1);

    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.data, 1);
  });

  test('Error should set correct entity', () {
    final exception = Exception('test');
    testNotifier.error(exception, 3);

    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.hasError, isTrue);
    expect(testNotifier.value!.isLoading, isFalse);
    expect(testNotifier.value!.error, same(exception));
    expect(testNotifier.value!.data, 3);
  });

  test('Error should set correct entity', () {
    testNotifier.loading(5);

    expect(testNotifier.value, isNotNull);
    expect(testNotifier.value!.isLoading, isTrue);
    expect(testNotifier.value!.hasError, isFalse);
    expect(testNotifier.value!.error, isNull);
    expect(testNotifier.value!.data, 5);
  });
}
