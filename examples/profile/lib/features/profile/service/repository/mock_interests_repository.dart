import 'package:profile/features/profile/service/mock_server/mock_server.dart';

/// Repository for working with a users place of residence by using [MockServer].
class MockInterestsRepository {
  final MockServer _mockServer;

  /// Create an instance [MockInterestsRepository].
  const MockInterestsRepository(this._mockServer);

  /// Return list with cities for suggestions from [MockServer].
  List<String> getMockListInterests() {
    return _mockServer.getMockListInterests();
  }
}
