import 'package:country/assets/themes/app_theme.dart';
import 'package:country/features/presentation/di/app_scope.dart';
import 'package:country/features/presentation/di/app_scope_provider.dart';
import 'package:country/features/presentation/routing/route_information_parser.dart';
import 'package:country/features/presentation/routing/router_delegate.dart';
import 'package:flutter/material.dart';

/// Application widget.
class App extends StatefulWidget {
  /// Creates an instance of [App].
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late IAppScope _scope;

  @override
  void initState() {
    super.initState();

    // initiate dependencies
    _scope = AppScope();
  }

  @override
  Widget build(BuildContext context) {
    return AppScopeProvider(
      dependencies: _scope,
      child: MaterialApp.router(
        // Localization
        theme: appTheme,

        // Navigation
        routeInformationParser: CountryRouteInformationParser(),
        routerDelegate: CountryRouterDelegate(_scope.coordinator),
      ),
    );
  }
}
