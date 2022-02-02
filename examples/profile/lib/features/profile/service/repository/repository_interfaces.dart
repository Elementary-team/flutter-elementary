import 'package:profile/features/profile/domain/profile.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Repository interface for working with profile.
abstract class IProfileRepository {
  /// Return user profile.
  Future<Profile> getProfile();

  /// Saves completed profile.
  Future<void> saveProfile(Profile profile);
}

/// Repository interface for working with cities.
abstract class ICitiesRepository {
  /// Return list with cities for suggestions.
  Future<List<String>> getListCities(String enteredValue);

  /// Returns the city by coordinates.
  Future<String> getCityByCoordinates(Point coordinates);
}

/// Repository interface for working with interests.
// ignore: one_member_abstracts
abstract class IInterestsRepository {
  /// Return list with interests.
  Future<List<String>> getListInterests();
}