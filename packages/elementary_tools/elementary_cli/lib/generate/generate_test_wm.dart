import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:elementary_cli/console_writer.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:elementary_cli/generate/generate.dart';
import 'package:path/path.dart' as p;

/// `elementary_tools generate test wm` command
/// `wm` means widget model in this context
class GenerateTestWmCommand extends TemplateGeneratorCommand {
  static const pathOption = 'path';
  static const nameOption = 'name';

  static const smartFlag = 'smart';

  static const rootOption = 'root';
  static const sourceOption = 'source';

  static const modeOption = 'mode';
  static const modeDummyOption = 'dummy';
  static const modeSmartOption = 'smart';

  /// Place for generated test
  late Directory targetDirectory;

  /// snake_case module name
  late String basename;

  /// Maps template names to files
  late Map<String, File> files;

  @override
  String get description => 'Generates template files for widget model tests';

  @override
  String get name => 'wm';

  @override
  bool get takesArguments => false;

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption(
        nameOption,
        abbr: 'n',
        help: 'Name of widget model module in snake case',
        valueHelp: 'my_cool_module',
        mandatory: true,
      )
      ..addOption(
        pathOption,
        abbr: 'p',
        defaultsTo: '.',
        help: 'Path to directory where the test will be generated (dummy mode)',
        valueHelp: 'dir1/dir2',
      )
      ..addFlag(
        smartFlag,
        abbr: 's',
        help: 'Smart mode flag: --path is path to project root '
            'and --name is source file path/name.',
      )
      // path to templates directory (mostly for testing purposes)
      ..addTemplatePathOption();
  }

  /// We are using `simpleTemplateToFileMap` so our filenames contain 'filename'
  /// where we expect base name to be
  @override
  Map<String, String> get templateToFilenameMap => {
        'test_wm.dart.tp': 'filename_wm_test.dart',
      };

  @override
  Future<void> run() async {
    final parsed = argResults!;
    final smart = parsed[smartFlag] as bool;
    final pathRaw = parsed[pathOption] as String;
    final nameRaw = parsed[nameOption] as String;

    if (smart) {
      // smartModeConfig just fills `targetDirectory` and `basename` fields.
      await smartModeConfig(path: pathRaw, name: nameRaw);
    } else {
      targetDirectory = Directory(pathRaw);
      basename = nameRaw;
    }

    if (!targetDirectory.existsSync() && !smart) {
      throw NonExistentFolderException(targetDirectory.path);
    }

    if (!TemplateGeneratorCommand.moduleNameRegexp.hasMatch(basename)) {
      throw CommandLineUsageException(
        message: '$basename is not valid module name. '
            'Module name must be in snake_case.',
      );
    }

    // getting templates contents
    await fillTemplates();

    files = simpleTemplateToFileMap(targetDirectory, basename);

    await checkTargetFilesExistance(files.values);

    final className = snakeToCamelCase(basename);

    // modification of template content
    String contentCreator(String template) => template
        .replaceAll('ClassName', className)
        .replaceAll('filename', basename);

    // Creating and writing all files
    await Future.wait(
      templateNames.map((templateName) => writeFile(
            file: files[templateName]!,
            content: contentCreator(templates[templateName]!),
          )),
    ).then((files) => files.forEach(ConsoleWriter.write)).catchError(
      // If some FileSystemException occurred - delete all files
      // ignore: avoid_types_on_closure_parameters
      (Object error, StackTrace stackTrace) async {
        await Future.wait(files.values.map((f) => f.delete()));
        // Then throw exception to return right exit code
        throw GenerationException();
      },
      test: (error) => error is FileSystemException,
    );
  }

  Future<void> runDummyMode(ArgResults parsedArguments) async {
    final dummyPathRaw = parsedArguments[pathOption] as String;
    final fileNameBase = parsedArguments[nameOption] as String;

    targetDirectory = Directory(dummyPathRaw);
    basename = fileNameBase;
  }

  Future<void> smartModeConfig({
    required String name,
    required String path,
  }) async {
    final rootPath = path;
    final sourceFilePath = name;

    const suffix = '_wm.dart';
    if (!sourceFilePath.endsWith(suffix)) {
      throw CommandLineUsageException(
        message: 'Widget model dart file name should end with "$suffix".',
      );
    }

    // export of basename
    basename = p.basename(sourceFilePath).replaceAll(suffix, '');

    final root = Directory(rootPath);
    final sourceFile = File(sourceFilePath);

    if (!root.existsSync()) {
      throw NonExistentFolderException(rootPath);
    }

    if (!sourceFile.existsSync()) {
      throw NonExistentFileException(sourceFilePath);
    }

    final lib = Directory(p.join(root.path, 'lib'));

    if (!lib.existsSync()) {
      throw CommandLineUsageException(
        message: 'Root folder must contain "lib" folder.',
      );
    }

    if (!p.isWithin(lib.path, sourceFile.path)) {
      throw CommandLineUsageException(
        message: 'Widget model dart file should be placed '
            'in ${"project's"} lib folder.',
      );
    }

    final relativePath = p.relative(sourceFile.parent.path, from: lib.path);
    final test = Directory(p.join(root.path, 'test'));
    // export of targetDirectory
    targetDirectory = Directory(p.join(test.path, relativePath));
  }
}
