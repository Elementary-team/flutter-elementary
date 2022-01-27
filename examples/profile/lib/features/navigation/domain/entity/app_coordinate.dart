import 'package:profile/features/navigation/domain/entity/coordinate.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/init_screen/init_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';

/// A set of routes for the entire app.
class AppCoordinate implements Coordinate {
  /// Initialization screens([InitScreen]).
  static const initScreen = AppCoordinate._('profile');

  /// Widget screen with personal data about user(surname, name,
  /// patronymic(optional), birthday).
  static const personalDataScreen = AppCoordinate._('personal_data');

  /// Widget screen with users place of residence.
  static const placeResidenceScreen = AppCoordinate._('place_residence');

  /// Widget screen with users interests.
  static const interestsScreen = AppCoordinate._('interests_screen');

  /// Widget screen with information about yourself.
  static const aboutMeScreen = AppCoordinate._('about_me');

  final String _value;

  const AppCoordinate._(this._value);

  @override
  String toString() => _value;
}

/// List of main routes of the app.
final Map<AppCoordinate, CoordinateBuilder> appCoordinates = {
  AppCoordinate.initScreen: (_, __) => const InitScreen(),
  AppCoordinate.personalDataScreen: (_, __) => const PersonalDataScreen(),
  AppCoordinate.placeResidenceScreen: (_, __) => const PlaceResidenceScreen(),
  AppCoordinate.interestsScreen: (_, __) => const InterestsScreen(),
  AppCoordinate.aboutMeScreen: (_, __) => const AboutMeScreen(),
};
