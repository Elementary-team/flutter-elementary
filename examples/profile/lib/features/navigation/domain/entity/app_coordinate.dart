import 'package:profile/features/navigation/domain/entity/coordinate.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/init_screen/init_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';

/// A set of routes for the entire app.
class AppCoordinates implements Coordinate {
  /// Initialization screens([InitScreen]).
  static const initScreen = AppCoordinates._('profile');

  /// Widget screen with personal data about user(surname, name,
  /// second name(optional), birthday).
  static const personalDataScreen = AppCoordinates._('personal_data');

  /// Widget screen with users place of residence.
  static const placeResidenceScreen = AppCoordinates._('place_residence');

  /// Widget screen with users interests.
  static const interestsScreen = AppCoordinates._('interests_screen');

  /// Widget screen with information about yourself.
  static const aboutMeScreen = AppCoordinates._('about_me');

  final String _value;

  const AppCoordinates._(this._value);

  @override
  String toString() => _value;
}

/// List of main routes of the app.
final Map<AppCoordinates, CoordinateBuilder> appCoordinates = {
  AppCoordinates.initScreen: (_, __) => const InitScreen(),
  AppCoordinates.personalDataScreen: (_, __) => const PersonalDataScreen(),
  AppCoordinates.placeResidenceScreen: (_, __) => const PlaceResidenceScreen(),
  AppCoordinates.interestsScreen: (_, __) => const InterestsScreen(),
  AppCoordinates.aboutMeScreen: (_, __) => const AboutMeScreen(),
};
