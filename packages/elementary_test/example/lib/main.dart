import 'package:counter/impl/screen/test_page_model.dart';
import 'package:counter/impl/screen/test_page_widget.dart';
import 'package:elementary/elementary.dart';
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
      home: MultiProvider(
        providers: [
          Provider<TestPageModel>(
            create: (_) => TestPageModel(
              TestErrorHandler(),
            ),
          ),
          Provider<ThemeWrapper>(
            create: (_) => ThemeWrapper(),
          ),
        ],
        child: const TestPageWidget(),
      ),
    );
  }
}

class TestErrorHandler implements ErrorHandler {
  @override
  void handleError(Object error) {
    // ignore: avoid_print
    print(error);
  }
}
