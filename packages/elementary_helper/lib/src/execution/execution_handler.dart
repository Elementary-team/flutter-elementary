import 'dart:async';
import 'dart:collection';

import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';

/// A mixin that provides execution handling capabilities to Elementary models.
mixin Executor on ElementaryModel {
  late final _handler = ExecutionHandler(
    errorHandler: handleError,
  );

  /// Executes the given asynchronous [operation] providing error handling and
  /// lifecycle management.
  Future<T> exec<T>(
    Future<T> Function() operation,
  ) =>
      _handler.exec(operation);

  @override
  void dispose() {
    _handler.dispose();

    super.dispose();
  }
}

/// A mixin that provides sequential execution handling capabilities to
/// Elementary models.
mixin SequentialExecutor on ElementaryModel {
  late final _handler = SequentialExecutionHandler(
    errorHandler: handleError,
  );

  /// Executes the given asynchronous [operation] providing error handling and
  /// lifecycle management.
  Future<T> exec<T>(
    Future<T> Function() operation,
  ) =>
      _handler.exec(operation);

  @override
  void dispose() {
    _handler.dispose();

    super.dispose();
  }
}

/// A supportive class that handles the execution of asynchronous operations,
/// providing error handling and lifecycle management.
final class ExecutionHandler extends _ExecutionHandler {
  final _tasks = <_Task<dynamic>>{};

  /// Creates an instance of [ExecutionHandler].
  ExecutionHandler({
    required super.errorHandler,
  });

  @override
  void dispose() {
    for (final task in _tasks) {
      task.dispose();
    }
    _tasks.clear();

    super.dispose();
  }

  @override
  Future<T> _handleTask<T>(_Task<T> task) {
    final future = task.future;
    future.whenComplete(() {
      _tasks.remove(task);
    }).ignore();

    _tasks.add(task..run());

    return future;
  }
}

/// A supportive class that handles the execution of asynchronous operations
/// sequentially, providing error handling and lifecycle management.
///
/// Tasks are executed one after another in the order they were added.
/// After disposal existing tasks are disposed of too, and will not be executed.
/// Except the one is currently running.
final class SequentialExecutionHandler extends _ExecutionHandler {
  final _queue = DoubleLinkedQueue<_Task<dynamic>>();
  Future<void>? _processing;

  /// Creates an instance of [SequentialExecutionHandler].
  SequentialExecutionHandler({
    required super.errorHandler,
  });

  @override
  void dispose() {
    for (final task in _queue) {
      task.dispose();
    }
    _queue.clear();

    super.dispose();
  }

  @override
  Future<T> _handleTask<T>(_Task<T> task) {
    _queue.add(task);
    _startIfNotYet();

    return task.future;
  }

  void _startIfNotYet() {
    _processing ??= _processUntilEmpty();
  }

  Future<void> _processUntilEmpty() async {
    await Future.doWhile(() async {
      final currentTask = _queue.first;
      final currentFuture = currentTask.future;

      currentTask.run();
      try {
        await currentFuture;
        // Handling error is not here. We just need to have a fact that future
        // has finished, without propagating errors.
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // we don't need to handle anything here
      } finally {
        if (!_isDisposed) {
          _queue.removeFirst();
        }
      }

      if (_queue.isEmpty) {
        _processing = null;
        return false;
      } else {
        return true;
      }
    });
  }
}

abstract base class _ExecutionHandler {
  final void Function(Object error, {StackTrace? stackTrace})? _errorHandler;

  bool _isDisposed = false;

  _ExecutionHandler({
    required void Function(Object error, {StackTrace? stackTrace})?
        errorHandler,
  }) : _errorHandler = errorHandler;

  @nonVirtual
  Future<T> exec<T>(
    Future<T> Function() operation,
  ) {
    if (_isDisposed) {
      throw StateError(
        'Cannot execute operation on a disposed ExecutionHandler.',
      );
    }

    return _handleTask(
      _Task<T>(
        operation: operation,
        errorHandler: handleError,
      ),
    );
  }

  @mustCallSuper
  void dispose() {
    _isDisposed = true;
  }

  @mustCallSuper
  @protected
  void handleError(Object error, StackTrace stackTrace) {
    _errorHandler?.call(error, stackTrace: stackTrace);
  }

  Future<T> _handleTask<T>(
    _Task<T> task,
  );
}

class _Task<T> {
  final void Function(Object error, StackTrace stackTrace) _errorHandler;
  final Future<T> Function() _operation;
  final _completer = Completer<T>();
  bool _isDisposed = false;

  bool get _isCompletable => !_isDisposed && !_completer.isCompleted;
  Future<T> get future => _completer.future;

  _Task({
    required void Function(Object error, StackTrace stackTrace) errorHandler,
    required Future<T> Function() operation,
  })  : _errorHandler = errorHandler,
        _operation = operation;

  void run() {
    runZonedGuarded<void>(
      () async {
        try {
          if (!_isCompletable) {
            return;
          }

          final result = await _operation();

          if (_isCompletable) {
            _completer.complete(result);
          }
        } on Object catch (error, stackTrace) {
          _errorHandler.call(error, stackTrace);

          if (_isCompletable) {
            _completer.completeError(error, stackTrace);
          }
        }
      },
      _guard,
    );
  }

  void dispose() {
    _isDisposed = true;
  }

  void _guard(Object error, StackTrace stackTrace) {
    assert(
      false,
      'An unhandled error occurred in the execution task zone.\nError: $error',
    );

    _errorHandler.call(error, stackTrace);

    if (_isCompletable) {
      // shouldn't be but just in case
      _completer.completeError(error, stackTrace);
    }
  }
}
