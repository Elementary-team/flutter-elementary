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

  test('Model methods must be called as many times as we call them', () {
    final error = Exception('Test');
    final error2 = Exception('Test2');

    testModel
      ..handleError(error)
      ..handleError(error2);

    verify(() => errorHandler.handleError(error)).called(1);
    verify(() => errorHandler.handleError(error2)).called(1);
  });

  test('Model methods calls must be in order', () {
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

  test('Overriding methods inside the Model should work correctly', () {
    testModel.setupWmHandler(_fakeWmHandler);
    final error = Exception('Test');
    final error2 = Exception('Test2');

    testModel.handleError(error);
    expect(_fakeHandlerHub, same(error));

    testModel.handleError(error2);
    expect(_fakeHandlerHub, same(error2));
  });
}

class _TestModel extends Model {
  _TestModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);
}

class MockErrorHandler extends Mock implements ErrorHandler {}
