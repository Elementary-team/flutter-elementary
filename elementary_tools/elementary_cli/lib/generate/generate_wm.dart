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

    final modelFile = p.join(dir.path, name + '_model.dart');
    final modelFuture = writeFile(filename: modelFile, text: modelText(name));

    final widgetFile = p.join(dir.path, name + '_widget.dart');
    final widgetFuture =
        writeFile(filename: widgetFile, text: widgetText(name));

    final wmFile = p.join(dir.path, name + '_wm.dart');
    final wmFuture = writeFile(filename: wmFile, text: wmText(name));

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

  String modelText(String templateName) {
    final buffer = StringBuffer()
      ..write(templateName)
      ..write(' model');
    return buffer.toString();
  }

  String widgetText(String templateName) {
    final buffer = StringBuffer()
      ..write(templateName)
      ..write(' widget');
    return buffer.toString();
  }

  String wmText(String templateName) {
    final buffer = StringBuffer()
      ..write(templateName)
      ..write(' wm');
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
