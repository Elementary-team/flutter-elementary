import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:elementary_cli/analysis_client/elementary_client.dart';
import 'package:elementary_cli/commands/generate/generate.dart';
import 'package:elementary_cli/utils/logger.dart';
import 'package:logging/logging.dart';

class FixImportsCommand extends Command<void> {
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
    applyLoggingSettings(parsed);

    final pathRaw = parsed['file'] as String;
    await pureRun([pathRaw]);
  }

  static Future<void> pureRun(List<String> files) async {
    final log = Logger('FixImportsCommand')
      ..info("Running 'fix imports' command...")
      ..info('Target: $files');
    final client = ElementaryClient();
    await client.start();
    await Future.wait(files.map(client.applyImportFixes));
    // await client.applyImportFixes(pathRaw);
    await client.stop();
    log.info("Running 'fix imports' command... Done.");
  }
}
