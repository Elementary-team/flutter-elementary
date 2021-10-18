import 'package:args/command_runner.dart';
import 'generate_wm.dart';

/// `elementary_tools generate` command
class GenerateCommand extends Command {
  @override
  String get description => 'Generates template files';

  @override
  String get name => 'generate';

  GenerateCommand() {
    addSubcommand(GenerateWmCommand());
  }
}
