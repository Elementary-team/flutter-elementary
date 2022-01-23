import 'package:elementary/src/relations/notifier/state_notifier.dart';
import 'package:flutter/material.dart';

/// Builder for presentation ui part by [StateNotifier] property.
class StateNotifierBuilder<T> extends StatefulWidget {
  /// State that used to detect change and rebuild.
  final ListenableState<T> listenableState;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(BuildContext context, T? value) builder;

  /// Create an instance of StateNotifierBuilder.
  const StateNotifierBuilder({
    Key? key,
    required this.listenableState,
    required this.builder,
  }) : super(key: key);

  @override
  _StateNotifierBuilderState createState() => _StateNotifierBuilderState<T>();
}

class _StateNotifierBuilderState<T> extends State<StateNotifierBuilder<T>> {
  T? value;

  @override
  void initState() {
    super.initState();
    value = widget.listenableState.value;
    widget.listenableState.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StateNotifierBuilder<T> oldWidget) {
    if (oldWidget.listenableState != widget.listenableState) {
      oldWidget.listenableState.removeListener(_valueChanged);
      value = widget.listenableState.value;
      widget.listenableState.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.listenableState.removeListener(_valueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }

  void _valueChanged() {
    setState(() {
      value = widget.listenableState.value;
    });
  }
}

/// Builder for presentation ui part by [EntityStateNotifier] property.
class EntityStateNotifierBuilder<T> extends StatelessWidget {
  /// State that used to detect change and rebuild.
  final ListenableState<EntityState<T>> listenableEntityState;

  /// Builder that used to describe user interface when get data.
  final DataWidgetBuilder<T> builder;

  /// Builder that used to describe user interface when loading.
  final LoadingWidgetBuilder<T>? loadingBuilder;

  /// Builder that used to describe user interface when get error.
  final ErrorWidgetBuilder<T>? errorBuilder;

  /// Create an instance of EntityStateNotifierBuilder.
  const EntityStateNotifierBuilder({
    Key? key,
    required this.listenableEntityState,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<EntityState<T>>(
      listenableState: listenableEntityState,
      builder: (ctx, state) {
        final entity = state!;

        final eBuilder = errorBuilder;
        if (entity.hasError && eBuilder != null) {
          return eBuilder(ctx, entity.error, entity.data);
        }

        final lBuilder = loadingBuilder;
        if (entity.isLoading && lBuilder != null) {
          return lBuilder(ctx, entity.data);
        }

        return builder(ctx, entity.data);
      },
    );
  }
}

/// Builder function for loading state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef LoadingWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T? data,
);

/// Builder function for content state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T? data);

/// Builder function for error state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef ErrorWidgetBuilder<T> = Widget Function(
  BuildContext context,
  Exception? e,
  T? data,
);
