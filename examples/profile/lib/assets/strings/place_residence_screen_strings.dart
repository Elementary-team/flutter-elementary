import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';

/// Strings that are needed on the [PlaceResidenceScreen].
class PlaceResidenceScreenStrings {
  /// Title text in appbar in [PlaceResidenceScreen].
  static const placeResidenceTitle = 'Place of residence';

  /// Button text to open the map.
  static const selectCityOnTheMapButton = 'Select a city on the map';

  /// Button text to close the map and not save the result.
  static const cancelButton = 'Cancel';

  /// Button text to close the map and save the result.
  static const readyButton = 'Ready';

  /// Text to display an error when loading a suggestions.
  static const String errorLoading =
      'An error occurred, please try again later';

  /// Text to display city search error.
  static const String cityNotFoundError = 'City not found';
}
