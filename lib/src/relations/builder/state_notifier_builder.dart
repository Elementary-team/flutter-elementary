import 'package:elementary/src/relations/notifier/state_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StateNotifierBuilder<T> extends StatefulWidget {
  final ListenableState<T> listenableState;
  final Widget Function(BuildContext context, T? value) builder;

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

  void _valueChanged() {
    setState(() {
      value = widget.listenableState.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }
}

class EntityStateNotifierBuilder<T> extends StatelessWidget {
  final ListenableState<EntityState<T>> listenableEntityState;
  final DataWidgetBuilder<T> builder;
  final LoadingWidgetBuilder<T>? loadingBuilder;
  final ErrorWidgetBuilder<T>? errorBuilder;

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
        var entity = state!;

        var eBuilder = errorBuilder;
        if (entity.hasError && eBuilder != null) {
          return eBuilder(ctx, entity.error, entity.data);
        }

        var lBuilder = loadingBuilder;
        if (entity.isLoading && lBuilder != null) {
          return lBuilder(ctx, entity.data);
        }

        return builder(ctx, entity.data);
      },
    );
  }
}

typedef LoadingWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T? data,
);

typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T? data);

typedef ErrorWidgetBuilder<T> = Widget Function(
  BuildContext context,
  Exception? e,
  T? data,
);
