import 'package:elementary/src/relations/notifier/state_notifier.dart';
import 'package:flutter/material.dart';

/// Builder for presentation ui part using two listenable states.
class DoubleSourceBuilder<F, S> extends StatefulWidget {
  /// State that used to detect change and rebuild.
  final ListenableState<F> firstSource;

  /// State that used to detect change and rebuild.
  final ListenableState<S> secondSource;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(BuildContext context, F? firstValue, S? secondValue)
      builder;

  /// Create an instance of DoubleSourceBuilder.
  const DoubleSourceBuilder({
    Key? key,
    required this.firstSource,
    required this.secondSource,
    required this.builder,
  }) : super(key: key);

  @override
  _DoubleSourceBuilderState createState() => _DoubleSourceBuilderState<F, S>();
}

class _DoubleSourceBuilderState<F, S> extends State<DoubleSourceBuilder<F, S>> {
  F? _firstValue;
  S? _secondValue;

  @override
  void initState() {
    super.initState();
    _firstValue = widget.firstSource.value;
    widget.firstSource.addListener(_firstValueChanged);

    _secondValue = widget.secondSource.value;
    widget.secondSource.addListener(_secondValueChanged);
  }

  @override
  void didUpdateWidget(DoubleSourceBuilder<F, S> oldWidget) {
    if (oldWidget.firstSource != widget.firstSource) {
      oldWidget.firstSource.removeListener(_firstValueChanged);
      _firstValue = widget.firstSource.value;
      widget.firstSource.addListener(_firstValueChanged);
    }

    if (oldWidget.secondSource != widget.secondSource) {
      oldWidget.secondSource.removeListener(_secondValueChanged);
      _secondValue = widget.secondSource.value;
      widget.secondSource.addListener(_secondValueChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.firstSource.removeListener(_firstValueChanged);
    widget.secondSource.removeListener(_secondValueChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _firstValue, _secondValue);
  }

  void _firstValueChanged() {
    setState(() {
      _firstValue = widget.firstSource.value;
    });
  }

  void _secondValueChanged() {
    setState(() {
      _secondValue = widget.secondSource.value;
    });
  }
}
