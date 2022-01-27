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

  @override
  List<Object> get props => [profile];

  /// Create an instance [ProfileState].
  ProfileState(this.profile);
}

/// Pending profile state.
class PendingProfileState extends ProfileState {
  /// Initial profile.
  final Profile initialProfile;

  @override
  List<Object> get props => [initialProfile, profile];

  /// Create an instance [PendingProfileState].
  PendingProfileState({
    required this.initialProfile,
    required Profile profile,
  }) : super(profile);
}

/// Loading error state.
class ErrorLoadingState extends BaseProfileState {}

/// Save error state.
class ErrorSaveState extends BaseProfileState {
  /// Create an instance [ErrorSaveState].
  ErrorSaveState();
}

/// Profile saved successfully.
class ProfileSavedSuccessfullyState extends BaseProfileState {
  /// Saved profile;
  final Profile profile;

  /// Create an instance [ProfileSavedSuccessfullyState].
  ProfileSavedSuccessfullyState(this.profile);
}

/// Profile save state.
class SavingProfileState extends BaseProfileState {}
