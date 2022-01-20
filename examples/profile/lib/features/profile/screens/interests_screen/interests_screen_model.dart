import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';

/// Model for [InterestsScreen].
class InterestsScreenModel extends ElementaryModel{
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [InterestsScreenModel].
  InterestsScreenModel(
      this._profileBloc,
      ErrorHandler errorHandler,
      ) : super(errorHandler: errorHandler);
}
