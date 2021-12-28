import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:elementary_cli/commands/fix/fix.dart';
import 'package:elementary_cli/commands/generate/generate.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:elementary_cli/logger.dart';

/// Main entry for `elementary_tools` command
Future<void> main(List<String> arguments) async {
  enableInfoLogging();

  const commandName = 'elementary_tools';
  const commandDescription = 'CLI utilities for Elementary';

  final runner = CommandRunner<void>(commandName, commandDescription)
    ..addCommand(GenerateCommand())
    ..addCommand(FixCommand());
  try {
    await runner.run(arguments);
  } on UsageException catch (message, _) {
    // CommandRunner exceptions have no exit code so we return custom one
    ConsoleWriter.write(message);
    exitCode = CommandLineUsageException().exitCode;
  } on ExitCodeException catch (e) {
    ConsoleWriter.write(e);
    exitCode = e.exitCode;
  }
}
