import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/mock_profile_repository.dart';

/// Bloc for working with profile states.
class ProfileBloc extends Bloc<BaseProfileEvent, BaseProfileState> {
  final IProfileRepository _profileRepository;

  /// Create an instance [ProfileBloc].
  ProfileBloc(
    this._profileRepository,
  ) : super(InitProfileState()) {
    on<ProfileLoadEvent>(_loadProfile);
    on<UpdatePersonalDataEvent>(_updateData);
    on<UpdatePlaceResidenceEvent>(_updateData);
    on<UpdateInterestsEvent>(_updateData);
    on<UpdateAboutMeInfoEvent>(_updateData);
    on<SaveProfileEvent>(_saveProfile);
    on<CancelEditingEvent>(_cancelEditing);
  }

  FutureOr<void> _loadProfile(
    ProfileLoadEvent event,
    Emitter<BaseProfileState> emit,
  ) async {
    final state = this.state;
    if (state is ILoadAvailable) {
      emit(ProfileLoadingState());
      try {
        final profile = await _profileRepository.getProfile();
        emit(ProfileState(profile));
      } on Exception catch (_) {
        emit(ErrorProfileLoadingState());
      }
    }
  }

  void _updateData(
    ProfileUpdateEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is IEditingAvailable) {
      final currentState = state as IEditingAvailable;
      final currentProfile = currentState.profile;
      final updatedProfile = _getUpdatedProfile(event, currentProfile);
      if (state is ProfileState) {
        if (!currentProfile.isSame(updatedProfile)) {
          emit(
            PendingProfileState(
              initialProfile: currentProfile,
              profile: updatedProfile,
            ),
          );
        }
      } else if (state is PendingProfileState) {
        final initialProfile = (state as PendingProfileState).initialProfile;
        if (initialProfile.isSame(updatedProfile)) {
          emit(
            ProfileState(initialProfile),
          );
        } else {
          emit(
            PendingProfileState(
              initialProfile: initialProfile,
              profile: updatedProfile,
            ),
          );
        }
      } else {
        throw UnimplementedError();
      }
    }
  }

  Profile _getUpdatedProfile(
    ProfileUpdateEvent event,
    Profile profile,
  ) {
    switch (event.runtimeType) {
      case UpdatePersonalDataEvent:
        return _updatePersonalData(event, profile);
      case UpdatePlaceResidenceEvent:
        return _updatePlaceResidence(event, profile);
      case UpdateInterestsEvent:
        return _saveListInterests(event, profile);
      case UpdateAboutMeInfoEvent:
        return _updateAboutMe(event, profile);
      default:
        throw UnimplementedError();
    }
  }

  Profile _updatePersonalData(
    ProfileUpdateEvent event,
    Profile profile,
  ) {
    return profile.copyWith(
      surname: event.surname ?? profile.surname,
      name: event.name ?? profile.name,
      secondName: event.secondName ?? profile.secondName,
      birthday: event.birthday ?? profile.birthday,
    );
  }

  Profile _updatePlaceResidence(
    ProfileUpdateEvent event,
    Profile profile,
  ) {
    return profile.copyWith(
      placeOfResidence: event.placeResidence ?? profile.placeOfResidence,
    );
  }

  Profile _saveListInterests(
    ProfileUpdateEvent event,
    Profile profile,
  ) {
    return profile.copyWith(interests: event.interests ?? profile.interests);
  }

  Profile _updateAboutMe(
    ProfileUpdateEvent event,
    Profile profile,
  ) {
    return profile.copyWith(aboutMe: event.aboutMe ?? profile.aboutMe);
  }

  void _cancelEditing(
    CancelEditingEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is ICancelAvailable) {
      final currentState = state as PendingProfileState;
      emit(ProfileState(currentState.initialProfile));
    }
  }

  FutureOr<void> _saveProfile(
    SaveProfileEvent event,
    Emitter<BaseProfileState> emit,
  ) async {
    if (state is ISaveAvailable) {
      final currentState = state as ISaveAvailable;
      try {
        emit(
          SavingProfileState(
            profile: currentState.profile,
            initialProfile: currentState.initialProfile,
          ),
        );
        await _profileRepository.saveProfile(currentState.profile);
        emit(ProfileSavedSuccessfullyState(profile: currentState.profile));
        emit(ProfileState(currentState.profile));
      } on Exception catch (_) {
        emit(
          ProfileSaveFailedState(
            profile: currentState.profile,
            initialProfile: currentState.initialProfile,
          ),
        );
      }
    }
  }
}
