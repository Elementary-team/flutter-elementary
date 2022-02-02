import 'package:profile/features/profile/service/repository/repository_interfaces.dart';
import 'package:profile/features/server/mock_server/mock_server.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Repository for working with a users place of residence by using [MockServer].
class MockCitiesRepository implements ICitiesRepository{
  final MockServer _mockServer;

  /// Create an instance [MockCitiesRepository].
  const MockCitiesRepository(this._mockServer);

  /// Return list with cities for suggestions from [MockServer].
  @override
  Future<List<String>> getListCities(String enteredValue) async {
    return _mockServer.getMockListCities(enteredValue);
  }

  @override
  Future<String> getCityByCoordinates(Point coordinates) {
    return _mockServer.getMockCityByCoordinates(coordinates);
  }
}
