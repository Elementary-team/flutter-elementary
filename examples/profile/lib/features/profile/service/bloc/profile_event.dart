import 'package:equatable/equatable.dart';
import 'package:profile/features/profile/domain/profile.dart';

/// Basic profile event.
abstract class BaseProfileEvent extends Equatable {
  @override
  List<Object> get props => [];

  /// Constructor.
  const BaseProfileEvent();
}

/// Profile load event.
class ProfileLoadEvent extends BaseProfileEvent {}

/// Save full name and birthday in profile event.
class SaveFullNameEvent extends BaseProfileEvent {
  /// Profile.
  final Profile profile;

  /// Create an instance [SaveFullNameEvent].
  const SaveFullNameEvent(this.profile);
}

/// Save place of residence in profile event.
class SavePlaceResidenceEvent extends BaseProfileEvent {
  /// Profile.
  final Profile profile;

  /// Create an instance [SavePlaceResidenceEvent].
  const SavePlaceResidenceEvent(this.profile);
}

/// Save user info in profile event.
class SaveAboutMeInfoEvent extends BaseProfileEvent {
  /// Profile.
  final Profile profile;

  /// Create an instance [SavePlaceResidenceEvent].
  const SaveAboutMeInfoEvent(this.profile);
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
