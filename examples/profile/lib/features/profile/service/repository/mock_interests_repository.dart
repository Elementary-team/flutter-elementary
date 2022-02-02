import 'package:profile/features/profile/service/repository/repository_interfaces.dart';
import 'package:profile/features/server/mock_server/mock_server.dart';

/// Repository for working with a users place of residence by using [MockServer].
class MockInterestsRepository implements IInterestsRepository {
  final MockServer _mockServer;

  /// Create an instance [MockInterestsRepository].
  const MockInterestsRepository(this._mockServer);

  /// Return list with interests from [MockServer].
  @override
  Future<List<String>> getListInterests() {
    return _mockServer.getMockListInterests();
  }
}
