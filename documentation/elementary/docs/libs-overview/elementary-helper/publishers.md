## StateNotifier

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

## EntityStateNotifier

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
