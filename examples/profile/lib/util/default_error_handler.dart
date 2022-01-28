import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';

/// Base implementation of error handler.
/// This just print error to console.
class DefaultErrorHandler implements ErrorHandler {
  @override
  void handleError(Object error) {
    if (kDebugMode) {
      print(error);
    }
  }
}
