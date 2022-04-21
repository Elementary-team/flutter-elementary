import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:elementary_cli/generate/generate_module.dart';
import 'package:elementary_cli/generate/generate_test.dart';
import 'package:path/path.dart' as p;

/// `elementary_tools generate` command
class GenerateCommand extends Command<void> {
  static const templatesUnreachable =
      FileSystemException('Generator misses template files');

  @override
  String get description => 'Generates template files';

  @override
  String get name => 'generate';

  @override
  bool get takesArguments => false;

  GenerateCommand() {
    addSubcommand(GenerateModuleCommand());
    addSubcommand(GenerateTestCommand());
  }
}

/// Command that generates files from templates
///
/// To create a command you should:
/// * Extend GeneratorCommand
/// * override Command's `run` function for command to be run
/// * override Command's `argParser` function for additional arguments
/// * * do not forget about `addTemplatePathOption`
/// * override GeneratorCommand's `templateToFilenameMap`
abstract class TemplateGeneratorCommand extends Command<void> {

  /// Default path to directory in project is `elementary_cli/lib/templates`
  static const templatesRelativeToExecutableDirectory = '../lib/templates';

  static const templatesDirOption = 'templates';

  static final moduleNameRegexp = RegExp(r'^[a-z](_?[a-z0-9])*$');

  /// Maps template names to contents
  Map<String, String> templates = {};

  late String templatesDirectoryPath;

  List<String> get templateNames =>
      templateToFilenameMap.keys.toList(growable: false);

  List<String> get fileSuffixes =>
      templateToFilenameMap.values.toList(growable: false);

  /// Maps template names to target file name
  /// uses `replaceAll('filename')` method for getting real target file name
  /// Example 'model.dart.tp': 'filename_model.dart'
  Map<String, String> get templateToFilenameMap;

  /// Fills `templates` map with <templateName, fileContent> pairs
  Future<void> fillTemplates() async {
    final templateDirRaw = argResults![templatesDirOption] as String?;
    final templateDir = templateDirRaw ?? await defaultTemplateDirectoryPath();
    templatesDirectoryPath = p.canonicalize(templateDir);
    final templatesDirectory = Directory(templatesDirectoryPath);
    if (!templatesDirectory.existsSync()) {
      throw NonExistentFolderException(templatesDirectoryPath);
    }
    await Future.wait(templateNames.map((templateName) =>
            readTemplateFile(templateName)
                .then((fileContent) => templates[templateName] = fileContent)))
        .catchError(
      // ignore: avoid_types_on_closure_parameters
      (Object _) =>
          throw GenerateTemplatesUnreachableException('FileSystemException'),
      test: (e) => e is FileSystemException,
    );
  }

  /// Gets default template directory path
  Future<String> defaultTemplateDirectoryPath() async {
    // If running not inside dart vm - exit
    if (!Platform.script.hasAbsolutePath) {
      throw GenerateTemplatesUnreachableException(
        'script entry has no absolute path',
      );
    }

    final defaultDirPath = p.join(
      p.dirname(p.joinAll(Platform.script.pathSegments)),
      p.normalize(templatesRelativeToExecutableDirectory),
    );

    final dir = Directory(defaultDirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    // copy template files from package to executable dir
    await copyTemplatesToScriptPath(defaultDirPath);
    return defaultDirPath;
  }

  /// Copy templates to default directory
  Future<void> copyTemplatesToScriptPath(String defaultTemplateDirPath) async {
    // TODO(AlexeyBukin): make generator for this list
    const resources = [
      'package:elementary_cli/templates/widget.dart.tp',
      'package:elementary_cli/templates/model.dart.tp',
      'package:elementary_cli/templates/test_wm.dart.tp',
      'package:elementary_cli/templates/widget_model.dart.tp',
    ];

    for (final resource in resources) {
      final resolvedUri = await Isolate.resolvePackageUri(Uri.parse(resource));
      if (resolvedUri != null) {
        final fileWithExtension = p.split(resolvedUri.toString()).last;
        File.fromUri(resolvedUri)
            .copySync(p.join(defaultTemplateDirPath, fileWithExtension));
      }
    }
  }

  /// Reads template file
  Future<String> readTemplateFile(String filename) async {
    final filepath = p.join(templatesDirectoryPath, filename);
    final file = File(filepath);
    if (!file.existsSync()) {
      throw GenerateTemplatesUnreachableException(
        'cannot find template file "$filepath"',
      );
    }
    return file.readAsString();
  }

  /// Maps every template to a filename in a simple way
  ///
  /// Maps template name with file's name replacing `filename`
  /// string with `fileNameBase` parameter
  ///
  /// All files will be located at the same `targetDirectory`
  Map<String, File> simpleTemplateToFileMap(
    Directory targetDirectory,
    String fileNameBase,
  ) {
    final files = <String, File>{};
    for (final templateName in templateNames) {
      files[templateName] = File(
        p.join(
          targetDirectory.path,
          templateToFilenameMap[templateName]!
              .replaceAll('filename', fileNameBase),
        ),
      );
    }
    return files;
  }

  /// Creates file and writes content
  Future<String> writeFile({
    required String content,
    required File file,
  }) async {
    await file.create(recursive: true);
    await file.writeAsString(content);
    return file.path;
  }

  /// Converts snake_case string to CamelCase
  String snakeToCamelCase(String snake) => snake
      .split('_')
      .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1))
      .join();

  /// Checks that all target files does not exist
  ///
  /// throws GeneratorTargetFileExistsException otherwise
  Future<void> checkTargetFilesExistance(Iterable<File> files) async {
    await Future.wait(
      files.map(
        (file) async {
          if (file.existsSync()) {
            throw GeneratorTargetFileExistsException(file.path);
          }
        },
      ),
    );
  }
}

extension TemplateParseOption on ArgParser {
  static const templatesDirOption = 'templates';
  static const templatesDirOptionAbbreviation = 't';

  void addTemplatePathOption() => addOption(
        templatesDirOption,
        abbr: templatesDirOptionAbbreviation,
        help: 'Path to templates directory (testing only)',
        valueHelp: '/home/user/templates',
      );
}
