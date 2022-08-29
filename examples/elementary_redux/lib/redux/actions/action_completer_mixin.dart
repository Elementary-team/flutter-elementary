import 'dart:async';

mixin ActionCompleterMixin {
  final _completer = Completer<void>();

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  void completeError(Object error, [StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(
        error,
        stackTrace,
      );
    }
  }

  Future<void> get future => _completer.future;
}
