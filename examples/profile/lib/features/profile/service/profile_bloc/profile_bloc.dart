import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/repository_interfaces.dart';

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
      Profile? profile;
      try {
        profile = await _profileRepository.getProfile();
        emit(ProfileState(profile: profile));
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
      if (state is PendingProfileState) {
        if(event is UpdatePersonalDataEvent) {
          _updatePersonalData(event, emit);
        } else if(event is UpdatePlaceResidenceEvent) {
          _savePlaceResidence(event, emit);
        } else if(event is UpdateInterestsEvent) {
          _saveListInterests(event, emit);
        } else if(event is UpdateAboutMeInfoEvent) {
          _updateAboutMe(event, emit);
        }
      }
    }
  }

  void _updatePersonalData(
    UpdatePersonalDataEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      final currentProfile = currentState.profile;
      if (event.surname != currentProfile.surname ||
          event.name != currentProfile.name ||
          event.patronymic != currentProfile.patronymic ||
          event.birthday != currentProfile.birthday) {
        final updatedProfile = currentProfile.copyWith(
          surname: event.surname ?? currentProfile.surname,
          name: event.name ?? currentProfile.name,
          patronymic: event.patronymic ?? currentProfile.patronymic,
          birthday: event.birthday ?? currentProfile.birthday,
        );
        emit(
          PendingProfileState(
            initialProfile: currentState.initialProfile,
            profile: updatedProfile,
          ),
        );
      }
    } else if (state is ProfileState) {
      final currentState = state as ProfileState;
      final currentProfile = currentState.profile;
      if (event.surname != currentProfile.surname ||
          event.name != currentProfile.name ||
          event.patronymic != currentProfile.patronymic ||
          event.birthday != currentProfile.birthday) {
        final updateProfile = currentProfile.copyWith(
          surname: event.surname ?? currentProfile.surname,
          name: event.name ?? currentProfile.name,
          patronymic: event.patronymic ?? currentProfile.patronymic,
          birthday: event.birthday ?? currentProfile.birthday,
        );
        emit(
          PendingProfileState(
            initialProfile: currentProfile,
            profile: updateProfile,
          ),
        );
      }
    }
  }

  void _savePlaceResidence(
    UpdatePlaceResidenceEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      final currentProfile = currentState.profile;
      if (event.placeResidence != currentProfile.placeOfResidence) {
        final updatedProfile =
            currentProfile.copyWith(placeOfResidence: event.placeResidence);
        emit(
          PendingProfileState(
            initialProfile: currentState.initialProfile,
            profile: updatedProfile,
          ),
        );
      }
    } else if (state is ProfileState) {
      final currentState = state as ProfileState;
      final currentProfile = currentState.profile;
      if (event.placeResidence != currentProfile.placeOfResidence) {
        final updateProfile =
            currentProfile.copyWith(placeOfResidence: event.placeResidence);
        emit(
          PendingProfileState(
            initialProfile: currentProfile,
            profile: updateProfile,
          ),
        );
      }
    }
  }

  void _saveListInterests(
    UpdateInterestsEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      final currentProfile = currentState.profile;
      if (event.interests != currentProfile.interests) {
        final updatedProfile =
            currentProfile.copyWith(interests: event.interests);
        emit(
          PendingProfileState(
            initialProfile: currentState.initialProfile,
            profile: updatedProfile,
          ),
        );
      }
    } else if (state is ProfileState) {
      final currentState = state as ProfileState;
      final currentProfile = currentState.profile;
      if (event.interests != currentProfile.interests) {
        final updateProfile =
            currentProfile.copyWith(interests: event.interests);
        emit(
          PendingProfileState(
            initialProfile: currentProfile,
            profile: updateProfile,
          ),
        );
      }
    }
  }

  void _updateAboutMe(
    UpdateAboutMeInfoEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      var currentState = state as PendingProfileState;
      var currentProfile = currentState.profile;
      if (event.aboutMe != currentProfile.aboutMe) {
        final updatedProfile = currentProfile.copyWith(aboutMe: event.aboutMe);
        emit(
          PendingProfileState(
            initialProfile: currentState.initialProfile,
            profile: updatedProfile,
          ),
        );
      }
      currentState = state as PendingProfileState;
      currentProfile = currentState.profile;
      add(SaveProfileEvent(currentProfile));
    } else if (state is ProfileState) {
      var currentState = state as ProfileState;
      var currentProfile = currentState.profile;
      if (event.aboutMe != currentProfile.aboutMe) {
        final updateProfile = currentProfile.copyWith(aboutMe: event.aboutMe);
        emit(
          PendingProfileState(
            initialProfile: currentProfile,
            profile: updateProfile,
          ),
        );
      } else {
        emit(
          PendingProfileState(
            initialProfile: currentProfile,
            profile: currentProfile,
          ),
        );
      }
      currentState = state as PendingProfileState;
      currentProfile = currentState.profile;
      add(SaveProfileEvent(currentProfile));
    }
  }

  void _cancelEditing(
    CancelEditingEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      emit(ProfileState(profile: currentState.initialProfile));
    }
  }

  FutureOr<void> _saveProfile(
    SaveProfileEvent event,
    Emitter<BaseProfileState> emit,
  ) async {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      final initialProfile = currentState.initialProfile;
      final currentProfile = currentState.profile;
      if (currentProfile != initialProfile) {
        try {
          emit(
            SavingProfileState(
              profile: currentProfile,
              initialProfile: initialProfile,
            ),
          );
          await _profileRepository.saveProfile(currentProfile);
          emit(ProfileSavedSuccessfullyState(profile: currentProfile));
          emit(ProfileState(profile: currentProfile));
        } on Exception catch (_) {
          emit(
            ProfileSaveFailedState(
              profile: currentProfile,
              initialProfile: initialProfile,
            ),
          );
          emit(
            PendingProfileState(
              initialProfile: initialProfile,
              profile: currentProfile,
            ),
          );
        }
      }
    }
  }
}
