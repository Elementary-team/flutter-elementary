import 'dart:async';

import 'package:counter/impl/screen/test_page_model.dart';
import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:counter/main.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Builder for [TestPageWidgetModel]
TestPageWidgetModel testPageWidgetModelFactory(BuildContext context) {
  final errorHandler = context.read<TestErrorHandler>();
  return TestPageWidgetModel(TestPageModel(errorHandler));
}

/// WidgetModel for [TestPageWidget]
class TestPageWidgetModel extends WidgetModel<TestPageWidget, TestPageModel>
    implements ITestPageWidgetModel {
  @override
  ListenableState<EntityState<int>> get valueState => _valueController;

  late EntityStateNotifier<int> _valueController;

  TestPageWidgetModel(TestPageModel model) : super(model);

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
  void dispose() {
    _valueController.dispose();

    super.dispose();
  }
}

abstract class ITestPageWidgetModel extends IWidgetModel {
  ListenableState<EntityState<int>> get valueState;

  Future<void> increment();
}
