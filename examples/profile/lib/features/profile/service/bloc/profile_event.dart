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

/// Save profile event.
class SaveFullNameEvent extends BaseProfileEvent {
  /// Profile.
  final Profile profile;

  /// Create an instance [SaveFullNameEvent].
  const SaveFullNameEvent(this.profile);
}

/// Undo editing.
class UndoEditingEvent extends BaseProfileEvent {}
