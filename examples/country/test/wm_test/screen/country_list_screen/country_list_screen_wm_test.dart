// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_model.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_widget_model.dart';
import 'package:country/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Тесты для [CountryListScreenWidgetModel]
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
}

class _MockCountryListScreenModel extends Mock
    with MockElementaryModelMixin
    implements CountryListScreenModel {}

class _MockScaffoldMessengerWrapper extends Mock
    implements ScaffoldMessengerWrapper {}
