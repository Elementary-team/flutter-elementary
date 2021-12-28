// ignore_for_file: avoid_print
import 'package:args/args.dart';
import 'package:elementary_cli/commands/generate/generate.dart';
import 'package:logging/logging.dart';

/// Writes messages to console, when results needed in stdout
class ConsoleWriter {
  static void write(Object? object) {
    print(object);
  }
}

// TODO(AlexeyBukin): submit a doubling-value bug
LogRecord? lastLogRecord;

/// Enables verbose logging
void enableVerboseLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (record.message != lastLogRecord?.message) {
      print('${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}');
    }
    lastLogRecord = record;
  });
}

/// Applies global logging settings
void applyLoggingSettings(ArgResults argResults) {
  final needsVerbose = argResults[TemplateParseOption.verboseLoggingFlag] as bool;
  if (needsVerbose) {
    enableVerboseLogging();
  }
}
