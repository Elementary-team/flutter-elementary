
Add tests for your implementation. Let's look at an example of how this can be done.

## Model

For testing this layer, you need to add unit tests. We'll take as a reference a simple model, that fetch data using a repository directly.

``` dart

class CountryListScreenModel extends ElementaryModel {
  final ICountryRepository _countryRepository;

  CountryListScreenModel(
    this._countryRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  Future<List<Country>> loadCountries() async {
    try {
      final res = await _countryRepository.loadAllCountries();
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}

```
For this case we can check a few scenarios: repository was used to load data, and handling error during the loading.

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

## Widget Model

For testing this layer, you need to use elementary_test package.





Write widget test, golden tests for ElementaryWidget.

TODO: more details, examples.