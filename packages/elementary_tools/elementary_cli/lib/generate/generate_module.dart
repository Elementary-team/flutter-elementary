import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:path/path.dart' as p;

/// `elementary_tools generate wm` command
class GenerateModuleCommand extends Command<void> {
  static const pathOption = 'path';
  static const nameOption = 'name';
  static const templatesDirOption = 'templates';
  static const isSubdirNeededFlag = 'create-subdirectory';

  /// Maps template names to target suffixes
  static const suffixes = {
    'model.dart.tp': '_model.dart',
    'widget.dart.tp': '_widget.dart',
    'widget_model.dart.tp': '_wm.dart',
  };

  /// Default path to directory in project is `elementary_cli/templates`
  static const templatesRelativeToExecutableDirectory = '../../templates';

  /// Maps template names to contents
  Map<String, String> templates = {};

  /// Maps template names to files
  Map<String, File> files = {};

  late String templatesDirectoryPath;

  @override
  String get description => 'Generates template elementary mwwm files';

  @override
  String get name => 'module';

  List<String> get templateNames => suffixes.keys.toList(growable: false);

  List<String> get fileSuffixes => suffixes.values.toList(growable: false);

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption(pathOption, abbr: 'p', defaultsTo: '.')
      ..addOption(nameOption, abbr: 'n', mandatory: true)
      ..addOption(templatesDirOption, abbr: 't')
      ..addFlag(isSubdirNeededFlag, abbr: 's');
  }

  @override
  Future<void> run() async {
    final parsed = argResults!;
    final pathRaw = parsed[pathOption] as String;
    final templateDirRaw = parsed[templatesDirOption] as String?;
    final fileNameBase = parsed[nameOption] as String;
    final isSubdirNeeded = parsed[isSubdirNeededFlag] as bool;

    final baseDir = Directory(pathRaw);
    if (!await baseDir.exists()) {
      throw NonExistentFolderException(pathRaw);
    }

    if (!RegExp(r"^[a-z](_?[a-z0-9])*$").hasMatch(fileNameBase)) {
      throw CommandLineUsageException(
          argumentName: nameOption, argumentValue: fileNameBase);
    }

    await _fillTemplates(templateDirRaw);

    final targetDirectory = isSubdirNeeded
        ? await Directory(p.join(pathRaw, fileNameBase)).create()
        : baseDir;

    _fillFiles(targetDirectory, fileNameBase);

    final className = fileNameBase
        .split("_")
        .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1))
        .join();


    // checking that we can create all files
    await Future.wait(files.values.map((file) async {
      if (await file.exists()) {
        throw GeneratorTargetFileExistsException(p.canonicalize(file.path));
      }
    }));

    // Creating and writing all files
    return Future.wait(
      templateNames.map((templateName) => _writeFile(
            template: templates[templateName]!,
            file: files[templateName]!,
            className: className,
            fileNameBase: fileNameBase,
          )),
    ).then((files) => files.forEach(print)).catchError(
      // If some FileSystemException occurred - delete all files
      (error, stackTrace) async {
        Future.wait(files.values.map((f) => f.delete()));
        // Then throw exception to return right exit code
        throw GenerationException();
      },
      test: (error) => error is FileSystemException,
    );
  }

  void _fillFiles(Directory targetDirectory, String fileNameBase) {
    for (final templateName in templateNames) {
      files[templateName] = File(
        p.join(
          targetDirectory.path,
          fileNameBase + suffixes[templateName]!,
        ),
      );
    }
  }

  String _defaultTemplateDirectoryPath() {
    // If running not inside dart vm - exit
    if (!Platform.script.hasAbsolutePath) {
      throw GenerateTemplatesUnreachableException(
          'script entry has no absolute path');
    }
    return p.join(Platform.script.path, templatesRelativeToExecutableDirectory);
  }

  Future<String> _readTemplateFile(String filename) async {
    final filepath = p.join(templatesDirectoryPath, filename);
    final file = File(filepath);
    if (!await file.exists()) {
      throw GenerateTemplatesUnreachableException(
          'cannot find template file "$filepath"');
    }
    return file.readAsString();
  }

  Future<void> _fillTemplates(String? templateDirRaw) async {
    templateDirRaw ??= _defaultTemplateDirectoryPath();
    templatesDirectoryPath = p.canonicalize(templateDirRaw);
    final templatesDirectory = Directory(templatesDirectoryPath);
    if (!await templatesDirectory.exists()) {
      throw NonExistentFolderException(templatesDirectoryPath);
    }
    await Future.wait(templateNames.map((templateName) =>
        _readTemplateFile(templateName).then((fileContent) =>
            templates[templateName] = fileContent))).catchError(
        (_) =>
            throw GenerateTemplatesUnreachableException('FileSystemException'),
        test: (e) => e is FileSystemException);
  }

  Future<String> _writeFile({
    required String template,
    required File file,
    required String fileNameBase,
    required String className,
  }) async {
    final String content = template
        .replaceAll('ClassName', className)
        .replaceAll('filename', fileNameBase);
    await file.create();
    await file.writeAsString(content);
    return file.path;
  }
}
