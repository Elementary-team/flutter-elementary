import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import '{{widget_file}}.dart';
// ignore: always_use_package_imports
import '{{model_file}}.dart';

/// Public contract of [{{widget_model_class}}]
abstract interface class {{widget_model_interface}} implements IWidgetModel {
}

/// Default factory for [{{widget_model_class}}]
{{widget_model_class}} {{widget_model_factory}}(BuildContext context) {
  //TODO: DI if needed
  final model = {{model_class}}();
  return {{widget_model_class}}(model);
}

//TODO: documentation
/// Default widget model for ClassNameWidget
class {{widget_model_class}} extends WidgetModel<{{widget_class}}, {{model_class}}>
    implements {{widget_model_interface}} {

  {{widget_model_class}}({{model_class}} model) : super(model);
}
