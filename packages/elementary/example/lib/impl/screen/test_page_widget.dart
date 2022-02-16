import 'package:counter/impl/screen/test_page_widget_model.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

/// Widget for demo.
class TestPageWidget extends ElementaryWidget<ITestPageWidgetModel> {
  const TestPageWidget({
    Key? key,
    WidgetModelFactory wmFactory = testPageWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITestPageWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            EntityStateNotifierBuilder<int>(
              listenableEntityState: wm.valueState,
              loadingBuilder: (_, data) {
                return const CircularProgressIndicator();
              },
              builder: (_, data) {
                return _CounterText(
                  value: data.toString(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: EntityStateNotifierBuilder<int>(
        listenableEntityState: wm.valueState,
        loadingBuilder: (_, data) {
          return const _IncrementButton(
            iconData: Icons.sync_problem,
          );
        },
        builder: (_, data) {
          return _IncrementButton(
            onPressed: wm.increment,
            iconData: Icons.add,
          );
        },
      ),
    );
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
      tooltip: 'Increment',
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
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
