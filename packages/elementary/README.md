# Elementary

<img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo" style="margin:50px 0px">

[![Pub Version](https://img.shields.io/pub/v/elementary?logo=dart&logoColor=white)](https://pub.dev/packages/elementary)
[![Coverage Status](https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary&logo=codecov&logoColor=white)](https://app.codecov.io/gh/Elementary-team/flutter-elementary)
[![Pub Likes](https://badgen.net/pub/likes/elementary)](https://pub.dev/packages/elementary)
[![Pub popularity](https://badgen.net/pub/popularity/elementary)](https://pub.dev/packages/elementary)
![Flutter Platform](https://badgen.net/pub/flutter-platform/elementary)

## Description

The primary goal of this library is to split code into different responsibility layers, thus making it clearer, simpler
as well as more readable and testable. This approach is based on an architectural pattern called MVVM and the
fundamentals of Clean Architecture.

## Overview

Thanks to its elaborately separated concerns, Elementary makes it easier to manage whatever is displayed at a particular
moment and bind it with the business logic of your app. Now, before we get into detail about its structure, let's look
at the graph so that you can see for yourself how easy it is to work with Elementary.

<img src="https://i.ibb.co/rk4sxDf/3.gif" alt="Elementary scheme">

## Technical Overview

This library applies a classic principle of an MVVM pattern, which is layering. In it, we have Widget acting as a View
layer, WidgetModel as a ViewModel layer, and Model as a Model layer.

And all of that put together works pretty similar to Flutter itself.

<img src="https://i.ibb.co/yyZYwcd/elementary-scheme.png" alt="Elementary scheme">

### WidgetModel

The key part in this chain of responsibility is the WidgetModel layer that connects the rest of the layers together and
describes state to Widget via a set of parameters. Moreover, it is the only source of truth when you build an image. By
the time build is called on the widget, the WidgetModel should provide it with all the data needed for a build. The
class representing this layer in the library has the same name – WidgetModel. You can describe a state to be rendered as
a set of various properties. You can use changeNotifiers (like a valueNotifier or stateNotifier, etc.), streams, getters
or something else as properties. In order to determine the properties required, you should specify them in the
IWidgetModel interface, the subclasses of which, in turn, determine what properties are used in this or that situation.

Due to this, the WidgetModel is the only place where presentation logic is described: what interaction took place and
what occurred as a result.

For example, when data is loaded from the network, the WidgetModel looks like this:

```dart
/// Widget Model for [CountryListScreen]
class CountryListScreenWidgetModel extends WidgetModel<CountryListScreen, CountryListScreenModel>
    implements ICountryListWidgetModel {
  final _countryListState = EntityStateNotifier<Iterable<Country>>();

  @override
  ListenableState<EntityState<Iterable<Country>>> get countryListState =>
      _countryListState;

  /// Some special wm working code this
  /// ...............................................................

  Future<void> _loadCountryList() async {
    final previousData = _countryListState.value?.data;
    _countryListState.loading(previousData);

    try {
      final res = await model.loadCountries();
      _countryListState.content(res);
    } on Exception catch (e) {
      _countryListState.error(e, previousData);
    }
  }
}
```

Interface for this WidgetModel looks like this:

```dart
/// Interface of [CountryListScreenWidgetModel]
abstract class ICountryListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<Iterable<Country>>> get countryListState;
}
```

_The only place where we have access to BuildContext and need to interact with it is WidgetModel._

WidgetModel has access to Widget at any time, e.g. for using its properties like a configuration. It can be useful for
initiate or update WidgetModel's properties like this:


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

### Model

The only WidgetModel dependency related to business logic is Model. The class representing this layer in the library is
called ElementaryModel. There is no declared way to define this one, meaning you can choose whichever way works best for
your project. One of the reasons behind that is to provide an easy way to combine _elementary_ with other approaches
related specifically to business logic.

### Widget

Since all logic is already described in the WidgetModel and Model, Widget only needs to declare what a certain part of
the interface should look like at a particular moment based on the WidgetModel properties. The class representing the
Widget layer in the library is called ElementaryWidget. The build method called to display a widget only has one
argument – the IWidgetModel interface.

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
* Use widget model test from elementary_test library for WidgetModel.

## Tooling

To make Elementary easier to use, some tools have been added.

### StateNotifier

In order to establish a quicker response to any changes in properties of a state object, you can use a StateNotifier. It
is a subclass of ChangeNotifier. StateNotifier's subscribers are notified whenever a state change occurs. Also, the
subscriber will be called for the first time at the moment of subscription. The initialization of the StateNotifier does
not require an initial value to be specified, for this reason the value returned by it may be null.

```dart

final _somePropertyWithIntegerValue = StateNotifier<int>();

void someFunctionChangeValue() {
  // do something, get new value
  // ...............................................................
  final newValue = 10;
  // and then change value of property
  _somePropertyWithIntegerValue.accept(10);
}
```

### EntityStateNotifier

Variant of StateNotifier that uses a special EntityState object as the state value. EntityState has three states:
content, loading, error.

```dart

final _countryListState = EntityStateNotifier<Iterable<Country>>();

Future<void> _loadCountryList() async {
  final previousData = _countryListState.value?.data;

  // set property to loading state and use previous data for this state
  _countryListState.loading(previousData);

  try {
    // await the result
    final res = await model.loadCountries();
    // set property to content state, use new data
    _countryListState.content(res);
  } on Exception catch (e) {
    // set property to error state
    _countryListState.error(e, previousData);
  }
}
```

### StateNotifierBuilder

The StateNotifierBuilder is a widget that uses a StateNotifier as its data source. A builder function of the
StateNotifierBuilder must return the widget based on the current value passed.

```dart
void somewhereInTheBuildFunction() {
  // ......
  StateNotifierBuilder<String>(
    listenableState: someListenableState,
    builder: (ctx, value) {
      return Text(value);
    },
  );
  // ......
}
```

### EntityStateNotifierBuilder

The EntityStateNotifierBuilder is a widget that uses a EntityStateNotifier as its data source.
Depending on the state, different builders will be called. It will be errorBuilder for error, loadingBuilder for error,
builder for content.

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

### DoubleSourceBuilder
One of the multi-sources builders. It uses two ListenableStates as sources of data.
The builder function will be called when any of the ListenableStates changes.

```dart
void somewhereInTheBuildFunction() {
  // ......
  DoubleSourceBuilder<String, TextStyle>(
    firstSource: captionListenableState,
    secondSource: captionStyleListenableState,
    builder: (ctx, value, style) {
      return Text(value, style: style);
    },
  );
  // ......
}
```

### TripleSourceBuilder
One of the multi-sources builders. It uses three ListenableStates as sources of data.
The builder function will be called when any of the ListenableStates changes.

```dart
void somewhereInTheBuildFunction() {
  // ......
  TripleSourceBuilder<String, int, TextStyle>(
    firstSource: captionListenableState,
    secondSource: valueListenableState,
    thirdSource: captionStyleListenableState,
    builder: (ctx, title, value, style) {
      return Text('$title: ${value ?? 0}', style: style);
    },
  );
  // ......
}
```

### MultiListenerRebuilder
Widget that rebuild part of the ui when one of Listenable changes. The builder function in this widget has no values,
and you need to get the values directly in function's body.

```dart
void somewhereInTheBuildFunction() {
  // ......
  MultiListenerRebuilder(
    listenableList: [
      firstListenable,
      secondListenable,
      thirdListenable,
    ],
    builder: (ctx) {
      final title = firstListenable.value;
      final value = secondListenable.value;
      final style = thirdListenable.value;
      return Text('$title: ${value ?? 0}', style: style);
    },
  );
  // ......
}
```

## Sponsor

Our main sponsor is Surf.

[![Surf](https://www.unitag.io/qreator/generate?crs=Ppv8rOENN3V1lAwTz82zPh3poO83%252FIJ9nI4lZ2WxB1%252Fx3unhClolT%252BfiswBVKCVk1x3KwnAKl2ZTjeIIFqrIs2Ti1AJPN2Spxg9ZI%252FduGACdpoSZ1XsLvOiNDpnlRoYqCtohJbiQ%252BeMa%252FF486MqoBmEVjX4tLzcVHE110k91WLVB%252BJW2EdP%252FC1AYCJTmAlMUSRlena4BL4BTE%252FM5rIQSUqF4eGrMLidJJGqn0sw%252FE8MV%252FgM0jxx0W%252F9TVu6aTtldB1XmPTRzKVOYzGsjtS1ttyqc86GGAAPO0tDSuIN8miKLMx3lHUQxlq0VZja%252BKc38&crd=fhOysE0g3Bah%252BuqXA7NPQ87MoHrnzb%252BauJLKoOEbJsrR3AQ739RervHWwiCPWTKUQ9Ge59qWyRtf02%252FbBOp96w%253D%253D)](https://surf.ru/)

## Maintainer

[Mikhail Zotyev](https://github.com/MbIXjkee)
