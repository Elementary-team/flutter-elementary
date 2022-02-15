import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/server/domain/mock_list_cities.dart';
import 'package:profile/features/server/domain/mock_list_interests.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

const _duration = Duration(milliseconds: 300);

/// Class that emulates the work of a real server.
/// Admit the convention that the server returns not DTO but a business model.
class MockServer {
  /// Users profile.
  Profile? _profile;

  /// Returns profile or null.
  Future<Profile> getProfile() {
    return Future.delayed(
      _duration,
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
    await Future<void>.delayed(_duration);
    _profile = profile;
  }

  /// Emits a return from the server of the list with cities.
  Future<List<String>> getMockListCities(String enteredValue) async {
    return Future.delayed(
      _duration,
      () {
        return mockCitiesServerList
            .where(
              (element) => element.toLowerCase().contains(
                    enteredValue.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  /// Returns the mock value of the city at the coordinates selected on the map.
  Future<String> getMockCityByCoordinates(Point coordinates) async {
    return Future.delayed(
      _duration,
      () {
        return 'Some city by coordinates: latitude - ${coordinates.latitude}, longitude - ${coordinates.longitude}.';
      },
    );
  }

  /// Emits a return from the server of the list with interests.
  Future<List<String>> getMockListInterests() {
    return Future.delayed(
      _duration,
      () {
        return mockInterestsList;
      },
    );
  }
}
