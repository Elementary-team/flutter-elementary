import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:profile/features/app/app.dart';
import 'package:surf_logger/surf_logger.dart';

/// App launch.
Future<void> run() async {
  _initLogger();
  runApp(const App());
}

void _initLogger() {
  Logger.addStrategy(DebugLogStrategy());
}
