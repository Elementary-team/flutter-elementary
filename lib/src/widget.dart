import 'package:elementary/src/element.dart';
import 'package:flutter/material.dart';

abstract class WMWidget<I extends IWM> extends Widget {
  final WidgetModelBuilder wmBuilder;

  const WMWidget(
    this.wmBuilder, {
    Key? key,
  }) : super(key: key);

  @override
  Element createElement() {
    return WMElement(this);
  }

  Widget build(I wm);
}
