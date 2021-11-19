import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:elementary_cli/analyzer_plugin/elementary_plugin.dart';

void startElementaryPlugin(List<String> _, SendPort sendPort) {
  ServerPluginStarter(
    ElementaryAnalyzerPlugin(PhysicalResourceProvider.INSTANCE),
  ).start(sendPort);
}
