import 'dart:async';

import 'package:counter/impl/screen/test_page_model.dart';
import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Билдер не будет ли вводить в диссонанс с ui билдерами???
TestPageWidgetModel testPageWidgetModelBuilder(BuildContext context) {
  final model = context.read<TestPageModel>();
  return TestPageWidgetModel(model);
}

class TestPageWidgetModel extends WidgetModel<TestPageWidget, TestPageModel>
    implements ITestPageWidgetModel {
  @override
  ListenableState<EntityState<int>> get valueState => _valueController;

  @override
  TextStyle get counterStyle => _counterStyle;

  late EntityStateNotifier<int> _valueController;
  late TextStyle _counterStyle;

  TestPageWidgetModel(TestPageModel model) : super(model);

  @override
  Future<void> increment() async {
    _valueController.loading();

    final newVal = await model.increment();

    _valueController.content(newVal);
  }

  @override
  void onCreate() {
    super.onCreate();

    _valueController = EntityStateNotifier<int>.value(model.value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _counterStyle = Theme.of(context).textTheme.headline4 ?? const TextStyle();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    // TODO(mjk): здесь можно юзать отдельную сущность DialogController
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();

    super.dispose();
  }
}

abstract class ITestPageWidgetModel extends IWM {
  ListenableState<EntityState<int>> get valueState;

  TextStyle get counterStyle;

  Future<void> increment();
}
