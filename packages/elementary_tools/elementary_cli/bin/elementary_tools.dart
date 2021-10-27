import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:elementary_cli/generate/generate.dart';

/// Main entry for `elementary_tools` command
void main(List<String> arguments) async {

  const commandName = 'elementary_tools';
  const commandDescription = 'CLI utilities for Elementary';
  
  final runner = CommandRunner(commandName, commandDescription)
    ..addCommand(GenerateCommand());
  try {
    await runner.run(arguments);
  } on UsageException catch (message, _) {
    // CommandRunner exceptions have no exit code
    print(message);
    exitCode = CommandLineUsageException().exitCode;
  } on ExitCodeException catch (e) {
    print(e);
    exitCode = e.exitCode;
  }
}
