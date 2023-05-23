import 'package:elementary/src/relations/notifier/state_notifier.dart';
import 'package:flutter/material.dart';

/// Builder that uses [ListenableState] as a source of data.
/// Usually can be helpful with the [StateNotifier].
class StateNotifierBuilder<T> extends StatefulWidget {
  /// Source that used to detect change and rebuild.
  final ListenableState<T> listenableState;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(BuildContext context, T? value) builder;

  /// Creates an instance of [StateNotifierBuilder].
  const StateNotifierBuilder({
    Key? key,
    required this.listenableState,
    required this.builder,
  }) : super(key: key);

  @override
  State<StateNotifierBuilder<T>> createState() =>
      _StateNotifierBuilderState<T>();
}

class _StateNotifierBuilderState<T> extends State<StateNotifierBuilder<T>> {
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.listenableState.value;
    widget.listenableState.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StateNotifierBuilder<T> oldWidget) {
    if (oldWidget.listenableState != widget.listenableState) {
      oldWidget.listenableState.removeListener(_valueChanged);
      _value = widget.listenableState.value;
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
    return widget.builder(context, _value);
  }

  void _valueChanged() {
    setState(() {
      _value = widget.listenableState.value;
    });
  }
}
