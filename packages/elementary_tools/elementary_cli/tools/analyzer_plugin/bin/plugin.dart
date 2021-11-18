import 'dart:isolate';
import 'package:elementary_cli/analyzer_plugin/start_elementary_plugin.dart';

/// Proxy main to `elementary_cli` package's analyzer plugin
void main(List<String> args, SendPort sendPort) {
  // invoking starting function of Elementary Analyzer Plugin
  startElementaryPlugin(args, sendPort);
}