import 'package:counter/impl/screen/test_page_widget_model.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

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
                return Text(
                  data.toString(),
                  style: wm.counterStyle,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: EntityStateNotifierBuilder<int>(
        listenableEntityState: wm.valueState,
        loadingBuilder: (_, data) {
          return const FloatingActionButton(
            onPressed: null,
            tooltip: 'Increment',
            child: Icon(Icons.sync_problem),
          );
        },
        builder: (_, data) {
          return FloatingActionButton(
            onPressed: wm.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
