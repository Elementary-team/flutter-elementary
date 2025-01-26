# Elementary
###
<p align="center">
    <a href="https://documentation.elementaryteam.dev/libs/elementary/intro/"><img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo"></a>
</p>

###

<p align="center">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://img.shields.io/pub/v/elementary?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://app.codecov.io/gh/Elementary-team/flutter-elementary"><img src="https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary&logo=codecov&logoColor=white" alt="Coverage Status"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/points/elementary" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/likes/elementary" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://img.shields.io/pub/dm/elementary" alt="Downloads"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"><img src="https://badgen.net/github/contributors/Elementary-team/flutter-elementary" alt="Contributors"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/blob/main/LICENSE"><img src="https://badgen.net/github/license/Elementary-team/flutter-elementary" alt="License"></a>
</p>

## What this library is

This is an implementation of the [Model-View-ViewModel (MVVM)](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) pattern
for Flutter applications. 

## Description

The current implementation follows the rules of the [MVVM](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) architecture pattern, is inspired by the internal implementation of Flutter, and incorporates positive aspects from the [Business Logic Component](https://www.youtube.com/watch?v=RS36gBEp8OI) architecture pattern and Clean Architecture principles.


#### Benefits of using

- **Clear Layer Separation:** 
The code is divided into layers with distinct responsibilities, making it easy even for newbie developers to get started with the library.

- **High Independence Between Layers:** 
This decoupling simplifies testing and maintenance. It also allows team members to work independently on different layers while developing a single feature, which leads to decreasing time-to-feature.

- **Ease of Testing:**
The easier it is to test, the more cases are covered. This approach supports various test types, such as unit, widget, golden, and end-to-end tests. Writing tests with Elementary requires minimal additional effort, providing strong motivation to do it.

- **Fully Declarative Widget Layer:**
The widget layer remains purely declarative, devoid of any logic. This aligns with Flutter's focus on declarative UI, with other layers handling the logic.

- **Efficient rebuilds:**
Flutter’s optimized rebuild strategies are crucial for performance. Elementary uses the observer pattern for properties, minimizing unnecessary rebuilds and enhancing application efficiency.

## Overview

A good way to demonstrate the library's functionality without technical details is with this scheme: in the WidgetModel, we determine what to display to the user and manage the business processes running behind the scenes.

<img src="https://i.ibb.co/rk4sxDf/3.gif" alt="Elementary scheme">

## Crossroad

If you’re not interested in the technical implementation details or the reasons behind specific decisions, follow this [simple guideline](https://documentation.elementaryteam.dev/tutorials/qs/tooling/) to quickly start using the library.

For those interested in the technical details and rationale behind our decisions, welcome to the next section of this documentation.

## Technical Overview

Elementary follows classical MVVM layering, comprising the View, ViewModel, and Model layers. Each layer is represented by a specific entity: `ElementaryWidget` for the View layer, `WidgetModel` for the ViewModel layer, and `ElementaryModel` for the Model layer.

To naturally integrate this chain of entities into the Flutter trees, the following decisions were made:

- An `ElementaryWidget`, like all other widgets, is simply a configuration and an immutable description of a part of the user interface.
- An `ElementaryWidget` is a component widget (represented by a [ComponentElement](https://api.flutter.dev/flutter/widgets/ComponentElement-class.html)), meaning it describes its subtree as a combination of other widgets.
- A representation of an `ElementaryWidget` in the Element tree is a special [Element](https://api.flutter.dev/flutter/widgets/Element-class.html) called `Elementary`.
- `Elementary` creates a `WidgetModel` using a factory method from `ElementaryWidget` and then stores and manages it.
- The lifecycle of the `WidgetModel` is connected to the `Elementary` lifecycle, as indicated in the previous statement.
- A `WidgetModel` depends on an `ElementaryModel`, stores it, and manages its lifecycle.
- When a subtree needs to be described, `Elementary` delegates to the `build` method of `ElementaryWidget`, providing the `WidgetModel`. This represents `UI=f(State)` in the form `subtree=build(WM)`.

The following diagram illustrates how these components work when an ElementaryWidget is inserted into the tree:

<img src="https://i.ibb.co/hYcYRbs/elementary-In-Tree.gif" alt="Elementary scheme in tree">

### WidgetModel

In the MVVM concept, the ViewModel is the workhorse: it connects the View and Model, orchestrates business processes, and contains presentation logic. This is why `WidgetModel` is the key part of the responsibility chain in Elementary.

#### WidgetModel's properties

Flutter has many internal optimizations and can be highly effective, but there’s no magic to make every code efficient; we also need to care about performance. One aspect that everyone encounters in every application is rebuilds. It is [crucial](https://docs.flutter.dev/perf/best-practices#control-build-cost) to make them efficient. The most efficient approach is to rebuild only the parts that need to change.

At the same time, MVVM is convenient to use when there is binding between UI parts and ViewModel properties.

Based on this, Elementary aims to use properties that follow the [Observer](https://refactoring.guru/design-patterns/observer) design pattern paradigm. In this case, a property acts as the subject (publisher). In the widget layer, we use a builder subscribed to the property, functioning as the observer (dependent/subscriber).

<img src="https://i.ibb.co/5MVNrqN/property-rebuild.gif" alt="Property rebuild scheme">

There’s no mandatory requirement for which implementation of this pattern to use — it can be ChangeNotifiers, Streams, or any other preferred method. However, for your convenience, a few implementations are provided with Elementary. To find them, check the [support library](https://pub.dev/packages/elementary_helper).

Properties that are not intended to change or initiate a visual update can simply be getters or fields.

#### WidgetModel's lifecycle

As mentioned earlier, the `WidgetModel` has its lifecycle synchronized with the lifecycle of the `Element` to which it belongs. If you're familiar with the lifecycle of [State](https://api.flutter.dev/flutter/widgets/State-class.html) in a [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html), it will be easy for you — they are quite similar. The one significant difference is that the methods `didUpdateWidget` and `didChangeDependencies` do not automatically initiate a rebuild of the subtree. The reason for this is that Elementary aims to avoid unnecessary rebuilds, and with the property-publisher approach, you can efficiently rebuild only the parts of the UI that require updates. So, the sole purpose of these methods is to notify you that these events occur, and the final decision on what and how to rebuild is up to you.

##### Lifecycle methods:

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

#### WidgetModel as a contract

It can be a good idea to use an interface for your `WidgetModel`s for the sake of code testability and to explicitly describe the contract that can be used during the subtree build by `ElementaryWidget`.

```dart
/// An interface for [ExampleScreenWidgetModel]
abstract interface class IExampleScreenWidgetModel implements IWidgetModel {
  /// Provides observable information about some integer value.
  ValueListenable<int> get exampleProperty;
}
```

#### Сompleteness of the state description

`WidgetModel` is the source of truth for describing the subtree. This means it should provide everything required for this build. In other words, the contract of the `WidgetModel` should be a complete abstraction of what is shown on the UI. In this case, the building subtree appears to be only a declarative description by the rule `UI = f(S)`.

#### Context

***`WidgetModel` is the only place that has access to `BuildContext` in the triad `ElementaryWidget-WidgetModel-ElementaryModel`.***

There are a few reasons for this:

- `WidgetModel` has a tight bond with the `Elementary`, which is an Element (BuildContext).
- `WidgetModel` contains everything relative to presentation logic and defining the current state => all updates by the context subscription should come there.
- `ElementaryModel` is a business logic layer. Business logic should be pure and independent from Flutter. So BuildContext is not appropriate there.
- `ElementaryWidget` should contain only a declarative description and be free from any logic. It also has the source of truth, which is `WidgetModel`.

It is important to note that all this is relative only to the level when `ElementaryWidget` is used, and down-laying widgets might have access to context on their levels.

#### Base immutable configuration

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

#### Example

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

### Model
For the MVVM concept [Model classes are](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#model):

non-visual classes that encapsulate the app's data. Therefore, the model can be thought of as representing the app's domain model, which usually includes a data model along with business and validation logic. Examples of model objects include data transfer objects (DTOs), Plain Old CLR Objects (POCOs), and generated entity and proxy objects. They are typically used in conjunction with services or repositories that encapsulate data access and caching.

So based on that, `ElementaryModel` is the single point of interaction with business logic for the related `WidgetModel`. It encapsulates all required business logic for the `WidgetModel` and provides it as a contract. Summarizing it, for every `WidgetModel`, a corresponding `ElementaryModel` is the single business logic dependency. Apart from that, there is no other requirement for the `ElementaryModel` implementation, and internally it can be built as you prefer.

Note: My preference is to implement it as a bunch of pure functions that return Futures, and proxying to services responsible for concrete business domains.

### Widget

#### Widget as a View description
`ElementaryWidget` represents a View layer in the triad `ElementaryWidget-WidgetModel-ElementaryModel`. In the MVVM concept, [views are responsible](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#view) for defining the structure, layout, and appearance of what the user sees on screen.

It is important to remember that Flutter is a declarative framework, and any Flutter widget is not a view, but a configuration/description. So, it is more accurate to say that `ElementaryWidget` is a view description, a component widget that uses other widgets to describe a composition that needs to be shown to the user. By hiding how the framework works behind the widget concept, we can simplify to equate `ElementaryWidget` with View.

The significant difference from other composition widgets is the simplified build process. Since business logic and presentation logic are encapsulated in the Model and Widget Model, it is only left to the widget to follow the `UI = f(s)` principle and describe this UI based on the `WidgetModel` contract. Therefore, the build method doesn't have context and accepts only the `WidgetModel` contract as an argument.

Here is an example of `ElementaryWidget`'s build method for a case of loading data from the network:

```dart
@override
Widget build(IExampleWidgetModel wm) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Example Screen'),
    ),
    body: EntityStateNotifierBuilder<ExampleEntity>(
      listenableEntityState: wm.exampleState,
      loadingBuilder: (_, __) => const _LoadingWidget(),
      errorBuilder: (_, __, ___) => const _ErrorWidget(),
      builder: (_, data) => _ContentWidget(data: data),
    ),
  );
}
```

#### Widget as a starting and updating configuration
Apart from describing a subtree, `ElementaryWidget` is a configuration. On one side, it is a configuration of the MVVM layers, meaning this widget defines a factory to be used for creating a corresponding `WidgetModel` instance. On the other side, it is a Flutter way to set and update externally defined parameters. For example, for a screen that shows detailed information about a product, it could be the product's ID. However, it can be any information defined higher up in the tree, and an update to the configuration automatically leads to a call for lifecycle methods.

## Recommendations on how to test
Since all layers are well-separated from each other, they are easy to test with many options available.

- The Model layer contains only business logic, so use unit tests for it.
- Use widget-model tests from the elementary_test library for `WidgetModel`s. These tests are also unit tests but with ready-to-use controls for emulating the lifecycle.
- Use widget and golden tests for the Widget layer. This should be easy because you don't need to mock all internal things, only the values from the `WidgetModel` contract.
- Use integration tests to check the workflow together.

## Utils

There are many helpers available for Elementary. Check [elementary_helper](https://pub.dev/packages/elementary_helper) to find them. Their purpose is to make using Elementary smooth. However, as mentioned, you can use them if you prefer, but you are not obligated to if you prefer something else.

## Maintainer

<a href="https://github.com/MbIXjkee">
    <div style="display: inline-block;">
        <img src="https://i.ibb.co/6Hhpg5L/circle-ava-jedi.png" height="64" width="64" alt="Maintainer avatar">
        <p style="float:right; margin-left: 8px;">Mikhail Zotyev</p>
    </div>
</a>

## Contributors thanks

Big thanks to all these people, who put their effort into helping the project.

![contributors](https://contributors-img.firebaseapp.com/image?repo=Elementary-team/flutter-elementary)
<a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"></a>

Special thanks to:

[Dmitry Krutskikh](https://github.com/dkrutskikh), [Konoshenko Vlad](https://github.com/vlkonoshenko), and 
[Denis Grafov](https://github.com/grafovdenis) for the early adoption and the first production feedback;

[Alex Bukin](https://github.com/AlexeyBukin) for IDE plugins;

All members of the Surf Flutter Team for actively using and providing feedback.

## Sponsorship

Special sponsor of the project:

<a href="https://surf.dev/">
<img src="https://surf.dev/wp-content/themes/surf/assets/img/logo.svg" alt="Surf"/>
</a>

For all questions regarding sponsorship/collaboration connect with [Mikhail Zotyev](https://github.com/MbIXjkee).
