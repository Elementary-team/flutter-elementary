import 'package:elementary/src/relations/notifier/state_notifier.dart';
import 'package:flutter/material.dart';

/// Builder for presentation ui part using two listenable states.
class TripleSourceBuilder<F, S, T> extends StatefulWidget {
  /// State that used to detect change and rebuild.
  final ListenableState<F> firstSource;

  /// State that used to detect change and rebuild.
  final ListenableState<S> secondSource;

  /// State that used to detect change and rebuild.
  final ListenableState<T> thirdSource;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(
    BuildContext context,
    F? firstValue,
    S? secondValue,
    T? thirdValue,
  ) builder;

  /// Create an instance of DoubleSourceBuilder.
  const TripleSourceBuilder({
    Key? key,
    required this.firstSource,
    required this.secondSource,
    required this.builder,
    required this.thirdSource,
  }) : super(key: key);

  @override
  _TripleSourceBuilderState createState() =>
      _TripleSourceBuilderState<F, S, T>();
}

class _TripleSourceBuilderState<F, S, T>
    extends State<TripleSourceBuilder<F, S, T>> {
  F? firstValue;
  S? secondValue;
  T? thirdValue;

  @override
  void initState() {
    super.initState();
    firstValue = widget.firstSource.value;
    widget.firstSource.addListener(_firstValueChanged);

    secondValue = widget.secondSource.value;
    widget.secondSource.addListener(_secondValueChanged);

    thirdValue = widget.thirdSource.value;
    widget.secondSource.addListener(_thirdValueChanged);
  }

  @override
  void didUpdateWidget(TripleSourceBuilder<F, S, T> oldWidget) {
    if (oldWidget.firstSource != widget.firstSource) {
      oldWidget.firstSource.removeListener(_firstValueChanged);
      firstValue = widget.firstSource.value;
      widget.firstSource.addListener(_firstValueChanged);
    }

    if (oldWidget.secondSource != widget.secondSource) {
      oldWidget.secondSource.removeListener(_secondValueChanged);
      secondValue = widget.secondSource.value;
      widget.secondSource.addListener(_secondValueChanged);
    }

    if (oldWidget.thirdSource != widget.thirdSource) {
      oldWidget.thirdSource.removeListener(_secondValueChanged);
      thirdValue = widget.thirdSource.value;
      widget.thirdSource.addListener(_secondValueChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.firstSource.removeListener(_firstValueChanged);
    widget.secondSource.removeListener(_secondValueChanged);
    widget.secondSource.removeListener(_thirdValueChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      firstValue,
      secondValue,
      thirdValue,
    );
  }

  void _firstValueChanged() {
    setState(() {
      firstValue = widget.firstSource.value;
    });
  }

  void _secondValueChanged() {
    setState(() {
      secondValue = widget.secondSource.value;
    });
  }

  void _thirdValueChanged() {
    setState(() {
      thirdValue = widget.thirdSource.value;
    });
  }
}
