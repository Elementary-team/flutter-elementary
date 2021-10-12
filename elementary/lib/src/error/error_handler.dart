/// Interface for handle error in business logic.
/// It may be something like write log or else.
///
/// !!! This not for Presentation Layer handling.
abstract class ErrorHandler {
  void handleError(Object error);
}
