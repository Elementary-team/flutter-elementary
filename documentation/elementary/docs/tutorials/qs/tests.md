
Add tests for your implementation. Let's look at an example of how this can be done. As a sample we'll use impementation of ElementaryModel, WidgetModel and ElementaryWidget that were provided in 'Implementation' section.

## ElementaryModel

For testing this layer, you need to add unit tests. 

A few scenarios should be tested: repository was used to load data, and handling error during the loading.

``` dart

void main() {
  late CountryRepositoryMock countryRepositoryMock;
  late CountryListScreenModel model;

  setUp(() {
    countryRepositoryMock = CountryRepositoryMock();
    model = CountryListScreenModel(countryRepositoryMock);
  });

  group('CountryListScreenModel', () {
    test('loadCountries should get countries from repository', () async {
      when(() => countryRepositoryMock.loadAllCountries())
          .thenAnswer((invocation) => Future.value([]));

      await model.loadCountries();

      verify(() => countryRepositoryMock.loadAllCountries()).called(1);
    });

    test('loadCountries should rethrow exception', () async {
      final error = Exception('test');

      when(() => countryRepositoryMock.loadAllCountries())
          .thenAnswer((invocation) => Future.error(error));

      await expectLater(() async => model.loadCountries(), throwsA(error));
    });
  });
}

```

## WidgetModel

For testing this layer, you need to use elementary_test package. We need to test loading process with various conditions, such as in-progress, error, and successful getting result. Also we need to test, showing a snack bar from the context of the WidgetModel.

```dart
void main() {
  late _MockCountryListScreenModel model;
  late _MockScaffoldMessengerWrapper scaffoldMessengerWrapper;
  late CountryListScreenWidgetModel wm;

  setUp(() async {
    model = _MockCountryListScreenModel();
    scaffoldMessengerWrapper = _MockScaffoldMessengerWrapper();
    wm = CountryListScreenWidgetModel(model, scaffoldMessengerWrapper);
  });

  tearDown(() {
    return wm.dispose();
  });

  CountryListScreenWidgetModel setUpWm() {
    return wm;
  }

  group('CountryListScreenWidgetModel', () {
    testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
      'countryListState should be in loading after initialization',
      setUpWm,
      (wm, tester, context) async {
        final completer = Completer<List<Country>>();
        when(() => model.loadCountries()).thenAnswer((_) => completer.future);

        tester.init();

        expect(wm.countryListState.value.isLoadingState, true);
      },
    );

    testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
      'countryListState should be in error if loading failed',
      setUpWm,
      (wm, tester, context) async {
        final testException = Exception('test error');
        when(() => model.loadCountries()).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 1),
            () => throw testException,
          ),
        );

        tester.init();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(wm.countryListState.value.isErrorState, true);
        expect(wm.countryListState.value.errorOrNull, testException);
      },
    );

    testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
      'countryListState should provide loaded data',
      setUpWm,
      (wm, tester, context) async {
        final country = Country(name: 'test', flag: 'test');
        when(() => model.loadCountries()).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 1),
            () => [country],
          ),
        );

        tester.init();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(wm.countryListState.value.isLoadingState, false);
        expect(wm.countryListState.value.isErrorState, false);
        final providedData = wm.countryListState.value.data;
        expect(providedData, isNotNull);
        expect(providedData!.contains(country), true);
      },
    );

    testWidgetModel<CountryListScreenWidgetModel, CountryListScreen>(
      'should show snack when connection troubles',
      setUpWm,
      (wm, tester, context) async {
        when(() => model.loadCountries()).thenAnswer((_) => Future.value([]));
        when(() => scaffoldMessengerWrapper.showSnackBar(context, any()))
            .thenReturn(null);

        tester.init();
        wm.onErrorHandle(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        verify(
          () => scaffoldMessengerWrapper.showSnackBar(
              context, 'Connection troubles'),
        );
      },
    );
  });
}
```

## ElementaryWidget

For testing this layer, you can use widget or golden tests. Both ways are pretty similar, we'll demonstrate only widget tests. Since the ElementaryWidget just describes its subtree using other widgets, the simplest way is to test the result of build method, providing a mock widget model to it. You can also test the insertion of the widget itself into the tree, in which case specify a function in the wmFactory parameter that returns a mock of the widget model.

For the widget we need to test possible states a user can see: loading, error, an empty content and a content with data.

```dart

void main() {
  const widget = CountryListScreen();
  final wrapper = materialAppWrapper();
  final countries = [
    Country(
      flag: 'test-flag-url',
      name: 'Test country',
    ),
  ];
  late MockCountryListScreenWidgetModel wm;
  late EntityValueListenableMock<List<Country>> countryListStateMock;

  setUp(() {
    countryListStateMock = EntityValueListenableMock<List<Country>>();

    wm = MockCountryListScreenWidgetModel();
    when(() => wm.countryListState).thenReturn(countryListStateMock);
  });

  group('CountryListScreen', () {
    testWidgets(
      'should show CircularProgressIndicator while loading',
      (tester) async {
        when(() => countryListStateMock.value).thenReturn(
          EntityState.loading(),
        );

        await tester.pumpWidget(
          wrapper(widget.build(wm)),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'should show error message when error',
      (tester) async {
        when(() => countryListStateMock.value).thenReturn(
          EntityState.error(),
        );

        await tester.pumpWidget(
          wrapper(widget.build(wm)),
        );

        expect(find.text('Something went wrong'), findsOneWidget);
      },
    );

    testWidgets(
      'should show message when it is loaded empty',
      (tester) async {
        when(() => countryListStateMock.value).thenReturn(
          EntityState.content(),
        );

        await tester.pumpWidget(
          wrapper(widget.build(wm)),
        );

        expect(find.text('No countries fetched'), findsOneWidget);
      },
    );

    testWidgets(
      'should show content when it is loaded',
      (tester) async {
        when(() => countryListStateMock.value).thenReturn(
          EntityState.content(countries),
        );

        await tester.pumpWidget(
          wrapper(widget.build(wm)),
        );

        expect(find.text('Test country'), findsOneWidget);
      },
    );
  });
}
```