import 'package:profile/features/server/mock_server/mock_server.dart';

/// Repository interface for working with interests.
// ignore: one_member_abstracts
abstract class IInterestsRepository {
  /// Return list with interests.
  Future<List<String>> getListInterests();
}

/// Repository for working with a users place of residence by using [MockServer].
class MockInterestsRepository implements IInterestsRepository {
  final MockServer _mockServer;

  /// Create an instance [MockInterestsRepository].
  const MockInterestsRepository(this._mockServer);

  @override
  Future<List<String>> getListInterests() {
    return _mockServer.getMockListInterests();
  }
}
