import 'dart:async';

import 'package:elementary_helper/src/execution/execution_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExecutionHandler', () {
    late List<Object> capturedErrors;
    late ExecutionHandler handler;

    setUp(() {
      capturedErrors = [];
      handler = ExecutionHandler(
        errorHandler: (error, {stackTrace}) => capturedErrors.add(error),
      );
    });

    tearDown(() {
      handler.dispose();
    });

    test('returns the result of the operation', () async {
      final result = await handler.exec(() async => 42);

      expect(result, 42);
    });

    test('calls errorHandler when operation throws', () async {
      final error = Exception('boom');

      try {
        await handler.exec<void>(() async => throw error);
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {}

      expect(capturedErrors, [error]);
    });

    test('future completes with error when operation throws', () async {
      final error = Exception('boom');

      await expectLater(
        handler.exec<void>(() async => throw error),
        throwsA(same(error)),
      );
    });

    test('multiple operations run concurrently', () async {
      final order = <int>[];
      final completer1 = Completer<void>();
      final completer2 = Completer<void>();

      final f1 = handler.exec(() async {
        await completer1.future;
        order.add(1);
      });
      final f2 = handler.exec(() async {
        await completer2.future;
        order.add(2);
      });

      // Complete second first to confirm there is no sequential dependency
      completer2.complete();
      await f2;
      expect(order, [2]);

      completer1.complete();
      await f1;
      expect(order, [2, 1]);
    });

    test('throws StateError when exec is called after dispose', () {
      handler.dispose();

      expect(
        () => handler.exec(() async => 42),
        throwsA(isA<StateError>()),
      );
    });

    test(
      'dispose cancels pending tasks — completers are never completed',
      () async {
        final blocker = Completer<void>();
        var operationCompleted = false;

        final future = handler.exec(() async {
          await blocker.future;
          return 1;
        });

        unawaited(future.then((_) {
          operationCompleted = true;
        }).catchError((_) {}));

        handler.dispose();
        blocker.complete();

        await Future<void>.delayed(Duration.zero);

        expect(operationCompleted, isFalse);
      },
    );
  });

  group('SequentialExecutionHandler', () {
    late List<Object> capturedErrors;
    late SequentialExecutionHandler handler;

    setUp(() {
      capturedErrors = [];
      handler = SequentialExecutionHandler(
        errorHandler: (error, {stackTrace}) => capturedErrors.add(error),
      );
    });

    tearDown(() {
      handler.dispose();
    });

    test('returns the result of the operation', () async {
      final result = await handler.exec(() async => 42);

      expect(result, 42);
    });

    test('calls errorHandler when operation throws', () async {
      final error = Exception('boom');

      try {
        await handler.exec<void>(() async => throw error);
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {}

      expect(capturedErrors, [error]);
    });

    test('future completes with error when operation throws', () async {
      final error = Exception('boom');

      await expectLater(
        handler.exec<void>(() async => throw error),
        throwsA(same(error)),
      );
    });

    test('operations are executed sequentially in submission order', () async {
      final order = <int>[];
      final completer1 = Completer<void>();

      // First operation blocks until completer1 is resolved
      final f1 = handler.exec(() async {
        await completer1.future;
        order.add(1);
      });

      // Second operation is queued while the first is still running
      final f2 = handler.exec(() async {
        order.add(2);
      });

      // Even though f2 body is instant, it must wait for f1 to finish
      completer1.complete();
      await Future.wait([f1, f2]);

      expect(order, [1, 2]);
    });

    test('second operation starts only after first completes', () async {
      var firstCompleted = false;
      final blocker = Completer<void>();

      final f1 = handler.exec(() async {
        await blocker.future;
        firstCompleted = true;
      });

      var secondStarted = false;
      final f2 = handler.exec(() async {
        secondStarted = true;
      });

      // f2 must not have started yet
      await Future<void>.delayed(Duration.zero);
      expect(secondStarted, isFalse);

      blocker.complete();
      await Future.wait([f1, f2]);
      expect(firstCompleted, isTrue);
      expect(secondStarted, isTrue);
    });

    test('second operation runs even if first throws', () async {
      var secondRan = false;

      final f1 = handler.exec<void>(() async => throw Exception('first fails'));
      final f2 = handler.exec(() async {
        secondRan = true;
      });

      try {
        await Future.wait([f1, f2]);
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {}

      expect(secondRan, isTrue);
    });

    test('throws StateError when exec is called after dispose', () {
      handler.dispose();

      expect(
        () => handler.exec(() async => 42),
        throwsA(isA<StateError>()),
      );
    });

    test('dispose cancels queued tasks that have not started yet', () async {
      final blocker = Completer<void>();
      var queuedTaskRan = false;

      // First task holds the queue
      unawaited(handler.exec(() async {
        await blocker.future;
      }));

      // Second task is queued but not yet started
      unawaited(handler.exec(() async {
        queuedTaskRan = true;
      }));

      handler.dispose();
      blocker.complete();

      // Give microtask queue a chance to settle
      await Future<void>.delayed(Duration.zero);
      expect(queuedTaskRan, isFalse);
    });

    test(
      'no StateError when dispose is called while a task is running',
      () async {
        final blocker = Completer<void>();

        unawaited(handler.exec(() async {
          await blocker.future;
        }));

        handler.dispose();
        blocker.complete();

        await Future<void>.delayed(Duration.zero);
      },
    );
  });
}
