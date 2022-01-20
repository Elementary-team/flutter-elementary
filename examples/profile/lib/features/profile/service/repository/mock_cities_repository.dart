import 'package:profile/features/profile/service/mock_server/mock_server.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Repository for working with a users place of residence by using [MockServer].
class MockCitiesRepository {
  final MockServer _mockServer;

  /// Create an instance [MockCitiesRepository].
  const MockCitiesRepository(this._mockServer);

  /// Return list with cities for suggestions from [MockServer].
  List<String> getMockListCities(String enteredValue) {
    return _mockServer.getMockListCities(enteredValue);
  }

  /// Returns the mock value of the city at the coordinates selected on the map.
  String getMockCityByCoordinates(Point coordinates) {
    return _mockServer.getMockCityByCoordinates(coordinates);
  }
}
