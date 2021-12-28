
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:elementary_cli/analysis_client/elementary_client.dart';
import 'package:elementary_cli/commands/generate/generate.dart';
import 'package:elementary_cli/logger.dart';
import 'package:logging/logging.dart';

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

class FixImportsCommand extends Command<void> {

  final log = Logger('FixImportsCommand');

  @override
  String get description => 'imports';

  @override
  String get name => 'imports';

  @override
  ArgParser get argParser {
    return ArgParser()
    ..addVerboseLoggingFlag()
      ..addOption(
        'file',
        abbr: 'f',
        mandatory: true,
        help: 'path to file',
        valueHelp: 'path/to/file.dart',
      );
  }

  @override
  Future<void> run() async {
    final parsed = argResults!;
    final pathRaw = parsed['file'] as String;

    applyLoggingSettings(parsed);

    final client = ElementaryClient();
    await client.start();
    await client.applyImportFixes(pathRaw);
    await client.stop();
  }
}
