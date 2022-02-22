import 'package:equatable/equatable.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';

/// Base state for profile.
abstract class BaseProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Base state containing profile.
abstract class ProfileContentState extends BaseProfileState {
  /// Current profile.
  final Profile profile;

  @override
  List<Object> get props => [profile];

  /// Create an instance [ProfileState].
  ProfileContentState({required this.profile});
}

/// Base state is pending, containing the profile and initial profile.
abstract class ProfileContentWithInitialState extends ProfileContentState {
  /// Initial profile.
  final Profile initialProfile;

  @override
  List<Object> get props => [initialProfile, profile];

  /// Create an instance [PendingProfileState].
  ProfileContentWithInitialState({
    required Profile profile,
    required this.initialProfile,
  }) : super(profile: profile);
}

/// Init state.
class InitProfileState extends BaseProfileState implements ILoadAvailable {}

/// Loading profile state.
class ProfileLoadingState extends BaseProfileState {}

/// Loading error state.
class ErrorProfileLoadingState extends BaseProfileState
    implements ILoadAvailable {}

/// Profile state.
class ProfileState extends ProfileContentState
    implements ILoadAvailable, IEditingAvailable {
  /// Create an instance [ProfileState].
  ProfileState(Profile profile) : super(profile: profile);
}

/// Pending profile state.
class PendingProfileState extends ProfileContentWithInitialState
    implements IEditingAvailable, ICancelAvailable, ISaveAvailable {
  /// Create an instance [PendingProfileState].
  PendingProfileState({
    required Profile profile,
    required Profile initialProfile,
  }) : super(
          profile: profile,
          initialProfile: initialProfile,
        );
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
class ProfileSavedSuccessfullyState extends ProfileContentState {
  /// Create an instance [ProfileSavedSuccessfullyState].
  ProfileSavedSuccessfullyState({required Profile profile})
      : super(profile: profile);
}

/// Profile save state.
class SavingProfileState extends ProfileContentWithInitialState {
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
/// In this state, the [ProfileUpdateEvent] is applied.
abstract class IEditingAvailable {
  /// Current profile.
  Profile get profile;
}

/// State interface at which you can download the profile from the server.
/// In this state, the [ProfileLoadEvent] is applied.
abstract class ILoadAvailable {}

/// State interface at which you can cancel profile editing.
/// In this state, the [CancelEditingEvent] is applied.
abstract class ICancelAvailable {}

/// State interface at which you can save profile.
/// In this state, the [SaveProfileEvent] is applied.
abstract class ISaveAvailable {
  /// Initial profile.
  Profile get initialProfile;

  /// Current profile.
  Profile get profile;
}
