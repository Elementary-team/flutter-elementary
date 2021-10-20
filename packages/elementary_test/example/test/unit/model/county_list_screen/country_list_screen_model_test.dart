// ignore_for_file: avoid_catches_without_on_clauses

import 'package:country/ui/screen/country_list_screen/country_list_screen_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../unit_helper.dart';

/// Тесты для [CountryListScreenModel]
void main() {
  late CountryRepositoryMock countryRepositoryMock;
  late ErrorHandlerMock errorHandlerMock;
  late CountryListScreenModel model;

  setUp(() {
    countryRepositoryMock = CountryRepositoryMock();
    errorHandlerMock = ErrorHandlerMock();

    model = CountryListScreenModel(countryRepositoryMock, errorHandlerMock);
  });

  test('loadCountries should get countries from repository', () {
    when(() => countryRepositoryMock.getAllCountries())
        .thenAnswer((invocation) => Future.value([]));

    model.loadCountries();

    verify(() => countryRepositoryMock.getAllCountries()).called(1);
  });

  test('loadCountries should transfer exception to handler', () async {
    final error = Exception('test');
    when(() => countryRepositoryMock.getAllCountries())
        .thenAnswer((invocation) => Future.error(error));

    try {
      await model.loadCountries();
    } catch (_) {}

    verify(() => errorHandlerMock.handleError(error)).called(1);
  });

  test('loadCountries should rethrow exception', () {
    final error = Exception('test');

    when(() => countryRepositoryMock.getAllCountries())
        .thenAnswer((invocation) => Future.error(error));

    expect(() => model.loadCountries(), throwsA(error));
  });
}
