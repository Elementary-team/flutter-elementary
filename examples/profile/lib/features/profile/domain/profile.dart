import 'package:flutter/foundation.dart';

/// User profile.
class Profile {
  /// User surname.
  final String? surname;

  /// User name.
  final String? name;

  /// User second name(optional).
  final String? secondName;

  /// User birthday.
  final DateTime? birthday;

  /// User place of residence.
  final String? placeOfResidence;

  /// User interests.
  final List<String>? interests;

  /// Section about the user with information that he will write about
  /// himself(optional).
  final String? aboutMe;

  /// Create an instance [Profile].
  const Profile({
    this.surname,
    this.name,
    this.secondName,
    this.birthday,
    this.placeOfResidence,
    this.interests,
    this.aboutMe,
  });

  /// Creates a copy of this input decoration with the given fields replaced
  /// by the new values.
  Profile copyWith({
    String? surname,
    String? name,
    String? secondName,
    DateTime? birthday,
    String? placeOfResidence,
    List<String>? interests,
    String? aboutMe,
  }) =>
      Profile(
        surname: surname ?? this.surname,
        name: name ?? this.name,
        secondName: secondName ?? this.secondName,
        birthday: birthday ?? this.birthday,
        placeOfResidence: placeOfResidence ?? this.placeOfResidence,
        interests: interests ?? this.interests,
        aboutMe: aboutMe ?? this.aboutMe,
      );

  /// The method that checks the fields of two different instances of the
  /// profile, if the fields are equal, it will return true.
  bool isSame(Profile otherProfile) {
    return surname == otherProfile.surname &&
        name == otherProfile.name &&
        secondName == otherProfile.secondName &&
        birthday == otherProfile.birthday &&
        placeOfResidence == otherProfile.placeOfResidence &&
        listEquals(interests, otherProfile.interests) &&
        aboutMe == otherProfile.aboutMe;
  }
}
