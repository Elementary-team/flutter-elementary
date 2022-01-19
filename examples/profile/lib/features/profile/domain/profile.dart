import 'package:equatable/equatable.dart';

/// User profile.
class Profile {
  /// User surname.
  final String? surname;

  /// User name.
  final String? name;

  /// User second name(optional).
  final String? patronymic;

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
    this.birthday,
    this.placeOfResidence,
    this.interests,
    this.patronymic,
    this.aboutMe,
  });
}
