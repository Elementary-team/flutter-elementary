import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/server/mock_server/mock_server.dart';

/// Repository interface for working with profile.
abstract class IProfileRepository {
  /// Return user profile.
  Future<Profile> getProfile();

  /// Saves completed profile.
  Future<void> saveProfile(Profile profile);
}

/// Repository for working with a user profile by using [MockServer].
class MockProfileRepository implements IProfileRepository {
  final MockServer _mockServer;

  /// Create an instance [MockProfileRepository].
  const MockProfileRepository(this._mockServer);

  @override
  Future<Profile> getProfile() async {
    final profile = await _mockServer.getProfile();
    return profile;
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    return _mockServer.saveProfile(profile);
  }
}
