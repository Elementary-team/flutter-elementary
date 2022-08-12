/// Interface for handle error in business logic.
/// It may be something like write log or else.
///
/// !!! This not for Presentation Layer handling.
abstract class ErrorHandler {
  /// This method have to handle of passed error and optional [StackTrace].
  void handleError(Object error, StackTrace? stackTrace);
}
