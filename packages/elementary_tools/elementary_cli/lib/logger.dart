// ignore_for_file: avoid_print
import 'package:args/args.dart';
import 'package:elementary_cli/commands/generate/generate.dart';
import 'package:logging/logging.dart';

/// Info - default messages, results that is written to stdout
/// Verbose - info + progress messages
void enableVerboseLogging() {
  Logger.root.level = Level.ALL;
  enableLoggingToConsoleOutput();
}

void enableInfoLogging() {
  Logger.root.level = Level.INFO;
  enableLoggingToConsoleOutput();
}

LogRecord? lastLogRecord;

// TODO(AlexeyBukin): submit a doubling-value bug
void enableLoggingToConsoleOutput() {
  Logger.root.onRecord.listen((record) {
    if (record.message != lastLogRecord?.message) {
      print('${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}');
    }
    lastLogRecord = record;
  });
}

void applyLoggingSettings(ArgResults argResults) {
  final needsVerbose = argResults[TemplateParseOption.verboseLoggingFlag] as bool;
  if (needsVerbose) {
    enableVerboseLogging();
  }
}

// Writes messages to console, when results needed in stdout
class ConsoleWriter {
  static void write(Object? object) {
    print(object);
  }
}