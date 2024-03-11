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

## Description

The primary goal of the library is to help write application in a simple and reliable way, as well as make the codebase
easier readable and more testable. This approach is based on splitting code into different layers depends on
responsibilities, those as business logic, presentation logic and declarative description for UI.
Due to this layer separation, the library brings additional performance boost for teams, because a few persons can
work on the same feature at the same time but on different layers. This library was inspired by Flutter itself,
MVVM architecture pattern, Business Logic Component architecture pattern, as well by fundamental principles
of Clean Architecture.

## Overview

Thanks to elaborately separated responsibilities, Elementary makes it easier to manage whatever is displayed at a
particular moment based on concrete conditions and business logic state of the app. Let's check the graphic schema
of how it works internally for a simple screen, and what the user sees every moment.

<img src="https://i.ibb.co/rk4sxDf/3.gif" alt="Elementary scheme">

## Technical Overview

Elementary uses a classical layers from the MVVM pattern, such as View, View Model, and Model. There are special
entities which represent these layers: ElementaryWidget as a View layer, WidgetModel as a View Model layer, and
ElementaryModel as a Model layer.

At the same time Elementary follows the Flutter-similar approach, so all these things are managed by Element.

<img src="https://i.ibb.co/yyZYwcd/elementary-scheme.png" alt="Elementary scheme">

### WidgetModel

The key part in the chain of responsibilities is the WidgetModel layer that connects all other layers together and
provides to ElementaryWidget a set of parameters which are describe the current presentation state. It is a working
horse of the internal processes of Elementary, and the only source of truth for building a presentation
(by the MVVM concept). 

#### WidgetModel's properties

MVVM is very efficient when possible to use binding properties. It is easy with Flutter, and Elementary does it.
Elementary is sharped to use one side binding properties, which based on the design pattern Publisher-Subscriber.
There is no mandatory requirement which one to use - you can decide based on circumstances for your concrete case.
You can use ChangeNotifiers (like a ValueNotifier or StateNotifier, etc.), Streams, or any other.
For properties which are not supposed to change, or initiate a visual change when they are changed, common getters also
appropriate.

#### Lifecycle

Due to Widget Model is a central entity that binds all layers between and at the same time connected with Element,
Widget Model has its own lifecycle. If you are familiar with the State lifecycle for StatefulWidget it should be
as well simple for you.

`initWidgetModel` is called only once for lifecycle of the WidgetModel in the really beginning before the first build.
It can be used for initiate a starting state of the WidgetModel.

`didUpdateWidget` called whenever widget instance in the tree has been updated. Common case where rebuild comes from
the top. This method is a good place for update state of the WidgetModel based on the new configuration of widget.
When this method is called is just a signal for decide what exactly should be updated or rebuilt. The fact of update
doesn't mean that build method of the widget will be called. Set new values to publishers for rebuild concrete
parts of the UI.

`didChangeDependencies` called whenever dependencies which WidgetModel subscribed with BuildContext change. When this
method is called is just a signal for decide what exactly should be updated or rebuilt. The fact of the call doesn't
mean that build method of the widget will be called. Set new values to publishers for rebuild concrete parts of the UI.

`deactivate` called when the WidgetModel with Element removed from the tree.

`activate` called when WidgetModel with Elementary are reinserted into the tree after having been removed via deactivate.

`dispose` called when WidgetModel is going to be permanently destroyed.

`reassemble` called whenever the application is reassembled during debugging, for example during the hot reload.

`onErrorHandle` called when the ElementaryModel handle error with the ElementaryModel.handleError method.
Can be useful for general handling errors such as showing snack-bars.

#### Contract

It is good to use an interface for a Widget Model, to make the code more testable and describe the contract
in explicit way.

```dart
/// An interface for [ExampleScreenWidgetModel]
abstract interface class IExampleScreenWidgetModel implements IWidgetModel {
  ListenableState<EntityState<ExampleEntity>> get exampleState;
}
```

#### I = f(S) or a discrete state of UI

A bit scary name of the section, but really simple meaning. In Flutter, we target to use declarative description of UI.
We use to have a `build` method for component style widgets to describe a part of UI when Flutter needs it.
Elementary Widget isn't an exception, but to describe a part of UI it uses Widget Model as a source of truth.
A Widget Model instance is provided right into the build method and guaranty by its interface (contract) that everything
that is needed to describe UI part is provided by Widget Model's properties.

#### Context

_The only place where we have access to BuildContext and need to interact with it is Widget Model._

There are a few reasons to this.
- ElementaryModel is already a business logic layer. Business logic should be pure and independent. BuildContext is not
appropriate here.
- ElementaryWidget has source of truth in form of WidgetModel. Using context there, we spread responsibilities
and break the fact of being a source of truth for WidgetModel.
- WidgetModel has tight bound with the Element.

It is important to note that this fact applies only to the triad of entities ElementaryWidget-WidgetModel-ElementaryModel,
widgets which are used by ElementaryWidget in the build method can have access to context.

#### Widget - base immutable configuration

Based on general Flutter approach, widget is an immutable configuration. WidgetModel has access to ElementaryWidget
at any time. It can be useful for initiate or update WidgetModel's properties:

```dart
@override
void initWidgetModel() {
  super.initWidgetModel();

  _someProperty = EntityStateNotifier<int>.value(widget.passedValue);
}

@override
void didUpdateWidget(TestPageWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (widget.passedValue != oldWidget.passedValue) {
    _someProperty.content(widget.passedValue);
  }
}
```

#### Example

This is a simple example shows loading data from the network with providing previous data while loading:

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

ElementaryModel is the only point of interaction with business logic for WidgetModel. It provides a contract of
available business logic interaction in one entity. Based on this ElementaryModel is the only WidgetModel's dependency
related to business logic. ElementaryModel can be implemented in a free style: as a bunch of simple methods,
proxy that redirect to internal implementations, or combine with any other approaches.

### Widget

For Elementary as well as for Flutter, Widget is a simple configuration firstly. It describes the starting params,
provides the factory for Widget Model and is a delegate for describe UI part represented by this Widget. The main
difference from other composition widgets is the simplified build process - since business logic and presentation
logic are encapsulated in the Model and Widget Model, it is only left to the widget to follow the UI=f(s) principle and
describe this UI based on the Widget Model contract. Therefore, the build method doesn't have context and accepts only
Widget Model contract as an argument.

It looks like this:

```dart
@override
Widget build(ICountryListWidgetModel wm) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Country List'),
    ),
    body: EntityStateNotifierBuilder<Iterable<Country>>(
      listenableEntityState: wm.countryListState,
      loadingBuilder: (_, __) => const _LoadingWidget(),
      errorBuilder: (_, __, ___) => const _ErrorWidget(),
      builder: (_, countries) =>
          _CountryList(
            countries: countries,
            nameStyle: wm.countryNameStyle,
          ),
    ),
  );
}
```

## How to test

Since the layers are well-separated from each other, they are easy to test with a number of options available.

* Use unit tests for Model layer;
* Use widget and golden tests for Widget layer;
* Use widget-model tests from elementary_test library for WidgetModel.
* Use integration tests to check all together.

## Utils

To make Elementary easier to use, some helpers have been added. As it was mentioned previously, you can use any
types of properties follows the Publisher-Subscriber pattern. Additionally, to available by default in Dart and Flutter
Elementary contains a bunch of personal and builders for them.
Check [elementary_helper](https://pub.dev/packages/elementary_helper) to find more.

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
