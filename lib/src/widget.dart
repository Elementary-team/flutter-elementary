import 'package:elementary/src/element.dart';
import 'package:flutter/material.dart';

/// A widget that use WidgetModel for build.
///
/// You must provide [wmFactory] factory function to the constructor
/// to instantiate WidgetModel. For testing, you can replace
/// this function for returning mock.
abstract class WMWidget<I extends IWM> extends Widget {
  final WidgetModelFactory wmFactory;

  const WMWidget(
    this.wmFactory, {
    Key? key,
  }) : super(key: key);

  /// Creates a [WMElement] to manage this widget's location in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  Element createElement() {
    return WMElement(this);
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// You can use all properties and methods provided by Widget Model.
  /// You should not use [BuildContext] or something else, all you need
  /// must contains in Widget Model.
  Widget build(I wm);
}
