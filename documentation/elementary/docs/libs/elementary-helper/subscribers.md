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
