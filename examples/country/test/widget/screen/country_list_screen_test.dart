import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helper.dart';

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

class MockCountryListScreenWidgetModel extends MockWM
    implements ICountryListWidgetModel {}
