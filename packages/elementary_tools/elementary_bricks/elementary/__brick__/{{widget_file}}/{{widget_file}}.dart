import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import '{{widget_model_file}}.dart';

//TODO: documentation
class {{widget_class}} extends ElementaryWidget<{{widget_model_interface}}> {
  const {{widget_class}}({
    Key? key,
    WidgetModelFactory wmFactory = {{widget_model_factory}},
  }) : super(wmFactory, key: key);

  @override
  Widget build({{widget_model_interface}} wm) {
    return Container();
  }
}
