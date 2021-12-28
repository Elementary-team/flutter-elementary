import 'dart:async';
import 'dart:io';

import 'package:analysis_server_client/handler/connection_handler.dart';
import 'package:analysis_server_client/handler/notification_handler.dart';
import 'package:analysis_server_client/protocol.dart';
import 'package:analysis_server_client/server.dart';
import 'package:elementary_cli/exit_code_exception.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';


/// Some actions implicitly start new analysis
/// To wait
class ElementaryClient {
  final log = Logger('ElementaryClient');
  final Server server = Server();
  late final ElementaryHandler handler = ElementaryHandler(server);

  Future<String> get analysisCompletion => handler.analysisStatusStream.first;

  Future<void> start() async {
    log.fine('Starting connection with analysis server...');
    await server.start();
    server.listenToOutput(notificationProcessor: handler.handleEvent);
    if (!await handler.serverConnected(
        timeLimit: const Duration(seconds: 15))) {
      throw ServerTimeoutException('Cannot connect to dart analysis server');
    }
    await server.send(SERVER_REQUEST_SET_SUBSCRIPTIONS,
        ServerSetSubscriptionsParams([ServerService.STATUS]).toJson());

    final root = Directory.current.path;
    log.fine('Analysis root: ${path.toUri(root)}');

    // TODO(AlexeyBukin): make root a parameter
    await server.send(ANALYSIS_REQUEST_SET_ANALYSIS_ROOTS,
        AnalysisSetAnalysisRootsParams([root], const []).toJson());
    await handler.analysisStatusStream.first;

    log.fine('Starting connection with analysis server... Done.');
  }

  Future<void> applyImportFixes(String filepath) async {
    log.fine('Applying Import fixes...');
    final file = path.normalize(path.absolute(filepath));
    log.fine('Target: ${path.toUri(file)}');
    final jsonAnswer = await server.send(
      ANALYSIS_REQUEST_GET_ERRORS,
      AnalysisGetErrorsParams(file).toJson(),
    );
    final answer = AnalysisGetErrorsResult.fromJson(
      ResponseDecoder(null),
      r'$',
      jsonAnswer,
    );
    final fixableErrors = await Future.wait(answer.errors
        .where((e) => e.hasFix ?? false)
        .map((e) => getErrorFixes(e.location)));
    final importFixes = List<SourceEdit>.empty(growable: true);
    for (final error in fixableErrors) {
      for (final errorFixes in error) {
        // Apply only package imports to avoid double imports
        importFixes.addAll(
          errorFixes.fixes
              .where((f) => f.message.startsWith("Import library 'package:"))
              .expand((fix) => fix.edits)
              .where((edit) => edit.file == file)
              .expand((edit) => edit.edits),
        );
      }
    }
    // avoid same imports for different errors
    final importStrings =
        importFixes.map((f) => f.replacement).toSet().toList();

    // The new analysis session will start after some files' contents updated
    if (importStrings.isNotEmpty) {
      _insertImportEdits(file, importStrings);
    } else {
      log.fine('No fixes found');
    }
    await analysisCompletion;

    // logging experiments...
    //
    // await logFunction(
    //   function: organizeImports,
    //   lambda: () => organizeImports(file)
    // );

    await organizeImports(file);
    // organize imports

    log.fine('Applying Import fixes... Done.');
  }

  // logging experiments...
  //
  // dynamic logFunction({
  //   required Function function,
  //   required Function lambda,
  // }) {
  //   final splitted = function.toString().split("'");
  //   final functionName = splitted.length > 1 ? splitted[1] : 'anonimous';
  //   log.info('Calling $functionName...');
  //   final dynamic result = lambda.call();
  //   log.info('Calling $functionName... Done.');
  //   return result;
  // }

  /// Gets and applies import edits, unsafe for FileDoesNotExists...
  Future<void> organizeImports(String filepath) async {
    // log.info(organizeImports.toString().split("'")[1]);
    log.fine('Organizing imports...');
    final file = File(filepath);
    final answerJson = await server.send(
      EDIT_REQUEST_ORGANIZE_DIRECTIVES,
      EditOrganizeDirectivesParams(filepath).toJson(),
    );
    final answer = EditOrganizeDirectivesResult.fromJson(
      ResponseDecoder(null),
      r'$',
      answerJson,
    );
    final code = file.readAsStringSync();
    final newCode = SourceEdit.applySequence(code, answer.edit.edits);
    file.writeAsStringSync(newCode);
    log.fine('Organizing imports... Done.');
  }

  /// inserts [edits] to [filepath], unsafe for FileDoesNotExists...
  void _insertImportEdits(String filepath, List<String> edits) {
    log.fine('Inserting import edits...');
    final file = File(filepath);
    final code = file.readAsStringSync();
    final newCode = '${edits.join()}\n$code';
    file.writeAsStringSync(newCode);
    log.fine('Inserting import edits... Done.');
  }

  Future<List<AnalysisErrorFixes>> getErrorFixes(Location location) async {
    log.fine('Getting error fixes...');
    final file = location.file;
    final offset = location.offset;
    final answerJson = await server.send(
        EDIT_REQUEST_GET_FIXES, EditGetFixesParams(file, offset).toJson());
    final answer = EditGetFixesResult.fromJson(
      ResponseDecoder(null),
      r'$',
      answerJson,
    );
    log.fine('Getting error fixes... Done.');
    return answer.fixes;
  }

  Future<void> stop() async {
    log.fine('Closing connection with analysis server...');
    handler.stop();
    await server.stop();
    log.fine('Closing connection with analysis server... Done.');
  }
}

class ElementaryHandler with NotificationHandler, ConnectionHandler {
  ElementaryHandler(this.server);

  void stop() {
    _analysisStreamController.close();
  }

  final StreamController<String> _analysisStreamController =
      StreamController<String>.broadcast();
  late Stream<String> analysisStatusStream = _analysisStreamController.stream;

  @override
  final Server server;

  @override
  void onProtocolNotSupported(Version version) {
    Logger.root.severe(
        'Expected protocol version $PROTOCOL_VERSION, but found $version');
  }

  @override
  void onServerError(ServerErrorParams params) {
    if (params.isFatal) {
      Logger.root.severe('Fatal Server Error: ${params.message}');
    } else {
      Logger.root.warning('Server Error: ${params.message}');
    }
    Logger.root.warning(params.stackTrace);
    super.onServerError(params);
  }

  @override
  void onServerStatus(ServerStatusParams params) {
    final analysisStatus = params.analysis;
    if (analysisStatus != null && !analysisStatus.isAnalyzing) {
      if (!_analysisStreamController.isClosed) {
        _analysisStreamController.add('Analysis completed');
      }
    }
  }
}
