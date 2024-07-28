import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      home: const TestPageWidget(),
    );
  }
}

class TestPageWidget extends ElementaryWidget<TestPageWidgetModel> {
  const TestPageWidget({
    Key? key,
    WidgetModelFactory wmFactory = testPageWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(TestPageWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Counter:'),
            ValueListenableBuilder<bool>(
              valueListenable: wm.calculatingState,
              builder: (_, isCalculating, __) {
                return isCalculating
                    ? const CircularProgressIndicator()
                    : ValueListenableBuilder<String>(
                        valueListenable: wm.valueState,
                        builder: (_, value, __) {
                          return _CounterText(
                            value: value,
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: wm.calculatingState,
        builder: (_, isCalculating, __) {
          return isCalculating
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IncrementButton(
                      iconData: Icons.sync_problem,
                    ),
                    SizedBox(height: 8),
                    _IncrementButton(
                      iconData: Icons.sync_problem,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IncrementButton(
                      onPressed: wm.increment,
                      iconData: Icons.add,
                    ),
                    const SizedBox(height: 8),
                    _IncrementButton(
                      onPressed: wm.decrement,
                      iconData: Icons.remove,
                    ),
                  ],
                );
        },
      ),
    );
  }
}

TestPageWidgetModel testPageWidgetModelFactory(BuildContext context) {
  return TestPageWidgetModel(TestPageModel());
}

class TestPageWidgetModel extends WidgetModel<TestPageWidget, TestPageModel> {
  late ValueNotifier<String> _valueController;
  late final _calculatingController = ValueNotifier<bool>(false);

  ValueListenable<String> get valueState => _valueController;
  ValueListenable<bool> get calculatingState => _calculatingController;

  TestPageWidgetModel(TestPageModel model) : super(model);

  Future<void> increment() async {
    _calculatingController.value = true;

    final newVal = await model.increment();
    _valueController.value = newVal.toString();

    _calculatingController.value = false;
  }

  Future<void> decrement() async {
    _calculatingController.value = true;

    final newVal = await model.decrement();
    _valueController.value = newVal.toString();

    _calculatingController.value = false;
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _valueController = ValueNotifier<String>(model.value.toString());
  }

  @override
  void dispose() {
    _valueController.dispose();
    _calculatingController.dispose();

    super.dispose();
  }
}

class TestPageModel extends ElementaryModel {
  var _value = 0;
  int get value => _value;

  TestPageModel();

  Future<int> increment() async {
    // In academic purpose emulate a process that takes some time.
    await Future<void>.delayed(const Duration(seconds: 1));

    return ++_value;
  }

  Future<int> decrement() async {
    // In academic purpose emulate a process that takes some time.
    await Future<void>.delayed(const Duration(seconds: 1));

    if (_value > 0) {
      _value--;
    }

    return _value;
  }
}

class _IncrementButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;

  const _IncrementButton({
    Key? key,
    required this.iconData,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(iconData),
    );
  }
}

class _CounterText extends StatelessWidget {
  final String value;

  const _CounterText({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
