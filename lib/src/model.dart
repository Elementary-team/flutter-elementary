import 'dart:async';

import 'package:elementary/src/error/error_handler.dart';
import 'package:flutter/foundation.dart';

abstract class Model {
  final _errorStreamController = StreamController<Object>.broadcast();
  final ErrorHandler? _errorHandler;

  Stream<Object> get errorTranslator => _errorStreamController.stream;

  Model({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  @protected
  @mustCallSuper
  void handleError(Object error) {
    _errorHandler?.handleError(error);
    _errorStreamController.add(error);
  }

  void init() {}

  @mustCallSuper
  void dispose() {
    _errorStreamController.close();
  }
}
