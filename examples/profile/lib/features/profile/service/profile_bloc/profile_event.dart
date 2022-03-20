import 'package:equatable/equatable.dart';

/// Basic profile event.
abstract class BaseProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];

  /// Constructor.
  const BaseProfileEvent();
}

/// Base class for updating user data.
abstract class ProfileUpdateEvent extends BaseProfileEvent {
  /// User surname.
  final String? surname;

  /// User name.
  final String? name;

  /// User secondName.
  final String? secondName;

  /// User birthday.
  final DateTime? birthday;

  /// User place of residence.
  final String? placeResidence;

  /// User interests.
  final List<String>? interests;

  /// User info about himself.
  final String? aboutMe;

  @override
  List<Object?> get props => [
        surname,
        name,
        secondName,
        birthday,
        placeResidence,
        interests,
        aboutMe,
      ];

  /// Constructor.
  const ProfileUpdateEvent({
    this.surname,
    this.name,
    this.secondName,
    this.birthday,
    this.placeResidence,
    this.interests,
    this.aboutMe,
  });
}

/// Profile load event.
class ProfileLoadEvent extends BaseProfileEvent {}

/// Save full name and birthday in profile event.
class UpdatePersonalDataEvent extends ProfileUpdateEvent {
  /// Create an instance [UpdatePersonalDataEvent].
  const UpdatePersonalDataEvent({
    String? surname,
    String? name,
    String? secondName,
    DateTime? birthday,
  }) : super(
          surname: surname,
          name: name,
          secondName: secondName,
          birthday: birthday,
        );
}

/// Save place of residence in profile event.
class UpdatePlaceResidenceEvent extends ProfileUpdateEvent {
  /// Create an instance [UpdatePlaceResidenceEvent].
  const UpdatePlaceResidenceEvent({String? placeResidence})
      : super(placeResidence: placeResidence);
}

/// Save list interests in profile event.
class UpdateInterestsEvent extends ProfileUpdateEvent {
  /// Create an instance [UpdateInterestsEvent].
  const UpdateInterestsEvent({List<String>? interests})
      : super(interests: interests);
}

/// Save user info in profile event.
class UpdateAboutMeInfoEvent extends ProfileUpdateEvent {
  /// Create an instance [UpdatePlaceResidenceEvent].
  const UpdateAboutMeInfoEvent({String? aboutMe}) : super(aboutMe: aboutMe);
}

/// Save profile event.
class SaveProfileEvent extends BaseProfileEvent {
  /// Create an instance [SaveProfileEvent].
  const SaveProfileEvent();
}

/// Cancel editing.
class CancelEditingEvent extends BaseProfileEvent {}
