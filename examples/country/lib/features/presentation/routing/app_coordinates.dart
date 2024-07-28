import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:flutter/material.dart';

/// Builder for a navigation place
typedef CoordinateBuilder = Widget Function(
  BuildContext? context,
  Object? data,
);

/// Describes a destination in the app.
class AppCoordinate {
  static const countryList = AppCoordinate._('countryListScreen');
  static const initial = countryList;

  final String value;

  const AppCoordinate._(this.value);
}

final Map<AppCoordinate, CoordinateBuilder> appCoordinates = {
  AppCoordinate.countryList: (_, __) => const CountryListScreen(),
};
