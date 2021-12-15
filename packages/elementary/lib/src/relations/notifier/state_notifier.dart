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
  EntityStateNotifier([EntityState<T>? initialData])
      : super(initValue: initialData ?? EntityState<T>());

  /// Constructor for easy set initial value.
  EntityStateNotifier.value(T initialData)
      : super(
          initValue: EntityState<T>(data: initialData),
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

/// State of some logical entity.
class EntityState<T> {
  /// Data of entity.
  final T? data;

  /// State is loading.
  final bool isLoading;

  /// State has error.
  final bool hasError;

  /// Exception from state.
  final Exception? error;

  /// Create an instance of EntityState.
  const EntityState({
    this.data,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  })  : assert(error == null || hasError),
        assert(!hasError && !isLoading || hasError != isLoading);

  /// Loading constructor
  const EntityState.loading([this.data])
      : isLoading = true,
        hasError = false,
        error = null;

  /// Error constructor
  const EntityState.error([this.error, this.data])
      : isLoading = false,
        hasError = true;

  /// Content constructor
  const EntityState.content(this.data)
      : isLoading = false,
        hasError = false,
        error = null;
}
