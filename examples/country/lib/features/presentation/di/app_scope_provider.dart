import 'package:country/features/presentation/di/app_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides application's dependencies by tree.
class AppScopeProvider extends InheritedWidget {
  final IAppScope dependencies;

  const AppScopeProvider({
    super.key,
    required super.child,
    required this.dependencies,
  });

  static IAppScope of(BuildContext context) {
    final result = context.getInheritedWidgetOfExactType<AppScopeProvider>();
    assert(result != null, 'No AppScopeProvider found in context');
    return result!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScopeProvider oldWidget) {
    return oldWidget.dependencies != dependencies;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<IAppScope>('dependencies', dependencies));
  }
}
