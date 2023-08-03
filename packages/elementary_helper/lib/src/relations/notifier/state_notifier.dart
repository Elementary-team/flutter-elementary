import 'package:flutter/foundation.dart';

/// Publisher that can store a value. Whenever the value changes,
/// all subscribers will be notified. When a listener is added, it also
/// initiates a notification specifically for that listener.
///
/// ## Limitation
/// This publisher behaves almost the same as [ValueNotifier],
/// except that it is not required to be initialized with a value
/// during creation.
/// This allows you to emit the first value later, but it also makes the
/// value nullable.
/// If you don't need this behavior for the publisher, [ValueNotifier]
/// is likely more suitable.
///
/// See also:
/// * [ValueNotifier]
/// * [ChangeNotifier]
class StateNotifier<T> extends ChangeNotifier implements ListenableState<T> {
  @override
  T? get value => _value;

  T? _value;

  /// Create an instance of [StateNotifier].
  StateNotifier({T? initValue}) : _value = initValue;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    listener.call();
  }

  /// Accept a new value.
  void accept(T? newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}

/// An interface for instances that can be listened and return current value.
///
/// {@template state_notifier.short_description}
/// Basically, it is the state that is used to detect changes and
/// trigger a rebuild.
/// {@endtemplate}
abstract interface class ListenableState<T> extends Listenable {
  /// Returns current state.
  T? get value;
}
