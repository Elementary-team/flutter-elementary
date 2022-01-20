import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';

/// Model for [AboutMeScreen].
class AboutMeScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [AboutMeScreenModel].
  AboutMeScreenModel(
      this._profileBloc,
      ErrorHandler errorHandler,
      ) : super(errorHandler: errorHandler);


  /// Method for save about user info.
  void saveAboutMeInfo(String? aboutMe) {
    if (_profileBloc.state is ProfileState) {
      final state = _profileBloc.state as ProfileState;
      var currentProfile = state.profile;
      if(currentProfile.aboutMe != aboutMe || aboutMe == null) {
        currentProfile = currentProfile.copyWith(aboutMe: aboutMe);
        _profileBloc.add(SaveAboutMeInfoEvent(currentProfile));
      }
    }
  }
}
