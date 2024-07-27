// ignore_for_file: avoid_catches_without_on_clauses

import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../unit_helper.dart';

/// Tests for [CountryListScreenModel].
void main() {
  late CountryRepositoryMock countryRepositoryMock;
  late ErrorHandlerMock errorHandlerMock;
  late CountryListScreenModel model;

  setUp(() {
    countryRepositoryMock = CountryRepositoryMock();
    errorHandlerMock = ErrorHandlerMock();

    model = CountryListScreenModel(countryRepositoryMock, errorHandlerMock);
  });

  group('CountryListScreenModel', () {
    test('loadCountries should get countries from repository', () async {
      when(() => countryRepositoryMock.loadAllCountries())
          .thenAnswer((invocation) => Future.value([]));

      await model.loadCountries();

      verify(() => countryRepositoryMock.loadAllCountries()).called(1);
    });

    test('loadCountries should transfer exception to handler', () async {
      final error = Exception('test');
      when(() => countryRepositoryMock.loadAllCountries())
          .thenAnswer((invocation) => Future.error(error));

      try {
        await model.loadCountries();
      // ignore: empty_catches
      } catch (e) {}

      verify(() => errorHandlerMock.handleError(error)).called(1);
    });

    test('loadCountries should rethrow exception', () async {
      final error = Exception('test');

      when(() => countryRepositoryMock.loadAllCountries())
          .thenAnswer((invocation) => Future.error(error));

      await expectLater(() async => model.loadCountries(), throwsA(error));
    });
  });
}
