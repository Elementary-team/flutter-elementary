import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests of the [ElementaryModel].
void main() {
  late _TestModel testModel;
  late ErrorHandler errorHandler;

  late Object? fakeHandlerHub;
  void fakeWmHandler(Object error) {
    fakeHandlerHub = error;
  }

  setUp(() {
    fakeHandlerHub = null;
    errorHandler = MockErrorHandler();
    testModel = _TestModel(errorHandler);
  });

  test('ErrorHandler should get every error from handleError', () {
    final error = Exception('Test');
    final error2 = Exception('Test2');
    final stackTrace = StackTrace.fromString('Test stackTrace');
    final stackTrace2 = StackTrace.fromString('Test2 stackTrace');

    testModel
      ..handleError(error, stackTrace: stackTrace)
      ..handleError(error2, stackTrace: stackTrace2);

    verify(() => errorHandler.handleError(error, stackTrace: stackTrace))
        .called(1);
    verify(() => errorHandler.handleError(error2, stackTrace: stackTrace2))
        .called(1);
  });

  test('ErrorHandler should get error in order', () {
    final error = Exception('Test');
    final error2 = Exception('Test2');
    final stackTrace = StackTrace.fromString('Test stackTrace');
    final stackTrace2 = StackTrace.fromString('Test2 stackTrace');

    testModel
      ..handleError(error, stackTrace: stackTrace)
      ..handleError(error2, stackTrace: stackTrace2);

    verifyInOrder([
      () => errorHandler.handleError(error, stackTrace: stackTrace),
      () => errorHandler.handleError(error2, stackTrace: stackTrace2),
    ]);
  });

  test('WidgetModel should get every error from handleError', () {
    testModel.setupWmHandler(fakeWmHandler);
    final error = Exception('Test');
    final error2 = Exception('Test2');
    final stackTrace = StackTrace.fromString('Test stackTrace');
    final stackTrace2 = StackTrace.fromString('Test2 stackTrace');

    testModel.handleError(error, stackTrace: stackTrace);
    expect(fakeHandlerHub, same(error));

    testModel.handleError(error2, stackTrace: stackTrace2);
    expect(fakeHandlerHub, same(error2));
  });

  test('Init should returns normally', () {
    expect(() => testModel.init(), returnsNormally);
  });

  test('Dispose should returns normally', () {
    expect(() => testModel.dispose(), returnsNormally);
  });
}

class _TestModel extends ElementaryModel {
  _TestModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);
}

class MockErrorHandler extends Mock implements ErrorHandler {}
