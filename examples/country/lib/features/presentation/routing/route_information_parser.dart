import 'package:country/features/presentation/routing/app_coordinates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A delegate that is used by the [Router] widget to parse a route information
/// into an application navigation configuration.
class CountryRouteInformationParser
    extends RouteInformationParser<AppCoordinate> {
  @override
  Future<AppCoordinate> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    // Should be adjusted if need parse outside navigation request
    return SynchronousFuture(AppCoordinate.initial);
  }
}
