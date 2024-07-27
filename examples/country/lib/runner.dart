import 'dart:async';

import 'package:country/features/presentation/app/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Launches the application.
Future<void> run() async {
  return runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      runApp(const App());
    },
    (exception, stack) {
      // TODO(mjk): add logging errors to the report system
    },
  );
}
