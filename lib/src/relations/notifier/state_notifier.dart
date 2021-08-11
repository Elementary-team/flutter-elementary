import 'package:flutter/material.dart';

class StateNotifier<T> extends ChangeNotifier implements ListenableState<T> {
  T? _value;

  StateNotifier({T? initValue}) : _value = initValue;

  T? get value => _value;

  void accept(T? newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    listener.call();
  }
}

abstract class ListenableState<T> extends Listenable {
  T? get value;
}

class EntityStateNotifier<T> extends StateNotifier<EntityState<T>> {
  EntityStateNotifier([EntityState<T>? initialData])
      : super(initValue: initialData ?? EntityState<T>());

  EntityStateNotifier.value(T initialData)
      : super(
          initValue: EntityState<T>(data: initialData),
        );

  void content(T data) => super.accept(EntityState<T>.content(data));

  void error([Exception? exception, T? data]) =>
      super.accept(EntityState<T>.error(exception, data));

  void loading([T? previousData]) =>
      super.accept(EntityState<T>.loading(previousData));
}

/// State of some logical entity
class EntityState<T> {
  /// Data of entity
  final T? data;

  /// State is loading
  final bool isLoading;

  /// State has error
  final bool hasError;

  /// Exception from state
  final Exception? error;

  const EntityState({
    this.data,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

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
