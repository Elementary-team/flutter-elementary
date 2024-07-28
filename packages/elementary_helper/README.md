# Elementary-helper
###
<p align="center">
    <a href="https://documentation.elementaryteam.dev/libs/elementary-helper/intro/"><img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo"></a>
</p>

###

<p align="center">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://img.shields.io/pub/v/elementary_helper?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://app.codecov.io/gh/Elementary-team/flutter-elementary"><img src="https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary_helper&logo=codecov&logoColor=white" alt="Coverage Status"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/points/elementary_helper" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/likes/elementary_helper" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/popularity/elementary_helper" alt="Pub popularity"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"><img src="https://badgen.net/github/contributors/Elementary-team/flutter-elementary" alt="Contributors"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/blob/main/LICENSE"><img src="https://badgen.net/github/license/Elementary-team/flutter-elementary" alt="License"></a>
</p>

## Description

To make Elementary easier to use, some helpers have been added. Among them are custom implementations of the observer pattern and wrappers to facilitate easier and more testable interactions with Flutter from the `WidgetModel`.

### StateNotifier

The behavior is similar to `ValueNotifier` but with no requirement to set an initial value. Due to this, the returned value is nullable. `StateNotifier`'s subscribers are notified whenever a state change occurs. Additionally, the subscriber is called for the first time at the moment of subscription. Use `accept` to emit a new value.

```dart
final _somePropertyWithIntegerValue = StateNotifier<int>();

void someFunctionChangeValue() {
  // do something, get new value
  // ...............................................................
  final newValue = _doSomething();
  // and then change value of property
  _somePropertyWithIntegerValue.accept(newValue);
}
```

### EntityStateNotifier

A variant of `ValueNotifier` that uses a special `EntityState` object as the state value. `EntityState` has three states: `content`, `loading`, and `error`. All states can contain data, for cases when you want to keep previous values, such as pagination.

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

The `StateNotifierBuilder` is a widget that uses a `StateNotifier` as its data source. A builder function of the `StateNotifierBuilder` must return a widget based on the current value passed.

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

The `EntityStateNotifierBuilder` is a widget that uses an `EntityStateNotifier` as its data source. Depending on the state, different builders are called: `errorBuilder` for error, `loadingBuilder` for loading, and `builder` for content.

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
One of the multi-source builders, it uses two `ListenableState` objects as sources of data. The builder function is called whenever any of the sources change.

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

### DoubleValueListenableBuilder
One of the multi-source builders, it uses two `ValueListenable` objects as sources of data. The builder function is called whenever any of the sources change.

```dart
void somewhereInTheBuildFunction() {
  // ......
  DoubleValueListenableBuilder<String, TextStyle>(
    firstValue: captionListenableState,
    secondValue: captionStyleListenableState,
    builder: (ctx, value, style) {
      return Text(value, style: style);
    },
  );
  // ......
}
```

### TripleSourceBuilder
One of the multi-source builders, it uses three `ListenableState` objects as sources of data. The builder function is called whenever any of the sources change.

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

### TripleValueListenableBuilder
One of the multi-source builders, it uses three `ValueListenable` objects as sources of data. The builder function is called whenever any of the sources change.

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
A widget that rebuilds part of the UI when one of the `Listenable` objects changes. The builder function in this widget does not take any values as parameters; you need to get the values directly within the function's body.

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
