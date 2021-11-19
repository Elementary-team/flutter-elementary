import 'dart:async';

import 'package:counter/impl/screen/test_page_model.dart';
import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TestPageWidgetModel testPageWidgetModelFactory(BuildContext context) {
  final model = context.read<TestPageModel>();
  final theme = context.read<ThemeWrapper>();
  return TestPageWidgetModel(model, theme);
}

class TestPageWidgetModel extends WidgetModel<TestPageWidget, TestPageModel>
    implements ITestPageWidgetModel {
  final ThemeWrapper _themeWrapper;

  @override
  ListenableState<EntityState<int>> get valueState => _valueController;

  @override
  TextStyle get counterStyle => _counterStyle;

  late EntityStateNotifier<int> _valueController;
  late TextStyle _counterStyle;

  TestPageWidgetModel(
    TestPageModel model,
    this._themeWrapper,
  ) : super(model);

  @override
  Future<void> increment() async {
    _valueController.loading();

    final newVal = await model.increment();

    _valueController.content(newVal);
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _valueController = EntityStateNotifier<int>.value(model.value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _counterStyle =
        _themeWrapper.getTextTheme(context).headline4 ?? const TextStyle();
  }

  @override
  void dispose() {
    _valueController.dispose();

    super.dispose();
  }
}

abstract class ITestPageWidgetModel extends IWidgetModel {
  ListenableState<EntityState<int>> get valueState;

  TextStyle get counterStyle;

  Future<void> increment();
}
