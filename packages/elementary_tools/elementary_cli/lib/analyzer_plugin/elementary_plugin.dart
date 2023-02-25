import 'dart:async';

// ignore_for_file: implementation_imports
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';

class ElementaryAnalyzerPlugin extends ServerPlugin {
  @override
  List<String> get fileGlobsToAnalyze => <String>['**/*.dart'];

  @override
  String get name => 'Elementary';

  @override
  String get version => '1.0.0';

  ElementaryAnalyzerPlugin({required super.resourceProvider});

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {}
}
