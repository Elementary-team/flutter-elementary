import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _counterNotifier = ValueNotifier<int>(0);
  final _colorNotifier = ValueNotifier<Color>(Colors.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Helper example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            DoubleValueListenableBuilder<int, Color>(
              firstValue: _counterNotifier,
              secondValue: _colorNotifier,
              builder: (_, value, color) {
                return Text(
                  '$value',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: color),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _counterNotifier.value++;
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              _colorNotifier.value = Colors.red;
            },
            tooltip: 'Change color red',
            child: const Icon(
              Icons.color_lens_outlined,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              _colorNotifier.value = Colors.green;
            },
            tooltip: 'Change color green',
            child: const Icon(
              Icons.color_lens_outlined,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
