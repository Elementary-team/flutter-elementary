import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Builder for presentation ui part using two listanable value.
class DoubleValueListenableBuilder<F, S> extends StatefulWidget {
  /// State that used to detect change and rebuild.
  final ValueListenable<F> firstValue;

  /// State that used to detect change and rebuild.
  final ValueListenable<S> secondValue;

  /// Function that used to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(BuildContext context, F? firstValue, S? secondValue)
      builder;

  /// Create an instance of DoubleValueListenableBuilder.
  const DoubleValueListenableBuilder({
    Key? key,
    required this.firstValue,
    required this.secondValue,
    required this.builder,
  }) : super(key: key);

  @override
  _DoubleValueListenableBuilderState createState() =>
      _DoubleValueListenableBuilderState<F, S>();
}

class _DoubleValueListenableBuilderState<F, S>
    extends State<DoubleValueListenableBuilder<F, S>> {
  F? _firstValue;
  S? _secondValue;

  @override
  void initState() {
    super.initState();
    _firstValue = widget.firstValue.value;
    widget.firstValue.addListener(_firstValueChanged);

    _secondValue = widget.secondValue.value;
    widget.secondValue.addListener(_secondValueChanged);
  }

  @override
  void didUpdateWidget(DoubleValueListenableBuilder<F, S> oldWidget) {
    if (oldWidget.firstValue != widget.firstValue) {
      oldWidget.firstValue.removeListener(_firstValueChanged);
      _firstValue = widget.firstValue.value;
      widget.firstValue.addListener(_firstValueChanged);
    }

    if (oldWidget.secondValue != widget.secondValue) {
      oldWidget.secondValue.removeListener(_secondValueChanged);
      _secondValue = widget.secondValue.value;
      widget.secondValue.addListener(_secondValueChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.firstValue.removeListener(_firstValueChanged);
    widget.secondValue.removeListener(_secondValueChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _firstValue, _secondValue);
  }

  void _firstValueChanged() {
    setState(() {
      _firstValue = widget.firstValue.value;
    });
  }

  void _secondValueChanged() {
    setState(() {
      _secondValue = widget.secondValue.value;
    });
  }
}
