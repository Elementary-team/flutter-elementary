import 'dart:async';
import 'dart:io';

import 'package:analysis_server_client/handler/connection_handler.dart';
import 'package:analysis_server_client/handler/notification_handler.dart';
import 'package:analysis_server_client/protocol.dart';
import 'package:analysis_server_client/server.dart';
import 'package:elementary_cli/console_writer.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';

class ElementaryClient {
  ElementaryClient() {
    server = Server();
  }

  late final Server server;
  late final ElementaryHandler handler;

  Future<void> start() async {
    await server.start();
    handler = ElementaryHandler(server);
    server.listenToOutput(notificationProcessor: handler.handleEvent);
    if (!await handler.serverConnected(
        timeLimit: const Duration(seconds: 15))) {
      throw "Cannot connect to dart analysis server";
    }
    await server.send(SERVER_REQUEST_SET_SUBSCRIPTIONS,
        ServerSetSubscriptionsParams([ServerService.STATUS]).toJson());

    final root = Directory.current.path;
    // ConsoleWriter.write('Analysis root: $root');

    // TODO(AlexeyBukin): make root a parameter
    await server.send(
        ANALYSIS_REQUEST_SET_ANALYSIS_ROOTS,
        AnalysisSetAnalysisRootsParams([root], const [])
            .toJson());
    await handler.analysisCompleter.future;



    // ODO(AlexeyBukin): await on SET_ANALYSIS_ROOTS request with a callback from handler
    // await Future<void>.delayed(Duration(seconds: 5));
  }

  Future<void> applyImportFixes(String filepath) async {
    final file = path.normalize(path.absolute(filepath));
    ConsoleWriter.write('file to apply: $file');
    final jsonAnswer = await server.send(
        ANALYSIS_REQUEST_GET_ERRORS, AnalysisGetErrorsParams(file).toJson());
    final answer = AnalysisGetErrorsResult.fromJson(
        ResponseDecoder(null), r'$', jsonAnswer);
    final fixableErrors = await Future.wait(answer.errors
        .where((e) => e.hasFix ?? false)
        .map((e) => getErrorFixes(e.location)));
    ConsoleWriter.write('length ${fixableErrors.length}');
    for (final error in fixableErrors) {
      for (final errorFixes in error) {
        ConsoleWriter.write('fix ${error.length}');
        for (final fix in errorFixes.fixes) {
          ConsoleWriter.write('message: ${ fix.message}');
          if (fix.message.startsWith("Import library 'package:")) {
            ConsoleWriter.write('import ${ errorFixes.fixes.length}');
            _applyImportFix(fix);
          }
        }
        // errorFixes.fixes
        //     .where((f) => f.message.startsWith('Import'))
        //     .forEach(_applyImportFix);
      }
    }
    // organize imports
  }

  void _applyImportFix(SourceChange fix) {
    ConsoleWriter.write('58');
    // parallel work on multiple files makes no sense with imports
    // because there will be only one file in all cases
    for (final sourceFileEdit in fix.edits) {
      final file = File(sourceFileEdit.file);
      if (!file.existsSync()) {
        throw 'FILE DOES NOT EXISTS';
      }
      final code = file.readAsStringSync();
      final newCode = SourceEdit.applySequence(code, sourceFileEdit.edits);
      file.writeAsStringSync(newCode);
      ConsoleWriter.write('68');
    }
  }

  Future<void> analyzeFile(String file) async {
    // final dir = Directory.current;
    // ConsoleWriter.write(dir);

    final fileEntity = File(path.normalize(path.absolute(file)));
    if (!fileEntity.existsSync()) {
      throw "file does not exist";
    }
    final filePath = fileEntity.path;
    final dirPath = path.dirname(filePath);

    final c = Completer<List<AnalysisError>>();
    handler
      ..onAnalysisErrorsCompleter = c
      ..onAnalysisErrorsFile = filePath;

    // Request analysis
    await server.send(
        ANALYSIS_REQUEST_SET_ANALYSIS_ROOTS,
        AnalysisSetAnalysisRootsParams(
            [dirPath, Directory.current.path], const []).toJson());
    // await server.send(ANALYSIS_REQUEST_GET_ERRORS,
    //     AnalysisGetErrorsParams(filePath).toJson());
    final errors = await c.future;
    //
    // errors.forEach((error) {
    //   var loc = error.location;
    //   var corr = error.correction;
    //   ConsoleWriter.write('  ${error.message} • ${loc.startLine}:${loc.startColumn}  - $corr');
    // });

    await Future.wait(errors.map((e) => getErrorFixes(e.location)));
  }

  // Future<void> getErrorAssists(Location location) async {
  //   final file = location.file;
  //   final offset = location.offset;
  //   final length = location.length;
  //   final answerJson = await server.send(EDIT_REQUEST_GET_ASSISTS,
  //       EditGetAssistsParams(file, offset, length).toJson());
  //   // fianl jsonDecoder = ResponseDecoder(null);
  //   final answer = EditGetAssistsResult.fromJson( ResponseDecoder(null), r'$', answerJson);
  //   // final assists = answer?['assists'] as List<dynamic>;
  //   // final assistsTrue = assists.cast<Map<String, Object?>>();
  //   // final message = assistsTrue.map((e) => e['message']).join("\n");
  //   final text = answer.assists.map((a) => '${a.id} * ${a.message} : ${a.edits}').join("\n");
  //   ConsoleWriter.write(text);
  // }

  Future<List<AnalysisErrorFixes>> getErrorFixes(Location location) async {
    final file = location.file;
    final offset = location.offset;
    final answerJson = await server.send(
        EDIT_REQUEST_GET_FIXES, EditGetFixesParams(file, offset).toJson());
    // fianl jsonDecoder = ResponseDecoder(null);
    final answer =
        EditGetFixesResult.fromJson(ResponseDecoder(null), r'$', answerJson);
    // final assists = answer?['assists'] as List<dynamic>;
    // final assistsTrue = assists.cast<Map<String, Object?>>();
    // final message = assistsTrue.map((e) => e['message']).join("\n");
    String fixesToString(List<SourceChange> fixes) {
      return fixes.map((f) {
        var report = '\n*----- ${f.id} - ${f.message}';
        // TODO(Alexbukin): find a better way to identify source change
        // .id property is optional, also may have postfix numbers
        if (f.message.startsWith('Import')) {
          report += f.edits
              .map((e) =>
                  '\n          apply ${e.edits.map((e) => e.replacement)}')
              .join();
        }
        return report;
      }).join();
    }

    final text = answer.fixes
        .map((a) =>
            '${a.error.code} * ${a.error.message} : ${fixesToString(a.fixes)}')
        .join("\n");
    ConsoleWriter.write(text);
    return answer.fixes;
  }

  Future<void> stop() async {
    await server.stop();
  }
}

class ElementaryHandler with NotificationHandler, ConnectionHandler {
  @override
  final Server server;
  int errorCount = 0;

  late Completer<void> analysisCompleter = Completer<void>();

  Completer<List<AnalysisError>> onAnalysisErrorsCompleter =
      Completer<List<AnalysisError>>();
  String onAnalysisErrorsFile = '';

  ElementaryHandler(this.server);

  @override
  void onAnalysisErrors(AnalysisErrorsParams params) {
    // params.

    // ConsoleWriter.write('params: ${params.toString()}');
    //
    // var errors = params.errors;
    // var first = true;
    // for (var error in errors) {
    //   if (error.type.name == 'TODO') {
    //     // Ignore these types of "errors"
    //     continue;
    //   }
    //   if (first) {
    //     first = false;
    //     ConsoleWriter.write('${params.file}:');
    //   }
    //   var loc = error.location;
    //   ConsoleWriter.write('  ${error.message} • ${loc.startLine}:${loc.startColumn}');
    //   ++errorCount;
    // }

    if (params.file == onAnalysisErrorsFile) {
      if (!onAnalysisErrorsCompleter.isCompleted) {
        onAnalysisErrorsCompleter.complete(
            params.errors.where((element) => element.hasFix ?? false).toList());
      }
    }
  }

  @override
  void onFailedToConnect() {
    ConsoleWriter.write('Failed to connect to server');
  }

  @override
  void onProtocolNotSupported(Version version) {
    ConsoleWriter.write(
        'Expected protocol version $PROTOCOL_VERSION, but found $version');
  }

  @override
  void onServerError(ServerErrorParams params) {
    if (params.isFatal) {
      ConsoleWriter.write('Fatal Server Error: ${params.message}');
    } else {
      ConsoleWriter.write('Server Error: ${params.message}');
    }
    ConsoleWriter.write(params.stackTrace);
    super.onServerError(params);
  }

  @override
  void onServerStatus(ServerStatusParams params) {
    final analysisStatus = params.analysis;
    if (analysisStatus != null && !analysisStatus.isAnalyzing) {
      if (!analysisCompleter.isCompleted) {
        analysisCompleter.complete();
      }
      // // Whenever the server stops analyzing,
      // // print a brief summary of what issues have been found.
      // if (errorCount == 0) {
      //   ConsoleWriter.write('No issues found.');
      // } else {
      //   ConsoleWriter.write('Found $errorCount errors/warnings/hints');
      // }
      // errorCount = 0;
      // ConsoleWriter.write('--------- ctrl-c to exit ---------');
    }
  }
}

// /// A simple application that uses the analysis server to analyze a package.
// void main(List<String> args) async {
//   var target = await parseArgs(args);
//   ConsoleWriter.write('Analyzing $target');
//
//   // Launch the server
//   var server = Server();
//   await server.start();
//
//   // Connect to the server
//   var handler = ElementaryHandler(server);
//   server.listenToOutput(notificationProcessor: handler.handleEvent);
//   if (!await handler.serverConnected(timeLimit: const Duration(seconds: 15))) {
//     exit(1);
//   }
//
//   // Request analysis
//   await server.send(SERVER_REQUEST_SET_SUBSCRIPTIONS,
//       ServerSetSubscriptionsParams([ServerService.STATUS]).toJson());
//   await server.send(ANALYSIS_REQUEST_SET_ANALYSIS_ROOTS,
//       AnalysisSetAnalysisRootsParams([target], const []).toJson());
//
//   // Continue to watch for analysis until the user presses Ctrl-C
//   late StreamSubscription<ProcessSignal> subscription;
//   subscription = ProcessSignal.sigint.watch().listen((_) async {
//     ConsoleWriter.write('Exiting...');
//     // ignore: unawaited_futures
//     subscription.cancel();
//     await server.stop();
//   });
// }
//
// Future<String> parseArgs(List<String> args) async {
//   if (args.length != 1) {
//     printUsageAndExit('Expected exactly one directory');
//   }
//   final dir = Directory(path.normalize(path.absolute(args[0])));
//   if (!dir.existsSync()) {
//     printUsageAndExit('Could not find directory ${dir.path}');
//   }
//   return dir.path;
// }
//
// void printUsageAndExit(String errorMessage) {
//   ConsoleWriter.write(errorMessage);
//   ConsoleWriter.write('');
//   final appName = path.basename(Platform.script.toFilePath());
//   ConsoleWriter.write('Usage: $appName <directory path>');
//   ConsoleWriter.write('  Analyze the *.dart source files in <directory path>');
//   exit(1);
// }
