import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/widgets.dart';

/// A mixin that provides a collection of [ChangeNotifier] objects
/// and methods to manage their lifecycle.
mixin NotifierSubscriptionsMixin {
  /// A private list that holds all the [ChangeNotifier] instances.
  @protected
  late final _notifiers = <ChangeNotifier>[];

  /// Disposes all [ChangeNotifier] instances in the collection
  /// and clears the collection.
  ///
  /// This method should be called to release resources held by the notifiers.
  /// Make sure to call this method when the mixin is no longer needed.
  @mustCallSuper
  void dispose() {
    for (final notifier in _notifiers) {
      notifier.dispose();
    }
    _notifiers.clear();
  }

  /// Adds a [ChangeNotifier] or its subclass to the notifier collection.
  ///
  /// Returns the added [ChangeNotifier].
  ///
  T addNotifier<T extends ChangeNotifier>(T notifier) {
    _notifiers.add(notifier);
    return notifier;
  }

  /// Creates a [StateNotifier] with an optional initial value and adds it to the notifier collection.
  ///
  /// Returns the created [StateNotifier].
  StateNotifier<T?> createStateNotifier<T>([T? initValue]) {
    return addNotifier(StateNotifier<T?>(initValue: initValue));
  }

  /// Creates an [EntityStateNotifier] with optional initial data and adds it to the notifier collection.
  ///
  /// Returns the created [EntityStateNotifier].
  EntityStateNotifier<T?> createEntityStateNotifier<T>([
    EntityState<T?>? initialData,
  ]) {
    return addNotifier(EntityStateNotifier<T?>(initialData));
  }

  /// Creates a [TextEditingController] with optional initial text
  /// and adds it to the notifier collection.
  ///
  /// Returns the created [TextEditingController].
  TextEditingController createTextEditingController([
    String? initialText,
  ]) {
    return addNotifier(TextEditingController(text: initialText));
  }

  /// Creates a [FocusNode] with optional parameters
  /// and adds it to the notifier collection.
  ///
  /// Returns the created [FocusNode].
  FocusNode createFocusNode({
    String? debugLabel,
    FocusOnKeyEventCallback? onKeyEvent,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    bool descendantsAreFocusable = true,
    bool descendantsAreTraversable = true,
  }) {
    return addNotifier(
      FocusNode(
        debugLabel: debugLabel,
        onKeyEvent: onKeyEvent,
        skipTraversal: skipTraversal,
        canRequestFocus: canRequestFocus,
        descendantsAreFocusable: descendantsAreFocusable,
        descendantsAreTraversable: descendantsAreTraversable,
      ),
    );
  }

  /// Creates a [ScrollController] with optional parameters and adds it to the notifier collection.
  ///
  /// Returns the created [ScrollController].
  ScrollController createScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
    ScrollControllerCallback? onAttach,
    ScrollControllerCallback? onDetach,
  }) {
    return addNotifier(
      ScrollController(
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: keepScrollOffset,
        debugLabel: debugLabel,
        onAttach: onAttach,
        onDetach: onDetach,
      ),
    );
  }
}
