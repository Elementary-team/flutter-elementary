import 'package:equatable/equatable.dart';
import 'package:profile/features/profile/domain/profile.dart';

/// Basic profile event.
abstract class BaseProfileEvent extends Equatable {
  @override
  List<Object> get props => [];

  /// Constructor.
  const BaseProfileEvent();
}

/// Base class for updating user data.
abstract class ProfileUpdateEvent extends BaseProfileEvent {
  @override
  List<Object> get props => [];

  /// Constructor.
  const ProfileUpdateEvent();
}

/// Profile load event.
class ProfileLoadEvent extends BaseProfileEvent {}

/// Save full name and birthday in profile event.
class SavePersonalDataEvent extends ProfileUpdateEvent {
  /// User surname.
  final String? surname;

  /// User name.
  final String? name;

  /// User patronymic.
  final String? patronymic;

  /// User birthday.
  final DateTime? birthday;

  /// Create an instance [SavePersonalDataEvent].
  const SavePersonalDataEvent({
    this.surname,
    this.name,
    this.patronymic,
    this.birthday,
  });
}

/// Save place of residence in profile event.
class SavePlaceResidenceEvent extends ProfileUpdateEvent {
  /// User place of residence.
  final String? placeResidence;

  /// Create an instance [SavePlaceResidenceEvent].
  const SavePlaceResidenceEvent({this.placeResidence});
}

/// Save list interests in profile event.
class SaveInterestsEvent extends ProfileUpdateEvent {
  /// Profile.
  final List<String>? interests;

  /// Create an instance [SaveInterestsEvent].
  const SaveInterestsEvent({this.interests});
}

/// Save user info in profile event.
class SaveAboutMeInfoEvent extends ProfileUpdateEvent {
  /// Profile.
  final String? aboutMe;

  /// Create an instance [SavePlaceResidenceEvent].
  const SaveAboutMeInfoEvent({this.aboutMe});
}

/// Save profile event.
class SaveProfileEvent extends BaseProfileEvent {
  /// Profile.
  final Profile profile;

  /// Create an instance [SavePlaceResidenceEvent].
  const SaveProfileEvent(this.profile);
}

/// Undo editing.
class UndoEditingEvent extends BaseProfileEvent {}
