import 'package:equatable/equatable.dart';
import 'package:profile/features/profile/domain/profile.dart';

/// Base state for profile.
abstract class BaseProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Loading state.
class InitProfileState extends BaseProfileState {}

/// Profile state.
class ProfileState extends BaseProfileState {
  /// User profile from server.
  final Profile profile;

  /// Create an instance [ProfileState].
  ProfileState(this.profile);
}

/// Pending profile state.
class PendingProfileState extends ProfileState {

  /// Create an instance [PendingProfileState].
  PendingProfileState({
    required Profile profile,
  }) : super(profile);
}

/// Loading error state.
class ErrorLoadingState extends BaseProfileState {}

/// Save error state.
class ErrorSaveState extends PendingProfileState {
  /// Create an instance [ErrorSaveState].
  ErrorSaveState({
    required Profile profile,
  }) : super(profile: profile);
}
