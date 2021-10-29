import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [StateNotifier]
void main() {
  late StateNotifier<int> testNotifier;

  setUp(() {
    testNotifier = StateNotifier<int>();
  });

  test('Value of notifier without initialValue should be null', () {
    expect(testNotifier.value, isNull);
  });

  test(
    'Value of notifier with initialValue should be equals to initialValue',
    () {
      testNotifier = StateNotifier<int>(initValue: 10);

      expect(testNotifier.value, 10);
    },
  );

  test('Add listener should immediately once call this listener', () {
    var countCall = 0;

    void listener() {
      countCall++;
    }

    testNotifier.addListener(listener);

    expect(countCall, 1);
  });

  test('Accept new value should set value to it', () {
    testNotifier.accept(2);
    expect(testNotifier.value, 2);

    testNotifier.accept(10);
    expect(testNotifier.value, 10);

    testNotifier.accept(1);
    expect(testNotifier.value, 1);
  });

  test('Accept new value should should call all listener', () {
    testNotifier.accept(2);

    var countCall1 = 0;
    var countCall2 = 0;
    var countCall3 = 0;
    var countCall4 = 0;

    void listener1() {
      countCall1++;
    }

    void listener2() {
      countCall2++;
    }

    void listener3() {
      countCall3++;
    }

    void listener4() {
      countCall4++;
    }

    testNotifier
      ..addListener(listener1)
      ..addListener(listener2)
      ..addListener(listener3)
      ..addListener(listener4);

    expect(countCall1, 1);
    expect(countCall2, 1);
    expect(countCall3, 1);
    expect(countCall4, 1);
  });

  test('Accept same value as current should not call listeners', () {
    testNotifier.accept(2);

    var countCall = 0;

    void listener() {
      countCall++;
    }

    testNotifier.addListener(listener);

    expect(countCall, 1);

    testNotifier.accept(2);

    expect(countCall, 1);
  });
}
