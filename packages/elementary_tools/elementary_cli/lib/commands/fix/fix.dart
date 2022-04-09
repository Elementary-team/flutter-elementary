import 'package:args/command_runner.dart';
import 'package:elementary_cli/commands/fix/fix_imports.dart';

/// `elementary_tools fix` command
class FixCommand extends Command<void> {

  FixCommand() {
    addSubcommand(FixImportsCommand());
  }

  @override
  String get description => 'Fixes common errors';

  @override
  String get name => 'fix';

  @override
  bool get takesArguments => false;
}
