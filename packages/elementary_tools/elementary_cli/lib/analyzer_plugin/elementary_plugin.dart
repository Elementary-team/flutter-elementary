import 'dart:async';

// ignore_for_file: implementation_imports
import 'package:analyzer/dart/analysis/context_builder.dart';
import 'package:analyzer/dart/analysis/context_locator.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:dart_code_metrics/config.dart';
import 'package:dart_code_metrics/lint_analyzer.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/lint_analysis_config.dart';

// copypaste from 'https://github.com/dart-code-checker/dart-code-metrics/blob/master/lib/src/analyzer_plugin/analyzer_plugin.dart'
class ElementaryAnalyzerPlugin extends ServerPlugin {
  static const _analyzer = LintAnalyzer();

  final _configs = <AnalysisDriverGeneric, LintAnalysisConfig>{};

  @override
  List<String> get fileGlobsToAnalyze => <String>['**/*.dart'];

  @override
  String get name => 'Elementary';

  @override
  String get version => '1.0.0';

  var _filesFromSetPriorityFilesRequest = <String>[];

  ElementaryAnalyzerPlugin(ResourceProvider provider) : super(provider);

  @override
  AnalysisDriverGeneric createAnalysisDriver(ContextRoot contextRoot) {
    final rootPath = contextRoot.root;
    final locator =
        ContextLocator(resourceProvider: resourceProvider).locateRoots(
      includedPaths: [rootPath],
      excludedPaths: contextRoot.exclude,
      optionsFile: contextRoot.optionsFile,
    );

    if (locator.isEmpty) {
      final error = StateError('Unexpected empty context');
      channel.sendNotification(PluginErrorParams(
        true,
        error.message,
        error.stackTrace.toString(),
      ).toNotification());

      throw error;
    }

    final builder = ContextBuilder(resourceProvider: resourceProvider);
    final context = builder.createContext(contextRoot: locator.first)
        as DriverBasedAnalysisContext;
    final dartDriver = context.driver;
    final config = _createConfig(dartDriver, rootPath);

    if (config == null) {
      return dartDriver;
    }

    runZonedGuarded<void>(
      () {
        dartDriver.results.listen((analysisResult) {
          if (analysisResult is ResolvedUnitResult) {
            _processResult(dartDriver, analysisResult);
          }
        });
      },
      (e, stackTrace) {
        channel.sendNotification(
          PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification(),
        );
      },
    );

    return dartDriver;
  }

  @override
  void contentChanged(String path) {
    super.driverForPath(path)?.addFile(path);
  }

  /// Handle a 'completion.getSuggestions' request.
  @override
  Future<CompletionGetSuggestionsResult> handleCompletionGetSuggestions(
    CompletionGetSuggestionsParams parameters,
  ) async {
    const randomOffset = 0;
    const randomLength = 2;

    final results = [
      CompletionSuggestion(
        CompletionSuggestionKind.IDENTIFIER,
        1,
        // some number - relevance
        'myCompletion',
        randomOffset,
        randomLength,
        false,
        false,
        displayText: 'myDisplayText',
      ),
    ];
    return CompletionGetSuggestionsResult(randomOffset, randomLength, results);
  }

  @override
  Future<AnalysisSetContextRootsResult> handleAnalysisSetContextRoots(
    AnalysisSetContextRootsParams parameters,
  ) async {
    final result = await super.handleAnalysisSetContextRoots(parameters);
    // The super-call adds files to the driver, so we need to prioritize them so they get analyzed.
    _updatePriorityFiles();

    return result;
  }

  @override
  Future<AnalysisSetPriorityFilesResult> handleAnalysisSetPriorityFiles(
    AnalysisSetPriorityFilesParams parameters,
  ) async {
    _filesFromSetPriorityFilesRequest = parameters.files;
    _updatePriorityFiles();

    return AnalysisSetPriorityFilesResult();
  }

  @override
  Future<EditGetFixesResult> handleEditGetFixes(
    EditGetFixesParams parameters,
  ) async {
    try {
      final driver = driverForPath(parameters.file) as AnalysisDriver;
      final analysisResult = await driver.getResult2(parameters.file);

      if (analysisResult is! ResolvedUnitResult) {
        return EditGetFixesResult([]);
      }

      final fixes = _check(driver, analysisResult)
          .where((fix) =>
              fix.error.location.file == parameters.file &&
              fix.error.location.offset <= parameters.offset &&
              parameters.offset <=
                  fix.error.location.offset + fix.error.location.length &&
              fix.fixes.isNotEmpty)
          .toList();

      return EditGetFixesResult(fixes);
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );

      return EditGetFixesResult([]);
    }
  }

  void _processResult(
    AnalysisDriver driver,
    ResolvedUnitResult analysisResult,
  ) {
    try {
      if (driver.analysisContext?.contextRoot.isAnalyzed(analysisResult.path) ??
          false) {
        final fixes = _check(driver, analysisResult);

        channel.sendNotification(
          AnalysisErrorsParams(
            analysisResult.path,
            fixes.map((fix) => fix.error).toList(),
          ).toNotification(),
        );
      } else {
        channel.sendNotification(
          AnalysisErrorsParams(analysisResult.path, []).toNotification(),
        );
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }
  }

  Iterable<AnalysisErrorFixes> _check(
    AnalysisDriver driver,
    ResolvedUnitResult analysisResult,
  ) {
    final result = <AnalysisErrorFixes>[];
    final config = _configs[driver];

    if (config != null) {
      final root = driver.analysisContext?.contextRoot.root.path;

      final report = _analyzer.runPluginAnalysis(analysisResult, config, root!);

      if (report != null) {
        result.addAll([
          ...report.issues,
          ...report.antiPatternCases,
        ].map((issue) => codeIssueToAnalysisErrorFixes(issue, analysisResult)));
      }

      // Temporary disable deprecation check
      //
      // if (analysisResult.path ==
      //     driver.analysisContext?.contextRoot.optionsFile?.path) {
      //   final deprecations = checkConfigDeprecatedOptions(
      //     config,
      //     deprecatedOptions,
      //     analysisResult.path ?? '',
      //   );
      //
      //   result.addAll(deprecations);
      // }
    }

    return result;
  }

  LintAnalysisConfig? _createConfig(AnalysisDriver driver, String rootPath) {
    final file = driver.analysisContext?.contextRoot.optionsFile;
    if (file != null && file.exists) {
      final options = AnalysisOptions(
        file.path,
        const {},
        // yamlMapToDartMap(
        //   AnalysisOptionsProvider(driver.sourceFactory)
        //       .getOptionsFromFile(file),
        // ),
      );
      final config = ConfigBuilder.getLintConfigFromOptions(options);
      final lintConfig = ConfigBuilder.getLintAnalysisConfig(
        config,
        options.folderPath ?? rootPath,
        classMetrics: const [],
        // functionMetrics: [
        //   NumberOfParametersMetric(config: config.metrics),
        //   SourceLinesOfCodeMetric(config: config.metrics),
        // ],
      );

      _configs[driver] = lintConfig;

      return lintConfig;
    }

    return null;
  }

  /// AnalysisDriver doesn't fully resolve files that are added via `addFile`; they need to be either explicitly requested
  /// via `getResult`/etc, or added to `priorityFiles`.
  ///
  /// This method updates `priorityFiles` on the driver to include:
  ///
  /// - Any files prioritized by the analysis server via [handleAnalysisSetPriorityFiles]
  /// - All other files the driver has been told to analyze via addFile (in [ServerPlugin.handleAnalysisSetContextRoots])
  ///
  /// As a result, [_processResult] will get called with resolved units, and thus all of our diagnostics
  /// will get run on all files in the repo instead of only the currently open/edited ones!
  void _updatePriorityFiles() {
    final filesToFullyResolve = {
      // Ensure these go first, since they're actually considered priority; ...
      ..._filesFromSetPriorityFilesRequest,

      // ... all other files need to be analyzed, but don't trump priority
      for (final driver2 in driverMap.values)
        ...(driver2 as AnalysisDriver).addedFiles,
    };

    // From ServerPlugin.handleAnalysisSetPriorityFiles
    final filesByDriver = <AnalysisDriverGeneric, List<String>>{};
    for (final file in filesToFullyResolve) {
      final contextRoot = contextRootContaining(file);
      if (contextRoot != null) {
        // TODO(dkrutskikh): Which driver should we use if there is no context root?
        final driver = driverMap[contextRoot];
        if (driver != null) {
          filesByDriver.putIfAbsent(driver, () => <String>[]).add(file);
        }
      }
    }
    filesByDriver.forEach((driver, files) {
      driver.priorityFiles = files;
    });
  }
}
