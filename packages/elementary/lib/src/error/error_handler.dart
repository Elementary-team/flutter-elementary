/// Interface for handle error in business logic.
/// It may be something like write log or else.
///
/// !!! This not for Presentation Layer handling.
abstract class ErrorHandler {
  /// This method have to handle of passed error.
  void handleError(Object error);
}
