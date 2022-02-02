import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  const inCaseOfNull = 'Text in case of null';

  test('nullable argument', () {
    final nullableNotifier = EntityStateNotifier<String?>();

    EntityStateNotifierBuilder<String?>(
      listenableEntityState: nullableNotifier,
      builder: (context, data) {
        return Text(data ?? inCaseOfNull);
      },
    );
  });

  test('strong argument', () {
    final nullableNotifier = EntityStateNotifier<String>();

    EntityStateNotifierBuilder<String>(
      listenableEntityState: nullableNotifier,
      builder: (context, data) {
        return Text(data);
      },
      errorBuilder: (context, exception, lastDataThatMayBeNull) {
        return const Text(inCaseOfNull);
      },
    );
  });
}
