import 'package:profile/features/profile/domain/mock_list_cities.dart';
import 'package:profile/features/profile/domain/profile.dart';

/// Class that emulates the work of a real server.
/// Admit the convention that the server returns not DTO but a business model.
class MockServer {
  /// Users profile.
  Profile _profile = const Profile();

  /// Returns profile or null.
  Profile getProfile() {
    return _profile;
  }

  /// Saves completed profile.
  // ignore: use_setters_to_change_properties
  void saveProfile(Profile profile) {
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
}
