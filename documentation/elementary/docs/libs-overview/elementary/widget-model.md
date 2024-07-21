In the MVVM concept, the ViewModel is the workhorse: it connects the View and Model, orchestrates business processes, and contains presentation logic. This is why `WidgetModel` is the key part of the responsibility chain in Elementary.

## WidgetModel's properties

Flutter has many internal optimizations and can be highly effective, but there’s no magic to make every code efficient; we also need to care about performance. One aspect that everyone encounters in every application is rebuilds. It is [crucial](https://docs.flutter.dev/perf/best-practices#control-build-cost) to make them efficient. The most efficient approach is to rebuild only the parts that need to change.

At the same time, MVVM is convenient to use when there is binding between UI parts and ViewModel properties.

Based on this, Elementary aims to use properties that follow the [Observer](https://refactoring.guru/design-patterns/observer) design pattern paradigm. In this case, a property acts as the subject (publisher). In the widget layer, we use a builder subscribed to the property, functioning as the observer (dependent/subscriber).

<img src="https://i.ibb.co/5MVNrqN/property-rebuild.gif" alt="Property rebuild scheme">

There’s no mandatory requirement for which implementation of this pattern to use — it can be ChangeNotifiers, Streams, or any other preferred method. However, for your convenience, a few implementations are provided with Elementary. To find them, check the [support library](https://pub.dev/packages/elementary_helper).

Properties that are not intended to change or initiate a visual update can simply be getters or fields.

## WidgetModel's lifecycle

As mentioned earlier, the `WidgetModel` has its lifecycle synchronized with the lifecycle of the `Element` to which it belongs. If you're familiar with the lifecycle of [State](https://api.flutter.dev/flutter/widgets/State-class.html) in a [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html), it will be easy for you — they are quite similar. The one significant difference is that the methods `didUpdateWidget` and `didChangeDependencies` do not automatically initiate a rebuild of the subtree. The reason for this is that Elementary aims to avoid unnecessary rebuilds, and with the property-publisher approach, you can efficiently rebuild only the parts of the UI that require updates. So, the sole purpose of these methods is to notify you that these events occur, and the final decision on what and how to rebuild is up to you.

### Lifecycle methods:

- ***`initWidgetModel`*** is called only once in the lifecycle of the WidgetModel in the beginning (before the first build).
This method can be used to initiate a starting state of the `WidgetModel`.

- ***`didUpdateWidget`*** is called whenever the corresponding `ElementaryWidget` instance in the tree has been updated.
A common case is when the rebuild comes from the top of the tree. This method is a good place to actualize the state of the `WidgetModel` based on the new configuration of the widget. *This does not lead to a rebuild of the subtree. Please set new values to publishers for rebuilding specific parts of the UI.*

- ***`didChangeDependencies`*** is called whenever the dependencies that `WidgetModel` [subscribed](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) to by BuildContext change. *This does not lead to a rebuild of the subtree. Please set new values to publishers for rebuilding specific parts of the UI.*

- ***`deactivate`*** is called when the `WidgetModel` with `Elementary` is removed from the tree.

- ***`activate`*** is called when the `WidgetModel` with `Elementary` is reinserted into the tree after being removed via deactivate.

- ***`dispose`*** is called when the `WidgetModel` is going to be permanently destroyed.

- ***`reassemble`*** is called whenever the application is reassembled during debugging, for example during a hot reload.

- ***`onErrorHandle`*** is called when the `ElementaryModel` handles an error with the `ElementaryModel.handleError` method.
Can be useful for general handling errors, such as showing a snack bar.

## WidgetModel as a contract

It can be a good idea to use an interface for your `WidgetModel`s for the sake of code testability and to explicitly describe the contract that can be used during the subtree build by `ElementaryWidget`.

```dart
/// An interface for [ExampleScreenWidgetModel]
abstract interface class IExampleScreenWidgetModel implements IWidgetModel {
  /// Provides observable information about some integer value.
  ValueListenable<int> get exampleProperty;
}
```

## Сompleteness of the state description

`WidgetModel` is the source of truth for describing the subtree. This means it should provide everything required for this build. In other words, the contract of the `WidgetModel` should be a complete abstraction of what is shown on the UI. In this case, the building subtree appears to be only a declarative description by the rule `UI = f(S)`.

## Access to Context

***`WidgetModel` is the only place that has access to `BuildContext` in the triad `ElementaryWidget-WidgetModel-ElementaryModel`.***

There are a few reasons for this:

- `WidgetModel` has a tight bond with the `Elementary`, which is an Element (BuildContext).
- `WidgetModel` contains everything relative to presentation logic and defining the current state => all updates by the context subscription should come there.
- `ElementaryModel` is a business logic layer. Business logic should be pure and independent from Flutter. So BuildContext is not appropriate there.
- `ElementaryWidget` should contain only a declarative description and be free from any logic. It also has the source of truth, which is `WidgetModel`.

It is important to note that all this is relative only to the level when `ElementaryWidget` is used, and down-laying widgets might have access to context on their levels.

## Access to Widget

Respecting the general Flutter approach, `ElementaryWidget` is an immutable configuration. `WidgetModel` has access to `ElementaryWidget` at any time. This can be useful for initiating or updating `WidgetModel`'s properties.

```dart
@override
void initWidgetModel() {
  super.initWidgetModel();

  _someProperty = ValueNotifier<int>.value(widget.passedValue);
}

@override
void didUpdateWidget(TestPageWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (widget.passedValue != oldWidget.passedValue) {
    _someProperty.value = widget.passedValue;
  }
}
```

## Showcase Example

This is a simple example showing a case with loading data from the network. While loading, we use previous data. As a property providing this data to the UI, we use `EntityStateNotifier` - a publisher with 3 base states: content, error, and loading. For more details about the implementation of this publisher, check the [support library](https://pub.dev/packages/elementary_helper).

```dart
/// Widget Model for [ExampleScreen]
class ExampleWidgetModel extends WidgetModel<ExampleScreen, ExampleModel> implements IExampleWidgetModel {
  final _exampleState = EntityStateNotifier<ExampleEntity>();

  @override
  ListenableState<EntityState<ExampleEntity>> get exampleState => _exampleState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _loadData();
  }

  Future<void> _loadData() async {
    final previousData = _exampleState.value?.data;
    _exampleState.loading(previousData);

    try {
      final res = await model.loadData();
      _exampleState.content(res);
    } on Exception catch (e) {
      _exampleState.error(e, previousData);
    }
  }
}

/// An interface for [ExampleWidgetModel]
abstract interface class IExampleWidgetModel implements IWidgetModel {
  ListenableState<EntityState<ExampleEntity>> get exampleState;
}
```
