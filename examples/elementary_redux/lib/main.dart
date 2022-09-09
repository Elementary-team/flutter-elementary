import 'package:flutter/material.dart';
import 'package:redux_elementary_test/app_providers.dart';

import 'screen/main_screen.dart';

void main() {
  runApp(const AppProviders(
    child: MyApp(),
  ));
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
      home: const MainScreen(),
    );
  }
}
