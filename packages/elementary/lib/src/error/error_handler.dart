import 'package:flutter/foundation.dart';

/// Interface for handle error in business logic.
/// It may be something like write log or else.
///
/// !!! This is not meant to be used in the presentation layer for handling
/// errors.
abstract interface class ErrorHandler {
  /// This method have to handle of passed error and optional [StackTrace].
  void handleError(Object error, {StackTrace? stackTrace});
}

/// The simplest error handler that just prints error to the console in
/// debug mode.
class DefaultDebugErrorHandler implements ErrorHandler {
  @override
  void handleError(Object error, {StackTrace? stackTrace}) {
    debugPrint(error.toString());
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
