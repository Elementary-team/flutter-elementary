import 'package:country/ui/app/app.dart';
import 'package:country/ui/app/app_dependencies.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    const AppDependencies(
      app: App(),
    ),
  );
}
