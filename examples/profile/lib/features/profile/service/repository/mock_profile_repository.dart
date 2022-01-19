import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/mock_server/mock_server.dart';

/// Repository for working with a user profile by using [MockServer].
class MockProfileRepository {
  final MockServer _mockServer;

  /// Create an instance [MockProfileRepository].
  const MockProfileRepository(this._mockServer);

  /// Return user profile or null.
  Profile getProfile() {
    return _mockServer.getProfile();
  }

  /// Saves completed profile.
  void saveProfile(Profile profile) {
    _mockServer.saveProfile(profile);
  }
}
