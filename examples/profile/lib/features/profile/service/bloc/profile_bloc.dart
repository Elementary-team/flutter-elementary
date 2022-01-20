import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/mock_profile_repository.dart';

/// Bloc for working with profile states.
class ProfileBloc extends Bloc<BaseProfileEvent, BaseProfileState> {
  final MockProfileRepository _mockProfileRepository;

  Profile? _initialProfile;
  Profile? _currentProfile;

  /// Create an instance [ProfileBloc].
  ProfileBloc(
    this._mockProfileRepository,
  ) : super(InitProfileState()) {
    on<ProfileLoadEvent>(_loadProfile);
    on<SaveFullNameEvent>(_saveFullName);
    on<SavePlaceResidenceEvent>(_savePlaceResidence);
    on<SaveAboutMeInfoEvent>(_saveAboutMeInfo);
    on<UndoEditingEvent>(_undoEditing);
  }

  FutureOr<void> _loadProfile(
    ProfileLoadEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    final state = this.state;
    if (state is InitProfileState || state is ProfileState) {
      Profile? profile;
      try {
        profile = _mockProfileRepository.getProfile();
        _initialProfile = profile;
        emit(ProfileState(profile));
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {
        emit(ErrorLoadingState());
      }
    }
  }

  void _saveFullName(
    SaveFullNameEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is! PendingProfileState) {
      final currentState = state as ProfileState;
      final profile = currentState.profile;
      final currentSurname = profile.surname;
      final currentName = profile.name;
      final currentPatronymic = profile.patronymic;
      final currentBirthday = profile.birthday;

      if (currentSurname != _currentProfile!.surname ||
          currentName != _currentProfile!.name ||
          currentPatronymic != _currentProfile!.patronymic ||
          currentBirthday != _currentProfile!.birthday) {
        emit(PendingProfileState(profile: profile));
        _currentProfile = profile;
      }
    }
  }

  void _savePlaceResidence(
    SavePlaceResidenceEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    final currentState = state as ProfileState;
    final profile = currentState.profile;
    final placeResidence = profile.placeOfResidence;
    if (_currentProfile!.placeOfResidence != placeResidence) {
      emit(PendingProfileState(profile: profile));
      _currentProfile = profile;
    }
  }

  void _saveAboutMeInfo(
    SaveAboutMeInfoEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    final currentState = state as PendingProfileState;
    final profile = currentState.profile;
    final aboutMeInfo = profile.aboutMe;
    if (_currentProfile!.aboutMe != aboutMeInfo) {
      emit(PendingProfileState(profile: profile));
      _currentProfile = profile;
    }
    _saveProfile(profile);
  }

  FutureOr<void> _undoEditing(
    UndoEditingEvent event,
    Emitter<BaseProfileState> emit,
  ) {
    if (state is PendingProfileState) {
      emit(InitProfileState());
    }
  }

  void _saveProfile(Profile profile) {
    if (profile != _initialProfile) {
      _mockProfileRepository.saveProfile(profile);
    }
  }
}
