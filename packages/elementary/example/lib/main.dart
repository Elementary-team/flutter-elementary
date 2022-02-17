import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<TestErrorHandler>(
        create: (_) => TestErrorHandler(),
        child: const TestPageWidget(),
      ),
    );
  }
}

/// Error handler that print info to console
class TestErrorHandler implements ErrorHandler {
  @override
  void handleError(Object error) {
    if (kDebugMode) {
      print(error);
    }
  }
}
