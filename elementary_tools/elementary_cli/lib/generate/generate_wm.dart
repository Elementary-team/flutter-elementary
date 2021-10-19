import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

/// `elementary_tools generate wm` command
class GenerateWmCommand extends Command {
  static const pathOption = 'path';
  static const nameOption = 'name';
  static const isSubdirNeededFlag = 'create-subdirectory';

  @override
  String get description => 'Generates template elementary mwwm files';

  @override
  String get name => 'wm';

  @override
  ArgParser get argParser {
    return ArgParser()
      ..addOption(pathOption, abbr: 'p', defaultsTo: '.')
      ..addOption(nameOption, abbr: 'n', mandatory: true)
      ..addFlag(isSubdirNeededFlag, abbr: 's');
  }

  @override
  FutureOr? run() async {
    final parsed = argResults!;
    final pathRaw = parsed[pathOption] as String;
    final name = parsed[nameOption] as String;
    final isSubdirNeeded = parsed[isSubdirNeededFlag] as bool;

    final baseDir = Directory(pathRaw);
    if (!await baseDir.exists()) {
      print('"$pathRaw" is not an existing directory');
      return;
    }

    if (!RegExp(r"^[a-z](_?[a-z0-9])*$").hasMatch(name)) {
      print('"$name" is an illegal name');
      return;
    }

    final dir = isSubdirNeeded
        ? await Directory(p.join(pathRaw, name)).create()
        : baseDir;

    final className = name
        .split("_")
        .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1))
        .join();
    final modelFile = p.join(dir.path, name + '_model.dart');
    final modelFuture =
        writeFile(filename: modelFile, text: modelText(className));

    final widgetFile = p.join(dir.path, name + '_widget.dart');
    final widgetFuture =
        writeFile(filename: widgetFile, text: widgetText(name, className));

    final wmFile = p.join(dir.path, name + '_wm.dart');
    final wmFuture = writeFile(filename: wmFile, text: wmText(name, className));

    return Future.wait(
      [
        modelFuture,
        widgetFuture,
        wmFuture,
      ],
    ).then((value) => print('done'), onError: (error, stackTrace) {
      if (error is FileSystemException) {
        print('cleaning up');
        // TODO delete broken files
      } else {
        throw error;
      }
    });
  }

  String modelText(String className) {
    final buffer = StringBuffer()
      ..write('''import 'package:elementary/elementary.dart';

class ${className}Model extends Model {
  ${className}Model(ErrorHandler errorHandler) : super(errorHandler: errorHandler);
}
''');
    return buffer.toString();
  }

  String widgetText(String filename, String className) {
    final buffer = StringBuffer()
      ..write('''import '${filename}_wm.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

class ${className}Widget extends WMWidget<I${className}WidgetModel> {
  const ${className}Widget({
    Key? key,
    WidgetModelFactory wmFactory = default${className}WidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(I${className}WidgetModel wm) {
    return Container();
  }
}
''');
    return buffer.toString();
  }

  String wmText(String filename, String className) {
    final buffer = StringBuffer()
      ..write('''import '${filename}_model.dart';
import '${filename}_widget.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

abstract class I${className}WidgetModel extends IWM {
}

${className}WidgetModel default${className}WidgetModelFactory(BuildContext context) {
  //final model = context.read<${className}Model>();
  return ${className}WidgetModel(model);
}

class ${className}WidgetModel extends WidgetModel<${className}Widget, ${className}Model>
    implements I${className}WidgetModel {
  
  ${className}WidgetModel(${className}Model model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
''');
    return buffer.toString();
  }

  Future<void> writeFile({
    required String filename,
    required String text,
  }) async {
    final file = await File(filename).create();
    final sink = file.openWrite();
    sink.write(text);
    sink.close();
  }
}
