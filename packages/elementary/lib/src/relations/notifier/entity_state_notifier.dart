import 'package:flutter/foundation.dart';

/// Publisher that uses [EntityState] to describe concrete state of stored data.
class EntityStateNotifier<T> extends ValueNotifier<EntityState<T>>
    implements EntityValueListenable<T> {
  /// Creates an instance of [EntityStateNotifier].
  EntityStateNotifier([EntityState<T>? initialData])
      : super(initialData ?? EntityState<T>.content());

  /// Creates an instance of [EntityStateNotifier] with initial value.
  EntityStateNotifier.value(T initialData)
      : super(
          EntityState<T>.content(initialData),
        );

  /// Sets current state to content.
  void content(T data) {
    value = EntityState<T>.content(data);
  }

  /// Sets current state to error.
  void error([Exception? exception, T? data]) {
    value = EntityState<T>.error(exception, data);
  }

  /// Sets current state to loading.
  void loading([T? previousData]) {
    value = EntityState<T>.loading(previousData);
  }
}

/// Describes the state of the stored value. It can be helpful when
/// interacting with values over the network or other options involving
/// long asynchronous operations.
///
/// It can be in one of three possible states:
/// ## Loading
/// This state indicates that the value is currently being loaded.
/// This state doesn't exclude the existence of a value while the actual value
/// is being in loading, such as the previous value.
/// Concrete implementation for this state is [LoadingEntityState].
/// ## error
/// This state indicates that there is a problem with the value,
/// such as an exception occurring during the loading process.
/// This state doesn't exclude the existence of a value, for example
/// it can refer to the previous value, but emphasizes the presence of problems.
/// Concrete implementation for this state is [ErrorEntityState].
/// ## content
/// This state means some value is stored, without highlight additional aspects.
/// Concrete implementation for this state is [ContentEntityState].
sealed class EntityState<T> {
  /// Data of entity.
  final T? data;

  /// Create an instance of EntityState.
  const EntityState({
    this.data,
  });

  /// Loading constructor.
  factory EntityState.loading([T? data]) {
    return LoadingEntityState<T>(data: data);
  }

  /// Error constructor.
  factory EntityState.error([Exception? error, T? data]) {
    return ErrorEntityState<T>(error: error, data: data);
  }

  /// Content constructor.
  factory EntityState.content([T? data]) {
    return ContentEntityState<T>(data: data);
  }

  /// Is it error state.
  bool get isErrorState => switch (this) {
        ErrorEntityState<T>() => true,
        _ => false,
      };

  /// Is it error state.
  bool get isLoadingState => switch (this) {
        LoadingEntityState<T>() => true,
        _ => false,
      };

  /// Returns error if exist or null otherwise.
  Exception? get errorOrNull => switch (this) {
        final ErrorEntityState<T> errorState => errorState.error,
        _ => null,
      };
}

/// Entity that describes general state of data storing.
final class ContentEntityState<T> extends EntityState<T> {
  /// Creates an instance of [ContentEntityState].
  const ContentEntityState({super.data});
}

/// Entity that describes state of loading data or long interaction.
final class LoadingEntityState<T> extends ContentEntityState<T> {
  /// Creates an instance of [LoadingEntityState].
  const LoadingEntityState({super.data});
}

/// Entity that describes state with data problems.
final class ErrorEntityState<T> extends ContentEntityState<T> {
  /// Describes exact problems with data
  final Exception? error;

  /// Creates an instance of [ErrorEntityState].
  const ErrorEntityState({this.error, super.data});
}

/// Alias for [EntityStateNotifier] interface.
///
/// Can be useful for simplify description of Widget Model interface.
abstract interface class EntityValueListenable<T>
    implements ValueListenable<EntityState<T>> {}
