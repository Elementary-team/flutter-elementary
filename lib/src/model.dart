import 'dart:async';

import 'package:elementary/src/error/error_handler.dart';
import 'package:flutter/foundation.dart';

/// Class that contains a business logic for Widget.
///
/// You can write this freestyle. It may be collection of methods,
/// streams or something else.
///
/// This class can take [ErrorHandler] for handling caught error
/// like a logging or something else. This realize by using
/// [handleError] method. This method also notifies the Widget Model about the
/// error that has occurred. You can use onErrorHandle method of Widget Model
/// to handle on UI like show snackbar or something else.
abstract class Model {
  final _errorStreamController = StreamController<Object>.broadcast();
  final ErrorHandler? _errorHandler;

  Stream<Object> get errorTranslator => _errorStreamController.stream;

  Model({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  /// Should be used for report error Error Handler if it was set and notify
  /// Widget Model about error.
  @protected
  @mustCallSuper
  void handleError(Object error) {
    _errorHandler?.handleError(error);
    _errorStreamController.add(error);
  }

  /// Method for initialize this Model.
  ///
  /// Will be call at first build when Widget Model created.
  void init() {}

  /// Called when Widget Model disposing.
  @mustCallSuper
  void dispose() {
    _errorStreamController.close();
  }
}
