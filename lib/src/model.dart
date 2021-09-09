import 'dart:async';

import 'package:elementary/src/error/error_handler.dart';
import 'package:elementary/src/utils/composite_subscription.dart';
import 'package:flutter/foundation.dart';

abstract class Model {
  final _errorStreamController = StreamController<Object>.broadcast();
  final ErrorHandler _errorHandler;

  final _compositeSubscription = CompositeSubscription();

  Stream<Object> get errorTranslator => _errorStreamController.stream;

  Model(this._errorHandler);

  @protected
  @mustCallSuper
  void handleError(Object error) {
    _errorHandler.handleError(error);
    _errorStreamController.add(error);
  }

  void init() {}

  void doFutureHandleError<T>(
      Future<T> future,
      void Function(T value) onValue, {
        void Function(Object error)? onError,
      }) {
    // ignore: avoid_types_on_closure_parameters
    future.then(onValue).catchError((Object e) {
      handleError(e);
      onError?.call(e);
    });
  }

  StreamSubscription<T> subscribe<T>(
    Stream<T> stream,
    void Function(T value) onValue, {
    void Function(Object error)? onError,
  }) =>
      _compositeSubscription
          .add<T>(stream.listen(onValue, onError: onError?.call));

  StreamSubscription<T> subscribeHandleError<T>(
    Stream<T> stream,
    void Function(T value) onValue, {
    void Function(Object error)? onError,
  }) {
    // ignore: avoid_types_on_closure_parameters
    final subscription = stream.listen(onValue, onError: (Object e) {
      handleError(e);
      onError?.call(e);
    });

    return _compositeSubscription.add<T>(subscription);
  }

  @mustCallSuper
  void dispose() {
    _errorStreamController.close();
    _compositeSubscription.dispose();
  }
}
