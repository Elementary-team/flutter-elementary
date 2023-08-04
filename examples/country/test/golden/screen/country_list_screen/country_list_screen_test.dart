import 'package:country/domain/country/country.dart';
import 'package:country/res/theme/app_typography.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../golden_helper.dart';

void main() {
  const widget = CountryListScreen();
  final countries = [
    Country(
      flag: 'rf-flag-url',
      name: 'Russian Federation',
    ),
  ];
  late MockCountryListScreenWidgetModel wm;
  late ListenableEntityStateMock<List<Country>> countryListStateMock;

  setUpAll(() {
    registerFallbackValue(UriFake());
  });

  setUp(() {
    wm = MockCountryListScreenWidgetModel();
    countryListStateMock = ListenableEntityStateMock<List<Country>>();

    when(() => wm.countryListState).thenReturn(countryListStateMock);
    when(() => wm.countryNameStyle).thenReturn(AppTypography.title3);
  });

  testGoldens('CountryListScreen loading test', (tester) async {
    when(() => countryListStateMock.value).thenReturn(
      EntityState.loading(),
    );

    await tester.pumpWidgetBuilder(
      widget.build(wm),
    );

    await screenMatchesGolden(tester, 'country_list_screen_loading');
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
