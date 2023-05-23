import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Builder that uses three [ValueListenable] sources of data.
class TripleValueListenableBuilder<F, S, T> extends StatefulWidget {
  /// State that is used to detect change and rebuild.
  final ValueListenable<F> firstValue;

  /// State that is used  to detect change and rebuild.
  final ValueListenable<S> secondValue;

  /// State that is used  to detect change and rebuild.
  final ValueListenable<T> thirdValue;

  /// Function that is used  to describe the part of the user interface
  /// represented by this widget.
  final Widget Function(
    BuildContext context,
    F firstValue,
    S secondValue,
    T thirdValue,
  ) builder;

  /// Creates an instance of [TripleValueListenableBuilder].
  const TripleValueListenableBuilder({
    Key? key,
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
    required this.builder,
  }) : super(key: key);

  @override
  State<TripleValueListenableBuilder<F, S, T>> createState() =>
      _TripleValueListenableBuilderState<F, S, T>();
}

class _TripleValueListenableBuilderState<F, S, T>
    extends State<TripleValueListenableBuilder<F, S, T>> {
  late F _firstValue;
  late S _secondValue;
  late T _thirdValue;

  @override
  void initState() {
    super.initState();
    _firstValue = widget.firstValue.value;
    widget.firstValue.addListener(_firstValueChanged);

    _secondValue = widget.secondValue.value;
    widget.secondValue.addListener(_secondValueChanged);

    _thirdValue = widget.thirdValue.value;
    widget.thirdValue.addListener(_thirdValueChanged);
  }

  @override
  void didUpdateWidget(TripleValueListenableBuilder<F, S, T> oldWidget) {
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

    if (oldWidget.thirdValue != widget.thirdValue) {
      oldWidget.thirdValue.removeListener(_thirdValueChanged);
      _thirdValue = widget.thirdValue.value;
      widget.thirdValue.addListener(_thirdValueChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.firstValue.removeListener(_firstValueChanged);
    widget.secondValue.removeListener(_secondValueChanged);
    widget.thirdValue.removeListener(_thirdValueChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _firstValue,
        _secondValue,
        _thirdValue,
      );

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

  void _thirdValueChanged() {
    setState(() {
      _thirdValue = widget.thirdValue.value;
    });
  }
}
