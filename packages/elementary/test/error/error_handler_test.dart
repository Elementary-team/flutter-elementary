import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [DefaultDebugErrorHandler].
void main() {
  late DefaultDebugErrorHandler debugErrorHandler;
  late MockDebugPrintCallback callback;

  setUp(() {
    debugErrorHandler = DefaultDebugErrorHandler();
    callback = MockDebugPrintCallback();
    debugPrint = callback.call;
  });

  test('Call handing error should not throw exception', () {
    expect(
      () => debugErrorHandler.handleError(
        Exception('test'),
        stackTrace: StackTrace.empty,
      ),
      returnsNormally,
    );
  });

  test('Call handing error should print debug', () {
    final exception = Exception('test');
    debugErrorHandler.handleError(exception);

    verify(() => callback.call(exception.toString())).called(1);
  });
}

class MockDebugPrintCallback extends Mock {
  void call(String? message, {int? wrapWidth});
}
