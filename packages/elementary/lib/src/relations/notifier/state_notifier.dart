import 'package:flutter/foundation.dart';

/// Publisher that can store some value. As soon the value is changed
/// all subscribers will be notified about it. When listener is adding it also
/// initiate a notification for exactly this listener.
///
/// ## Limitation
/// This publisher has the almost same behavior as [ValueNotifier],
/// excepting it is not required to be initiated with value during creation.
/// It is make you allow emit the first value lately, but at the same time
/// make the value nullable.
/// If you don't need such behavior for publisher, probably [ValueNotifier]
/// is more suitable.
///
/// See also:
/// [ValueNotifier], [ChangeNotifier]
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
abstract interface class ListenableState<T> extends Listenable {
  /// Returns current state
  T? get value;
}
