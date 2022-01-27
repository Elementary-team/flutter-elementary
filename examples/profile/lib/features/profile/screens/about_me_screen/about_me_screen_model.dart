import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';

/// Model for [AboutMeScreen].
class AboutMeScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Stream to track the state of the bloc.
  Stream<BaseProfileState> get profileStateStream => _profileBloc.stream;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [AboutMeScreenModel].
  AboutMeScreenModel(
    this._profileBloc,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Method for save info about user.
  void saveAboutMeInfo(String? aboutMe) {
    _profileBloc.add(SaveAboutMeInfoEvent(aboutMe: aboutMe));
  }
}
