import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helper.dart';

void main() {
  const widget = CountryListScreen();
  final countries = [
    Country(
      flag: 'test-flag-url',
      name: 'Test country',
    ),
  ];
  late MockCountryListScreenWidgetModel wm;
  late EntityValueListenableMock<List<Country>> countryListStateMock;

  setUpAll(() {
    registerFallbackValue(UriFake());
  });

  setUp(() {
    countryListStateMock = EntityValueListenableMock<List<Country>>();

    wm = MockCountryListScreenWidgetModel();
    when(() => wm.countryListState).thenReturn(countryListStateMock);
  });

  testGoldens('CountryListScreen loading test', (tester) async {
    when(() => countryListStateMock.value).thenReturn(
      EntityState.loading(),
    );

    await tester.pumpWidgetBuilder(
      widget.build(wm),
    );

    // There is a problem with golden_toolkit when widget is animated and
    // doesn't stop.
    // await screenMatchesGolden(tester, 'country_list_screen_loading');
  });

  testGoldens('CountryListScreen error test', (tester) async {
    when(() => countryListStateMock.value).thenReturn(
      EntityState.error(),
    );

    await tester.pumpWidgetBuilder(
      widget.build(wm),
    );

    await screenMatchesGolden(tester, 'country_list_screen_error');
  });

  testGoldens('CountryListScreen content test', (tester) async {
    when(() => countryListStateMock.value).thenReturn(
      EntityState.content(countries),
    );

    await provideMockedNetworkImages(
      () async {
        await tester.pumpWidgetBuilder(
          widget.build(wm),
        );
      },
    );

    await screenMatchesGolden(tester, 'country_list_screen_content');
  });
}

class MockCountryListScreenWidgetModel extends MockWM
    implements ICountryListWidgetModel {}
