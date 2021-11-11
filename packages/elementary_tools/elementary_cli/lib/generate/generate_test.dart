import 'package:args/command_runner.dart';
import 'package:elementary_cli/generate/generate_test_wm.dart';

/// `elementary_tools generate test` command
class GenerateTestCommand extends Command<void> {

  @override
  String get description => 'Generates template files for tests';

  @override
  String get name => 'test';

  @override
  bool get takesArguments => false;

  GenerateTestCommand() {
    addSubcommand(GenerateTestWmCommand());
  }
}
