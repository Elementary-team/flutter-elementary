import 'package:profile/features/profile/domain/mock_list_cities.dart';
import 'package:profile/features/profile/domain/mock_list_interests.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Class that emulates the work of a real server.
/// Admit the convention that the server returns not DTO but a business model.
class MockServer {
  /// Users profile.
  Profile? _profile;

  /// Returns profile or null.
  Future<Profile> getProfile() {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (_profile == null) {
          return const Profile();
        } else {
          return _profile!;
        }
      },
    );
  }

  /// Saves completed profile.
  // ignore: use_setters_to_change_properties
  Future<void> saveProfile(Profile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _profile = profile;
  }

  /// Emits a return from the server of the list with cities.
  List<String> getMockListCities(String enteredValue) {
    return mockCitiesServerList
        .where(
          (element) => element.toLowerCase().contains(
                enteredValue.toLowerCase(),
              ),
        )
        .toList();
  }

  /// Returns the mock value of the city at the coordinates selected on the map.
  String getMockCityByCoordinates(Point coordinates) {
    return 'Some city by coordinates: latitude - ${coordinates.latitude}, longitude - ${coordinates.longitude}.';
  }

  /// Emits a return from the server of the list with interests.
  List<String> getMockListInterests() {
    return mockInterestsList;
  }
}
