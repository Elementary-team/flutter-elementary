import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:elementary_cli/generate/generate_module.dart';

/// `elementary_tools generate` command
class GenerateCommand extends Command<void> {
  static const templatesUnreachable =
      FileSystemException('Generator misses template files');

  @override
  String get description => 'Generates template files';

  @override
  String get name => 'generate';

  GenerateCommand() {
    addSubcommand(GenerateModuleCommand());
  }
}
