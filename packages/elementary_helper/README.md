# Elementary-helper

<div style="text-align: center;">
    <img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo" style="margin:50px 0px">
</div>

<div style="text-align: center;">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://img.shields.io/pub/v/elementary_helper?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://app.codecov.io/gh/Elementary-team/flutter-elementary"><img src="https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary_helper&logo=codecov&logoColor=white" alt="Coverage Status"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/points/elementary_helper" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/likes/elementary_helper" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary_helper"><img src="https://badgen.net/pub/popularity/elementary_helper" alt="Pub popularity"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"><img src="https://badgen.net/github/contributors/Elementary-team/flutter-elementary" alt="Contributors"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/blob/main/LICENSE"><img src="https://badgen.net/github/license/Elementary-team/flutter-elementary" alt="License"></a>
</div>

## Description

To make Elementary easier to use, some helpers have been added. Among them are custom implementations of
the Pub-Sub pattern and wrappers to make easier testable interaction with Flutter from Widget Model

### StateNotifier

Behaviour is similar to ValueNotifier, but with no requirement to set initial value.
Due to this the returned value is Nullable. StateNotifier's subscribers are notified whenever a state change occurs.
Also, the subscriber is called first time at the moment of subscription. For emit new value there is a method accept.

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

Variant of ValueNotifier that uses a special EntityState object as the state value. EntityState has three states:
content, loading, error. All states can contain data, for cases when you want to keep previous values, e.g. pagination.

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
Depending on the state, different builders are called: errorBuilder for error, loadingBuilder for error,
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
The builder function is called when any of sources changes.

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
One of the multi-sources builders. It uses two ValueListenable as sources of data.
The builder function is called when any of sources changes.

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
One of the multi-sources builders. It uses three ListenableStates as sources of data.
The builder function is called when any of sources changes.

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
One of the multi-sources builders. It uses three ValueListenable as sources of data.
The builder function is called when any of sources changes.

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

## Maintainer

<a href="https://github.com/MbIXjkee">
    <div style="display: inline-block;">
        <img src="https://avatars.githubusercontent.com/u/14325911?v=4" height="64" width="64" style="border-radius: 50%" alt="Maintainer avatar">
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
