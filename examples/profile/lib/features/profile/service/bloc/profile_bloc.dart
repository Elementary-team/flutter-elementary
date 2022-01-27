import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/mock_profile_repository.dart';

// ignore_for_file: avoid_catches_without_on_clauses

/// Bloc for working with profile states.
class ProfileBloc extends Bloc<BaseProfileEvent, BaseProfileState> {
  final MockProfileRepository _mockProfileRepository;

  /// Create an instance [ProfileBloc].
  ProfileBloc(
    this._mockProfileRepository,
  ) : super(InitProfileState()) {
    on<ProfileLoadEvent>(_loadProfile);
    on<SavePersonalDataEvent>(_savePersonalData);
    on<SavePlaceResidenceEvent>(_savePlaceResidence);
    on<SaveInterestsEvent>(_saveListInterests);
    on<SaveAboutMeInfoEvent>(_saveAboutMeInfo);
    on<SaveProfileEvent>(_saveProfile);
    on<UndoEditingEvent>(_undoEditing);
  }

  FutureOr<void> _loadProfile(
    ProfileLoadEvent event,
    Emitter<BaseProfileState> emit,
  ) async {
    final state = this.state;
    if (state is InitProfileState || state is ProfileState) {
      Profile? profile;
      try {
        profile = await _mockProfileRepository.getProfile();
        emit(ProfileState(profile));
      } catch (_) {
        emit(ErrorLoadingState());
      }
    }
  }

  void _savePersonalData(
    SavePersonalDataEvent event,
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
    SavePlaceResidenceEvent event,
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
    SaveInterestsEvent event,
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

  void _saveAboutMeInfo(
    SaveAboutMeInfoEvent event,
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

  void _undoEditing(
    UndoEditingEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      final currentState = state as PendingProfileState;
      emit(ProfileState(currentState.initialProfile));
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
          emit(SavingProfileState());
          await _mockProfileRepository.saveProfile(currentProfile);
          emit(ProfileSavedSuccessfullyState(currentProfile));
          emit(ProfileState(currentProfile));
        } catch (_) {
          emit(
            ErrorSaveState(),
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
