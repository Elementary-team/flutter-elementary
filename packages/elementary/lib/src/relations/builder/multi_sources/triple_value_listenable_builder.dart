import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Builder for presentation ui part using three listanable value..
class TripleValueListenableBuilder<F, S, T> extends StatefulWidget {
  /// State that used to detect change and rebuild.
  final ValueListenable<F> firstSource;

  /// State that used to detect change and rebuild.
  final ValueListenable<S> secondSource;

  /// State that used to detect change and rebuild.
  final ValueListenable<T> thirdSource;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(
    BuildContext context,
    F? firstValue,
    S? secondValue,
    T? thirdValue,
  ) builder;

  /// Create an instance of TripleValueListenableBuilder.
  const TripleValueListenableBuilder({
    Key? key,
    required this.firstSource,
    required this.secondSource,
    required this.thirdSource,
    required this.builder,
  }) : super(key: key);

  @override
  _TripleValueListenableBuilderState createState() =>
      _TripleValueListenableBuilderState<F, S, T>();
}

class _TripleValueListenableBuilderState<F, S, T>
    extends State<TripleValueListenableBuilder<F, S, T>> {
  F? _firstValue;
  S? _secondValue;
  T? _thirdValue;

  @override
  void initState() {
    super.initState();
    _firstValue = widget.firstSource.value;
    widget.firstSource.addListener(_firstValueChanged);

    _secondValue = widget.secondSource.value;
    widget.secondSource.addListener(_secondValueChanged);

    _thirdValue = widget.thirdSource.value;
    widget.thirdSource.addListener(_thirdValueChanged);
  }

  @override
  void didUpdateWidget(TripleValueListenableBuilder<F, S, T> oldWidget) {
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

    if (oldWidget.thirdSource != widget.thirdSource) {
      oldWidget.thirdSource.removeListener(_thirdValueChanged);
      _thirdValue = widget.thirdSource.value;
      widget.thirdSource.addListener(_thirdValueChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.firstSource.removeListener(_firstValueChanged);
    widget.secondSource.removeListener(_secondValueChanged);
    widget.thirdSource.removeListener(_thirdValueChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _firstValue,
      _secondValue,
      _thirdValue,
    );
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

  void _thirdValueChanged() {
    setState(() {
      _thirdValue = widget.thirdSource.value;
    });
  }
}
