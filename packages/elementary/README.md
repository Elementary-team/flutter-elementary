# Elementary
###
<p align="center">
    <img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo">
</p>

###

<p align="center">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://img.shields.io/pub/v/elementary?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://app.codecov.io/gh/Elementary-team/flutter-elementary"><img src="https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary&logo=codecov&logoColor=white" alt="Coverage Status"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/points/elementary" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/likes/elementary" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/popularity/elementary" alt="Pub popularity"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"><img src="https://badgen.net/github/contributors/Elementary-team/flutter-elementary" alt="Contributors"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/blob/main/LICENSE"><img src="https://badgen.net/github/license/Elementary-team/flutter-elementary" alt="License"></a>
</p>

## What this library is

This is an implementation of the [Model-View-ViewModel (MVVM)](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) pattern
for Flutter applications. 

## Description

The current implementation follows the rules of the [MVVM](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) architecture pattern, is inspired by internal Flutter's implementation, and tries to have positive things
from the [Business Logic Component](https://www.youtube.com/watch?v=RS36gBEp8OI) architecture pattern and Clean Architecture.

#### Benefits of using

- **The code is split into layers with clear responsibilities.** 
It makes starting working with the library easy even for newbie developers.

- **Layers are highly independent of each other.** 
It also serves to decouple purposes, which helps to keep code easy testable and maintainable. An additional benefit for teams - different persons can 
effectively share work in different layers while one feature is developed.

- **Easy to test -> more cases are covered.**
This approach is compatible with different types of tests: unit, widget, golden, e2e. Writing tests using Elementary costs almost nothing of additional effort, that is
the best motivation to do it.

- **The widget part is fully declarative and gets rid of any kind of logic.**
Declarative UI is one of the beauties of Flutter, and Elementary supports this as it is possible, for any logic there are other layers!

- **Efficient rebuilds.**
Flutter has highly optimized approaches to work with rebuild because it is a key part of performant applications. Keeping rebuilds efficient is the crucial part of any
Flutter application. Elementary relies on the publisher-subscriber pattern for properties that help to avoid unnecessary rebuilds.


## Overview

Without technical details of the implementation, a good way to demonstrate the work of the library is the following scheme:
in the WidgetModel we decide what to show to the user, and which business processes are running behind the scenes.

<img src="https://i.ibb.co/rk4sxDf/3.gif" alt="Elementary scheme">

## Crossroad

If you aren't interested in the technical details of implementation, and why concrete decisions were made, just try this simple guideline of how to quickly start
using the library.

Those who want to know these things - welcome to the following part of this documentation.

## Technical Overview

Elementary follows classical layering from the MVVM pattern. It has a View, View Model, and Model layers. Each of these layers is represented by a special
entity: `ElementaryWidget` represents the View layer, `WidgetModel` represents the View Model layer, and `ElementaryModel` represents the Model layer.

At the same time, this chain of entities should be naturally integrated into the Flutter trees. To achieve it following decisions were made:

- An `ElementaryWidget` like all other widgets is just a configuration and an immutable description of the part of the user interface.
- An `ElementaryWidget` is a component widget (a widget represented by a [ComponentElement](https://api.flutter.dev/flutter/widgets/ComponentElement-class.html)), which means the widget describes its subtree as a combination of other widgets.
- A representation of an `ElementaryWidget` in the Element tree is a special [Element](https://api.flutter.dev/flutter/widgets/Element-class.html) called `Elementary`.
- `Elementary` creates a `WidgetModel` using a factory method from `ElementaryWidget` and then stores and manages this `WidgetModel`.
- From the previous statement following the lifecycle of the `WidgetModel` is connected to the `Elementary` lifecycle.
- A `WidgetModel` depends on an `ElementaryModel`, stores it, and manages its lifecycle.
- When a subtree should be described, `Elementary` delegates it to the `build` method of `ElementaryWidget` at the same time providing `WidgetModel` there.
So this is a representation of `UI=f(State)` in a form `subtree=build(WM)`.

The following schema demonstrates how all these things work when we insert ElementaryWidget into the tree.

// TODO: change the schema to the more clear one
<img src="https://i.ibb.co/yyZYwcd/elementary-scheme.png" alt="Elementary scheme">

### WidgetModel

In the MVVM concept the View Model is a working horse: it connects View and Model, orchestrates business processes, and contains presentation logic.
That is the reason why `WidgetModel` is the key part of the responsibility chain in Elementary.

#### WidgetModel's properties

Flutter has a lot of internal optimizations and can be highly effective. But there is no magic, and we need to care about performance too.
A thing that every one of us, and in every application, works with is rebuilds. It is [crucial](https://docs.flutter.dev/perf/best-practices#control-build-cost) to make them efficient. The most efficient way to do it - is to rebuild only those parts that should be changed.

At the same time, MVVM is convenient to use when there is a binding between parts of UI and View Model properties.

Based on this Elementary aims to use properties that work in the [Observer](https://refactoring.guru/design-patterns/observer) design pattern paradigm. In this case,
a property is the subject (publisher). In the widget layer, we use a builder subscribed to the property and be an observer (dependent/subscriber).

There is no mandatory requirement on which implementation of this pattern to use - it can be ChangeNotifiers, Streams, or whatever else, based on your preferences.
But for your convenience, there are a few implementations provided with Elementary. To find them, check the [support library](https://pub.dev/packages/elementary_helper).

Properties are not supposed to be changed, or initiate a visual change when they are changed, can be a simple getter or field.

#### WidgetModel's lifecycle

As it was mentioned earlier, `WidgetModel` has its lifecycle synchronized with the lifecycle of the `Element` it belongs.
If you are familiar with the lifecycle of [State](https://api.flutter.dev/flutter/widgets/State-class.html) in [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html), it will be easy for you - they are pretty much the same.
The one significant difference: methods `didUpdateWidget` and `didChangeDependencies` do not initiate an automatic rebuild of
the subtree. The reason for this - Elementary aims to avoid unnecessary rebuilds and with the help of the property-publisher approach, you can efficiently rebuild only the parts of UI required for update. So their only purpose is to notify you that those
things happen, and the final decision on what and how to rebuild is up to you.

##### Methods:

- ***`initWidgetModel`*** is called only once in the lifecycle of the WidgetModel in the beginning (before the first build).
This method can be used to initiate a starting state of the `WidgetModel`.

- ***`didUpdateWidget`*** is called whenever the respective `ElementaryWidget` instance in the tree has been updated.
A common case where rebuild comes from the top of the tree. This method is a good place to actualize the state of the `WidgetModel` based on the new configuration of the widget. *Does not lead to rebuild of the subtree. Please, set new values to publishers for rebuilding concrete parts of the UI.*

- ***`didChangeDependencies`*** is called whenever change the dependencies that `WidgetModel` [subscribed](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) by BuildContext. *Does not lead to rebuild of the subtree. Please, set new values to publishers for rebuilding concrete parts of the UI.*

- ***`deactivate`*** is called when the `WidgetModel` with `Elementary` is removed from the tree.

- ***`activate`*** is called when `WidgetModel` with `Elementary` is reinserted into the tree after being removed via deactivate.

- ***`dispose`*** is called when `WidgetModel` is going to be permanently destroyed.

- ***`reassemble`*** is called whenever the application is reassembled during debugging, for example during the hot reload.

- ***`onErrorHandle`*** is called when the `ElementaryModel` handles an error with the `ElementaryModel.handleError` method.
Can be useful for general handling errors such as showing a snack bar.

#### WidgetModel as a contract

It can be a good idea to use an interface for your `WidgetModel`s, for the sake of the code testability, and explicitly describing the contract that can be used during the subtree build by `ElementaryWidget`.

```dart
/// An interface for [ExampleScreenWidgetModel]
abstract interface class IExampleScreenWidgetModel implements IWidgetModel {
  /// Provides observable information about some integer value.
  ValueListenable<int> get exampleProperty;
}
```

#### Сompleteness of the state description

`WidgetModel` is the source of truth for describing subtree, that means it should provide everything required for this build.
In other words, the contract of the `WidgetModel` should be a complete abstraction of what we show on the UI. In this case, the building subtree appears to be only declarative description by the rule `UI = f(S)`.

#### Context

***`WidgetModel` is the only place that has access to `BuildContext` in the triad `ElementaryWidget-WidgetModel-ElementaryModel`.***

There are a few reasons for this.
- `WidgetModel` has a tight bond with the `Elementary` which is an Element (BuildContext).
- `WidgetModel` contains everything relative to presentation logic and defining the current state => all updates by the context subscription should come there.
- `ElementaryModel` is a business logic layer. Business logic should be pure and independent from Flutter. So BuildContext is not
appropriate here.
- `ElementaryWidget` should contain only a declarative description, and be free from any logic. It also has the source of truth which is `WidgetModel`.

It is important to note that all this is relative only to the level when `ElementaryWidget` is used, and down-laying widgets might have access to context on their levels.

#### Base immutable configuration

Respectfully the general Flutter approach, `ElementaryWidget` is an immutable configuration. WidgetModel has access to ElementaryWidget at any time. It can be useful for initiating or updating `WidgetModel`'s properties:

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

This is a simple example showing loading data from the network. While loading we use previous data. As property providing this data
to UI we use `EntityStateNotifier` - a publisher with 3 base states: content, error, and loading. For more details about the implementation of this publisher, check the [support library](https://pub.dev/packages/elementary_helper).

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

So based on that, `ElementaryModel` is the single point of interaction with business logic for related `WidgetModel`. It encapsulates the all required business logic
for the `WidgetModel`, provides it as a contract. Summarizing it, for an every `WidgetModel`, a corresponding `ElementaryModel` is the single business logic dependency.
Apart from that there is no other requirement to the `ElementaryModel` implementation, and internally it can be built as you personally prefer.

Note: I prefer to implement it as a bunch of pure functions which return Futures.

### Widget

#### Widget as a View description
`ElementaryWidget` represents a View layer in the triad `ElementaryWidget-WidgetModel-ElementaryModel`. In the MVVM concept, [views are responsible](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#view) for defining the structure, layout, and appearance of what the user sees on screen.

It is important to remind that Flutter is a declarative framework, and any Flutter's widget is not a view, but a configutation/description. So more accurate to
say that `ElementaryWidget` is a view description, a component widget that uses other widgets to describe a composition that need to be shown to the user. With hiding how the framework works behind the widget concept, we can simplify to equality between `ElementaryWidget` and View.

The significant difference from other composition widgets is the simplified build process - since business logic and presentation logic are encapsulated in the Model and Widget Model, it is only left to the widget to follow the UI=f(s) principle and describe this UI based on the Widget Model contract. Therefore, the build method doesn't have context and accepts only Widget Model contract as an argument.

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
Apart from describing a subtree, `ElementaryWidget` is a configuration. From the one side it is a configuration of the MVVM layers, so this widget defines
a factory which should be used for creating  a corresponding `WidgetModel` instance. From the another side it is a Flutter way to set and update outside defined params, e.g for a screen that shows detail information of a product, it can be an id of the product. But it can be any information which defined higher by the tree,
and an updating of the configuration automatically leads to call of lifecycle methods.

## Recommendations on how to test
Since all layers are well-separated from each other, they are easy to test with a number of options available.

- The Model layer contains only business logic, so use unit tests for it.
- Use widget-model tests from elementary_test library for `WidgetModel`s. Those tests are also unit tests, but with ready to use controls for emulating the lifecycle.
- Use widget and golden tests for the Widget layer. It should be easy, becuase
you don't need to mock all internal things, but only values from the `WidgetModel` contract.
- Use integration tests to check the workflow together.

## Utils

There are many helpers available for Elementary. Check [elementary_helper](https://pub.dev/packages/elementary_helper) to find them. Their purpose is to make using Elementary smooth. But, as mentioned, you can use them, but you don't have to if prefer something else.

## Maintainer

<a href="https://github.com/MbIXjkee">
    <div style="display: inline-block;">
        <img src="https://i.ibb.co/6Hhpg5L/circle-ava-jedi.png" height="64" width="64" alt="Maintainer avatar">
        <p style="float:right; margin-left: 8px;">Mikhail Zotyev</p>
    </div>
</a>

## Contributors thanks

Big thanks to all these people, who put their effort to help the project.

![contributors](https://contributors-img.firebaseapp.com/image?repo=Elementary-team/flutter-elementary)
<a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"></a>

Special thanks to:

[Dmitry Krutskikh](https://github.com/dkrutskikh), [Konoshenko Vlad](https://github.com/vlkonoshenko),
[Denis Grafov](https://github.com/grafovdenis) for the early adoption and the first production feedback;

[Alex Bukin](https://github.com/AlexeyBukin) for IDE plugins;

All members of the Surf Flutter Team for actively using and providing feedback.

## Sponsorship

Special sponsor of the project:

<a href="https://surf.ru/">
<img src="https://surf.ru/wp-content/themes/surf/assets/img/logo.svg" alt="Surf"/>
</a>

For all questions regarding sponsorship/collaboration connect with [Mikhail Zotyev](https://github.com/MbIXjkee).
