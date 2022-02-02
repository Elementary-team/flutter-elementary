import 'package:flutter/material.dart';

/// Source of some listenable property.
///
/// You can set initial value by pass initValue to constructor.
class StateNotifier<T> extends ChangeNotifier implements ListenableState<T> {
  @override
  T? get value => _value;

  T? _value;

  /// Create an instance of StateNotifier.
  StateNotifier({T? initValue}) : _value = initValue;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    listener.call();
  }

  /// Accept new value.
  void accept(T? newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}

/// An interface that can be listened and return current value.
abstract class ListenableState<T> extends Listenable {
  /// Return current state
  T? get value;
}

/// Change notifier with value that presented by [EntityState].
///
/// Empty initial value create empty EntityState for initial value.
class EntityStateNotifier<T> extends StateNotifier<EntityState<T>> {
  /// Create an instance of EntityStateNotifier.
  // TODO: there is a problem with "empty" state of entity
  // EntityStateNotifier([EntityState<T>? initialData])
  //     : super(initValue: initialData ?? EntityState<T>());

  /// Constructor for easy set initial value.
  EntityStateNotifier.value(T initialData)
      : super(
          initValue: EntityState<T>.content(initialData),
        );

  /// Accept state with content.
  void content(T data) => super.accept(EntityState<T>.content(data));

  /// Accept state with error.
  void error([Exception? exception, T? data]) =>
      super.accept(EntityState<T>.error(exception, data));

  /// Accept loading state.
  void loading([T? previousData]) =>
      super.accept(EntityState<T>.loading(previousData));
}

class EntityState<T> {
  bool get hasError => this is EntityStateError<T>;

  bool get isLoading => this is EntityStateLoading<T>;

  T? get data => null;

  const EntityState._();

  const factory EntityState.content(T data) = EntityStateContent<T>;

  const factory EntityState.loading([T? data]) = EntityStateLoading<T>;

  const factory EntityState.error([Exception? error, T? data]) =
      EntityStateError<T>;
}

class EntityStateContent<T> extends EntityState<T> {
  @override
  final T data;

  const EntityStateContent(this.data) : super._();
}

class EntityStateLoading<T> extends EntityState<T> {
  @override
  final T? data;

  const EntityStateLoading([this.data]) : super._();
}

class EntityStateError<T> extends EntityState<T> {
  final Exception? error;

  @override
  final T? data;

  const EntityStateError([this.error, this.data]) : super._();
}
