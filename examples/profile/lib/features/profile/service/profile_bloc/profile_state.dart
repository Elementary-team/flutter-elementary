import 'package:equatable/equatable.dart';
import 'package:profile/features/profile/domain/profile.dart';

/// Base state for profile.
abstract class BaseProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Init state.
class InitProfileState extends BaseProfileState implements ILoadAvailable {}

/// Loading profile state.
class ProfileLoadingState extends BaseProfileState {}

/// Loading error state.
class ErrorProfileLoadingState extends BaseProfileState
    implements ILoadAvailable {}

/// Profile state.
class ProfileState extends BaseProfileState
    implements ILoadAvailable, IEditingAvailable, ICancelAvailable {
  /// User profile from server.
  final Profile profile;

  @override
  List<Object> get props => [profile];

  /// Create an instance [ProfileState].
  ProfileState({required this.profile});
}

/// Pending profile state.
class PendingProfileState extends ProfileState
    implements IEditingAvailable, ICancelAvailable, ISaveAvailable {
  /// Initial profile.
  final Profile initialProfile;

  @override
  List<Object> get props => [initialProfile, profile];

  /// Create an instance [PendingProfileState].
  PendingProfileState({
    required this.initialProfile,
    required Profile profile,
  }) : super(profile: profile);
}

/// Save error state.
class ProfileSaveFailedState extends PendingProfileState {
  /// Create an instance [ProfileSaveFailedState].
  ProfileSaveFailedState({
    required Profile profile,
    required Profile initialProfile,
  }) : super(
          profile: profile,
          initialProfile: initialProfile,
        );
}

/// Profile saved successfully.
class ProfileSavedSuccessfullyState extends ProfileState {
  /// Create an instance [ProfileSavedSuccessfullyState].
  ProfileSavedSuccessfullyState({required Profile profile})
      : super(profile: profile);
}

/// Profile save state.
class SavingProfileState extends PendingProfileState {
  /// Create an instance [SavingProfileState].
  SavingProfileState({
    required Profile profile,
    required Profile initialProfile,
  }) : super(
          profile: profile,
          initialProfile: initialProfile,
        );
}

/// State interface at which editing will be available.
abstract class IEditingAvailable {}

/// State interface at which you can download the profile from the server.
abstract class ILoadAvailable {}

/// State interface at which you can cancel profile editing.
abstract class ICancelAvailable {}

/// State interface at which you can save profile.
abstract class ISaveAvailable {}
