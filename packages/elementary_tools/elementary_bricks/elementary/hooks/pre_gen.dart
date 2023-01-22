import 'package:mason/mason.dart';

void run(HookContext context) {
  final String name = context.vars['name'] as String;
  final String widgetModelSuffix =
      context.vars['widget_model_suffix'] as String;

  final widgetName = name;
  final widgetModelName = '$widgetName$widgetModelSuffix';
  final modelName = '${widgetName}Model';

  final widgetFile = widgetName.snakeCase;
  final widgetModelFile = widgetModelSuffix == "WM"
      ? '${widgetFile}_wm'
      : widgetModelName.snakeCase;
  final modelFile = modelName.snakeCase;

  final widgetClass = widgetName.pascalCase;
  final widgetModelClass = widgetModelName.pascalCase;
  final widgetModelInterface = 'I$widgetModelClass';
  final widgetModelFactory = 'default${widgetModelClass}Factory';
  final modelClass = modelName.pascalCase;

  context.vars = {
    ...context.vars,
    'widget_file': widgetFile,
    'widget_model_file': widgetModelFile,
    'model_file': modelFile,
    'widget_class': widgetClass,
    'widget_model_class': widgetModelClass,
    'widget_model_interface': widgetModelInterface,
    'widget_model_factory': widgetModelFactory,
    'model_class': modelClass,
  };
}
