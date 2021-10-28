import 'package:elementary/elementary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _TestModel testModel;
  late ErrorHandler errorHandler;

  late Object? _fakeHandlerHub;
  void _fakeWmHandler(Object error) {
    _fakeHandlerHub = error;
  }

  setUp(() {
    _fakeHandlerHub = null;
    errorHandler = MockErrorHandler();
    testModel = _TestModel(errorHandler);
  });

  test('ErrorHandler should get every error from handleError', () {
    final error = Exception('Test');
    final error2 = Exception('Test2');

    testModel
      ..handleError(error)
      ..handleError(error2);

    verify(() => errorHandler.handleError(error)).called(1);
    verify(() => errorHandler.handleError(error2)).called(1);
  });

  test('ErrorHandler should get error in order', () {
    final error = Exception('Test');
    final error2 = Exception('Test2');

    testModel
      ..handleError(error)
      ..handleError(error2);

    verifyInOrder([
      () => errorHandler.handleError(error),
      () => errorHandler.handleError(error2),
    ]);
  });

  test('WidgetModel should get every error from handleError', () {
    testModel.setupWmHandler(_fakeWmHandler);
    final error = Exception('Test');
    final error2 = Exception('Test2');

    testModel.handleError(error);
    expect(_fakeHandlerHub, same(error));

    testModel.handleError(error2);
    expect(_fakeHandlerHub, same(error2));
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
