import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:elementary_cli/console_writer.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:elementary_cli/generate/generate.dart';
import 'package:path/path.dart' as p;

/// `elementary_tools generate module` command
class GenerateModuleCommand extends TemplateGeneratorCommand {
  static const pathOption = 'path';
  static const nameOption = 'name';
  static const isSubdirNeededFlag = 'create-subdirectory';

  /// Maps template names to files
  late Map<String, File> files;

  /// Maps template names to target suffixes
  @override
  Map<String, String> get templateToFilenameMap => {
    'model.dart.tp': 'filename_model.dart',
    'widget.dart.tp': 'filename_widget.dart',
    'widget_model.dart.tp': 'filename_wm.dart',
  };

  @override
  String get description => 'Generates template elementary mwwm files';

  @override
  String get name => 'module';

  @override
  bool get takesArguments => false;


  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption(
        nameOption,
        abbr: 'n',
        mandatory: true,
        help: 'Name of module in snake case',
        valueHelp: 'my_cool_module',
      )
      ..addOption(
        pathOption,
        abbr: 'p',
        defaultsTo: '.',
        help: 'Path to directory where module files will be generated',
        valueHelp: 'dir1/dir2',
      )
      ..addFlag(
        isSubdirNeededFlag,
        abbr: 's',
        help: 'Should we generate subdirectory for module?',
      )
      // path to templates directory (mostly for testing purposes)
      ..addTemplatePathOption();
  }

  @override
  Future<void> run() async {
    final parsed = argResults!;
    final pathRaw = parsed[pathOption] as String;
    final fileNameBase = parsed[nameOption] as String;
    final isSubdirNeeded = parsed[isSubdirNeededFlag] as bool;

    final baseDir = Directory(pathRaw);
    if (!baseDir.existsSync()) {
      throw NonExistentFolderException(pathRaw);
    }

    if (!TemplateGeneratorCommand.moduleNameRegexp.hasMatch(fileNameBase)) {
      throw CommandLineUsageException(
        argumentName: nameOption,
        argumentValue: fileNameBase,
      );
    }

    // getting templates contents
    await fillTemplates();

    // with `simpleTemplateToFileMap` all files will
    // be generated in one directory
    final targetDirectory = isSubdirNeeded
        ? await Directory(p.join(pathRaw, fileNameBase)).create()
        : baseDir;

    files = simpleTemplateToFileMap(targetDirectory, fileNameBase);

    await checkTargetFilesExistance(files.values);

    final className = snakeToCamelCase(fileNameBase);

    // modification of template content
    String contentCreator(String template) => template
        .replaceAll('ClassName', className)
        .replaceAll('filename', fileNameBase);

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
}
