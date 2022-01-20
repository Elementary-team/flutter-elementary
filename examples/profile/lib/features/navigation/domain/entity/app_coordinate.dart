import 'package:profile/features/navigation/domain/entity/coordinate.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/full_name_screen/full_name_screen.dart';
import 'package:profile/features/profile/screens/init_screen/init_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';

/// A set of routes for the entire app.
class AppCoordinate implements Coordinate {
  /// Initialization screens([InitScreen]).
  static const initScreen = AppCoordinate._('profile');

  /// Widget screen with base data about user(surname, name,
  /// second name(optional), birthday).
  static const fullNameScreen = AppCoordinate._('base_data');

  /// Widget screen with users place of residence.
  static const placeResidenceScreen = AppCoordinate._('place_residence');

  /// Widget screen with users interests.
  static const interestsScreen = AppCoordinate._('interests_screen');

  /// Widget screen with user info.
  static const aboutMeScreen = AppCoordinate._('about_me');

  /// Initialization screens(it can be any screens).
  static const initial = initScreen;

  final String _value;

  const AppCoordinate._(this._value);

  @override
  String toString() => _value;
}

/// List of main routes of the app.
final Map<AppCoordinate, CoordinateBuilder> appCoordinates = {
  AppCoordinate.initial: (_, __) => const InitScreen(),
  AppCoordinate.fullNameScreen: (_, __) => const FullNameScreen(),
  AppCoordinate.placeResidenceScreen: (_, __) => const PlaceResidenceScreen(),
  AppCoordinate.interestsScreen: (_, __) => const InterestsScreen(),
  AppCoordinate.aboutMeScreen: (_, __) => const AboutMeScreen(),
};
